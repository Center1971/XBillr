package eu.smetools.keycloak;

import org.keycloak.events.Event;
import org.keycloak.events.EventListenerProvider;
import org.keycloak.events.EventType;
import org.keycloak.events.admin.AdminEvent;
import org.keycloak.models.*;
import java.util.Map;
import java.util.List;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.stream.Collectors;

import org.jboss.logging.Logger;

public class CompanyProvisionerEventListenerProvider implements EventListenerProvider {
    
    private static final Logger log = Logger.getLogger(CompanyProvisionerEventListenerProvider.class);
    private final KeycloakSession session;
    
    public CompanyProvisionerEventListenerProvider(KeycloakSession session) {
        this.session = session;
    }
    
    @Override
    public void onEvent(Event event) {
        // NUR REGISTER events verarbeiten, alles andere nur loggen
        if (event.getType() == EventType.REGISTER) {
            log.warnf("Registration event received for user: %s", event.getUserId());
            processRegistration(event);
        }
        
        // Login events für Debugging
        if (event.getType() == EventType.LOGIN || event.getType() == EventType.LOGIN_ERROR) {
            log.warnf("Login event: %s, userId: %s", event.getType(), event.getUserId());
        }
    }
    
    private void processRegistration(Event event) {
        try {
            RealmModel realm = session.realms().getRealm(event.getRealmId());
            UserModel user = session.users().getUserById(realm, event.getUserId());
            
            if (user == null) {
                log.warnf("User not found for registration event");
                return;
            }
            
            log.warnf("Processing registration for user: %s", user.getUsername());
            
            // 1. Company bestimmen
            String company = determineCompany(user);
            log.warnf("Determined company: %s", company);
            
            // 2. Company als Attribut speichern
            user.setSingleAttribute("company", company);
            
            // 3. Company-Gruppe erstellen/zugehörig
            handleCompanyGroup(realm, user, company);
            
            log.warnf("Registration processing completed for user: %s", user.getUsername());
            
        } catch (Exception e) {
            log.warnf("Error in registration processing: %s", e.getMessage());
        }
    }
    
    private String determineCompany(UserModel user) {
        // 1. Erst aus User-Attributen (falls schon gesetzt durch Formular)
        String company = user.getFirstAttribute("company");
        
        // 2. Falls nicht gesetzt, aus Email extrahieren
        if (company == null || company.trim().isEmpty()) {
            company = extractCompanyFromEmail(user.getEmail());
            if (company == null || company.trim().isEmpty()) {
                company = "Unknown";
            }
        }
        
        return company.trim();
    }
    
    private String extractCompanyFromEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        
        try {
            int atIndex = email.indexOf('@');
            if (atIndex == -1) return null;
            
            String domain = email.substring(atIndex + 1);
            
            // Remove TLD
            int lastDot = domain.lastIndexOf('.');
            if (lastDot != -1) {
                domain = domain.substring(0, lastDot);
            }
            
            // Remove www prefix
            if (domain.startsWith("www.")) {
                domain = domain.substring(4);
            }
            
            // Capitalize
            if (!domain.isEmpty()) {
                domain = Character.toUpperCase(domain.charAt(0)) + 
                        (domain.length() > 1 ? domain.substring(1) : "");
            }
            
            return domain;
        } catch (Exception e) {
            return null;
        }
    }
    
    private void handleCompanyGroup(RealmModel realm, UserModel user, String companyName) {
        try {
            // 1. Suche nach existierender Gruppe (case-insensitive mit Stream API)
            GroupModel companyGroup = null;
            
            // KORREKTUR: getGroupsStream() statt getGroups()
            List<GroupModel> matchingGroups = realm.getGroupsStream()
                .filter(group -> companyName.equalsIgnoreCase(group.getName()))
                .collect(Collectors.toList());
            
            if (!matchingGroups.isEmpty()) {
                companyGroup = matchingGroups.get(0);
                log.warnf("Found existing company group: %s", companyName);
            }
            
            // 2. Gruppe erstellen wenn nicht existiert
            if (companyGroup == null) {
                companyGroup = realm.createGroup(companyName);
                companyGroup.setSingleAttribute("type", "company");
                companyGroup.setSingleAttribute("auto_created", "true");
                log.warnf("Created new company group: %s", companyName);
            }
            
            // 3. User der Gruppe zuweisen (wenn nicht schon Mitglied)
            if (!user.isMemberOf(companyGroup)) {
                user.joinGroup(companyGroup);
                log.warnf("Assigned user %s to company group: %s", user.getUsername(), companyName);
                
                // Attribute setzen
                user.setSingleAttribute("company_group", companyName);
                user.setSingleAttribute("company_group_id", companyGroup.getId());
            } else {
                log.warnf("User already in company group: %s", companyName);
            }
            
        } catch (Exception e) {
            log.warnf("Error handling company group: %s", e.getMessage());
        }
    }
    
    @Override
    public void onEvent(AdminEvent event, boolean includeRepresentation) {
        // Ignore admin events
    }
    
    @Override
    public void close() {
        // Cleanup
    }
}
