#!/usr/bin/env python3
"""
Sync Postman collection from OpenAPI spec.

This script generates a Postman collection from openapi.yaml while preserving
custom variables and OIDC authentication flows from the existing collection.
"""

import json
import sys
import os
import subprocess
from pathlib import Path

# Paths
SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent
OPENAPI_SPEC = PROJECT_ROOT / "backend" / "openapi.yaml"
POSTMAN_COLLECTION = PROJECT_ROOT / "postman" / "XBillr.postman_collection.json"
TEMP_COLLECTION = PROJECT_ROOT / "postman" / "XBillr.postman_collection.tmp.json"
POSTMAN_CONFIG = PROJECT_ROOT / "postman" / "postman-config.yaml"


def find_converter():
    """Find available OpenAPI to Postman converter."""
    # Try openapi-to-postman-complete first
    try:
        result = subprocess.run(
            ["which", "openapi-to-postman-complete"],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        pass
    
    # Try npx
    try:
        subprocess.run(
            ["which", "npx"],
            capture_output=True,
            check=True
        )
        return "npx"
    except subprocess.CalledProcessError:
        pass
    
    return None


def convert_openapi_to_postman(converter, openapi_spec, config_file, output_file):
    """Convert OpenAPI spec to Postman collection."""
    if converter == "npx":
        cmd = ["npx", "--yes", "openapi-to-postman-complete", str(openapi_spec), str(config_file), "-o", str(output_file)]
    else:
        cmd = [converter, str(openapi_spec), str(config_file), "-o", str(output_file)]
    
    print(f"Converting OpenAPI spec to Postman collection...")
    print(f"Command: {' '.join(cmd)}")
    
    try:
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        if result.stdout:
            print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error: Failed to convert OpenAPI spec", file=sys.stderr)
        if e.stdout:
            print(e.stdout, file=sys.stderr)
        if e.stderr:
            print(e.stderr, file=sys.stderr)
        return False
    except FileNotFoundError:
        print(f"Error: Converter not found. Install with:", file=sys.stderr)
        print(f"  npm install -g openapi-to-postman-complete", file=sys.stderr)
        return False


def find_item_by_name(items, name):
    """Find an item in a list by name."""
    for item in items:
        if item.get("name") == name:
            return item
    return None


def preserve_oidc_items(old_auth_items, new_auth_items):
    """Preserve OIDC-related items from old collection."""
    oidc_items = []
    for item in old_auth_items:
        item_name = item.get("name", "")
        if "OIDC" in item_name or "oidc" in item_name.lower():
            oidc_items.append(item)
    
    # Remove existing OIDC items from new collection
    filtered_items = [
        item for item in new_auth_items
        if "OIDC" not in item.get("name", "") and "oidc" not in item.get("name", "").lower()
    ]
    
    # Add preserved OIDC items
    filtered_items.extend(oidc_items)
    return filtered_items


def find_nested_item(items, path):
    """Find a nested item by path (e.g., ['api', 'auth'])."""
    current = items
    for name in path:
        if isinstance(current, list):
            item = find_item_by_name(current, name)
            if item:
                current = item.get("item", [])
            else:
                return None
        else:
            return None
    return current


def merge_collections(new_collection, old_collection):
    """Merge new collection with old collection, preserving custom content."""
    # Preserve variables from old collection
    if "variable" in old_collection:
        new_collection["variable"] = old_collection["variable"]
        print("Preserved custom variables")
    
    # Preserve OIDC flows in Auth folder
    # New collection has: api -> auth (lowercase)
    # Old collection has: Auth (top level)
    if "item" in new_collection and "item" in old_collection:
        # Try to find auth folder in new collection (nested under api)
        new_api_folder = find_item_by_name(new_collection["item"], "api")
        new_auth_folder = None
        if new_api_folder:
            new_auth_folder = find_item_by_name(new_api_folder.get("item", []), "auth")
        
        # Find Auth folder in old collection (top level)
        old_auth_folder = find_item_by_name(old_collection["item"], "Auth")
        
        if new_auth_folder and old_auth_folder:
            new_auth_items = new_auth_folder.get("item", [])
            old_auth_items = old_auth_folder.get("item", [])
            
            merged_items = preserve_oidc_items(old_auth_items, new_auth_items)
            new_auth_folder["item"] = merged_items
            oidc_count = len([i for i in old_auth_items if 'OIDC' in i.get('name', '') or 'oidc' in i.get('name', '').lower()])
            if oidc_count > 0:
                print(f"Preserved {oidc_count} OIDC flow items")
    
    return new_collection


def main():
    """Main function."""
    # Check if OpenAPI spec exists
    if not OPENAPI_SPEC.exists():
        print(f"Error: {OPENAPI_SPEC} not found", file=sys.stderr)
        sys.exit(1)
    
    # Check if config file exists
    if not POSTMAN_CONFIG.exists():
        print(f"Error: {POSTMAN_CONFIG} not found", file=sys.stderr)
        print("The postman-config.yaml file is required for conversion.", file=sys.stderr)
        sys.exit(1)
    
    # Find converter
    converter = find_converter()
    if not converter:
        print("Error: No OpenAPI to Postman converter found.", file=sys.stderr)
        print("Install one with: npm install -g openapi-to-postman-complete", file=sys.stderr)
        sys.exit(1)
    
    # Convert OpenAPI to Postman
    if not convert_openapi_to_postman(converter, OPENAPI_SPEC, POSTMAN_CONFIG, TEMP_COLLECTION):
        sys.exit(1)
    
    # Check if temp collection was created
    if not TEMP_COLLECTION.exists():
        print(f"Error: Generated collection not found at {TEMP_COLLECTION}", file=sys.stderr)
        sys.exit(1)
    
    # Load generated collection
    try:
        with open(TEMP_COLLECTION, "r") as f:
            new_collection = json.load(f)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in generated collection: {e}", file=sys.stderr)
        sys.exit(1)
    
    # Merge with existing collection if it exists
    if POSTMAN_COLLECTION.exists():
        print("Merging with existing collection...")
        try:
            with open(POSTMAN_COLLECTION, "r") as f:
                old_collection = json.load(f)
            
            new_collection = merge_collections(new_collection, old_collection)
        except json.JSONDecodeError as e:
            print(f"Warning: Failed to parse existing collection: {e}", file=sys.stderr)
            print("Using generated collection as-is", file=sys.stderr)
    
    # Write merged collection
    try:
        with open(POSTMAN_COLLECTION, "w") as f:
            json.dump(new_collection, f, indent=2)
        print(f"Postman collection synced successfully: {POSTMAN_COLLECTION}")
    except Exception as e:
        print(f"Error: Failed to write collection: {e}", file=sys.stderr)
        sys.exit(1)
    finally:
        # Clean up temp file
        if TEMP_COLLECTION.exists():
            TEMP_COLLECTION.unlink()
    
    sys.exit(0)


if __name__ == "__main__":
    main()
