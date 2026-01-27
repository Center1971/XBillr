# SME Tools Custom Keycloak Theme

This directory contains a custom Keycloak theme for SME Tools that matches the application's login page design.

## Theme Structure

```
smetools/
├── login/
│   ├── resources/
│   │   ├── css/
│   │   │   └── login.css          # Custom styling matching SME Tools
│   │   └── img/
│   │       └── logo.svg           # SME Tools logo
│   ├── messages/
│   │   ├── messages_de.properties # German translations
│   │   └── messages_en.properties # English translations
│   ├── theme.properties           # Theme configuration
│   ├── template.ftl               # Base template layout
│   ├── login.ftl                  # Login page template
│   ├── register.ftl               # Registration page template
│   ├── login-reset-password.ftl   # Password reset template
│   ├── login-update-password.ftl  # Password update template
│   ├── error.ftl                  # Error page template
│   └── info.ftl                   # Info page template
```

## Installation

### Option 1: Docker Volume Mount (Development)

If you're running Keycloak in Docker, mount the theme directory:

```bash
docker run -d \
  --name keycloak \
  -p 8080:8080 \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  -v /path/to/SME Tools/frontend/keycloak:/opt/keycloak/themes \
  quay.io/keycloak/keycloak:latest start-dev
```

### Option 2: Copy to Keycloak Installation (Production)

1. Copy the `smetools` directory to your Keycloak themes directory:

```bash
# For standalone Keycloak installation
cp -r frontend/keycloak/smetools /opt/keycloak/themes/

# For Docker container (requires restart)
docker cp frontend/keycloak/smetools <container-name>:/opt/keycloak/themes/
docker restart <container-name>
```

2. Set correct permissions:

```bash
chown -R keycloak:keycloak /opt/keycloak/themes/smetools
chmod -R 755 /opt/keycloak/themes/smetools
```

## Configuration

### 1. Enable Theme in Keycloak Admin Console

1. Log in to Keycloak Admin Console
2. Select your realm (e.g., `smetools`)
3. Go to **Realm Settings** → **Themes**
4. Set **Login theme** to `smetools`
5. Click **Save**

### 2. Configure Realm Settings

Ensure your realm has the following settings:

- **Login** tab:
  - ☑ User registration enabled (if you want registration)
  - ☑ Forgot password enabled
  - ☑ Remember me enabled
  - ☑ Email as username (optional)

- **Email** tab:
  - Configure SMTP settings for password reset and verification emails

### 3. Client Configuration

For your SME Tools client:

1. Go to **Clients** → `web` (or your client ID)
2. Settings:
   - **Access Type**: `confidential`
   - **Valid Redirect URIs**: 
     - `https://www.smetools.eu/api/auth/oidc/callback`
     - `http://localhost:3002/api/auth/oidc/callback` (for development)
   - **Web Origins**: 
     - `https://www.smetools.eu`
     - `http://localhost:8082` (for development)

## Theme Customization

### Changing Colors

Edit `resources/css/login.css`:

```css
/* Change gradient background */
body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

/* Change primary button color */
.btn-primary {
    background: #1976d2;
}
```

### Changing Logo

Replace `resources/img/logo.svg` with your logo (maintain aspect ratio ~200px wide).

### Changing Text

Edit the message property files:
- German: `messages/messages_de.properties`
- English: `messages/messages_en.properties`

Example:

```properties
loginTitle=My Custom App - Login
loginSubtitle=My Tagline
```

## Supported Pages

The theme includes templates for:

- **login.ftl**: Main login page with username/password
- **register.ftl**: User registration form
- **login-reset-password.ftl**: Password reset request
- **login-update-password.ftl**: Password change form
- **error.ftl**: Error pages
- **info.ftl**: Information/success pages

## Localization

The theme supports:
- **German (de)**: Default language
- **English (en)**: Secondary language

Users can switch languages in their browser settings or via Keycloak's language selector.

## Testing

1. **Development Mode**: Start Keycloak with cache disabled:

```bash
docker run -d \
  --name keycloak \
  -p 8080:8080 \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  -e KC_CACHE=local \
  -v /path/to/SME Tools/frontend/keycloak:/opt/keycloak/themes \
  quay.io/keycloak/keycloak:latest start-dev
```

2. **Test Login Flow**:
   - Navigate to `http://localhost:8082/login.html`
   - Click "Bei SME Tools anmelden"
   - You should see the custom themed Keycloak login page

3. **Test Registration**:
   - Click "Registrieren" on the login page
   - Fill out the registration form
   - Verify the styling matches SME Tools

## Troubleshooting

### Theme Not Showing

1. Check theme directory permissions:
```bash
ls -la /opt/keycloak/themes/smetools
```

2. Verify theme is in the correct location:
```bash
# Should show the smetools directory
ls /opt/keycloak/themes/
```

3. Clear Keycloak cache:
```bash
# In Keycloak container
rm -rf /opt/keycloak/data/cache/
```

4. Restart Keycloak:
```bash
docker restart keycloak
# OR
systemctl restart keycloak
```

### CSS Not Loading

1. Check browser console for 404 errors
2. Verify `theme.properties` has correct CSS reference:
```properties
styles=css/login.css
```

3. Check file permissions:
```bash
chmod 644 /opt/keycloak/themes/smetools/login/resources/css/login.css
```

### Logo Not Displaying

1. Verify logo path in `template.ftl`:
```html
<img src="${url.resourcesPath}/img/logo.svg" alt="SME Tools">
```

2. Check logo file exists:
```bash
ls -la /opt/keycloak/themes/smetools/login/resources/img/logo.svg
```

3. Test direct access:
```
http://your-keycloak:8080/realms/smetools/login/smetools/resources/img/logo.svg
```

### Language Not Switching

1. Verify locales in `theme.properties`:
```properties
locales=de,en
```

2. Check message files exist:
```bash
ls /opt/keycloak/themes/smetools/login/messages/
```

3. Ensure browser language matches available locales

## Advanced Customization

### Adding Social Login Buttons

The theme supports social identity providers. To style them, add to `login.css`:

```css
#kc-social-providers a[id*="google"] {
    background: #4285F4;
    color: white;
}

#kc-social-providers a[id*="github"] {
    background: #333;
    color: white;
}
```

### Adding Custom JavaScript

1. Create `resources/js/custom.js`
2. Add to `theme.properties`:
```properties
scripts=js/custom.js
```

### Adding Favicon

1. Place favicon in `resources/img/favicon.ico`
2. Update `theme.properties`:
```properties
favicon=/resources/img/favicon.ico
```

## Production Deployment

1. Build a JAR file for better performance:

```bash
cd /opt/keycloak/themes
jar -cf smetools.jar smetools/
```

2. Remove the directory and keep only the JAR:

```bash
rm -rf smetools/
```

3. Restart Keycloak to use the JAR

## Support

For issues or customization help, refer to:
- [Keycloak Theme Documentation](https://www.keycloak.org/docs/latest/server_development/#_themes)
- [Freemarker Template Guide](https://freemarker.apache.org/docs/)
