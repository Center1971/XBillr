package eu.smetools.keycloak;

import org.jboss.logging.Logger;
import org.keycloak.events.Event;
import org.keycloak.events.EventListenerProvider;
import org.keycloak.events.EventType;
import org.keycloak.events.admin.AdminEvent;
import org.keycloak.models.*;

import java.util.List;
import java.util.Map;

public class CompanyProvisionerEventListenerProvider implements EventListenerProvider {

    private static final Logger log = Logger.getLogger(CompanyProvisionerEventListenerProvider.class);
    private final KeycloakSession session;
    private final RealmProvider model;

    public CompanyProvisionerEventListenerProvider(KeycloakSession session) {
        this.session = session;
        this.model = session.realms();
    }

    @Override
    public void onEvent(Event event) {
        // Only handle REGISTER events
        if (EventType.REGISTER.equals(event.getType())) {
            log.infof("User registration detected: %s in realm %s", event.getUserId(), event.getRealmId());
            handleRegistration(event);
        }
    }

    @Override
    public void onEvent(AdminEvent adminEvent, boolean b) {
        // We don't need to handle admin events
    }

    private void handleRegistration(Event event) {
        try {
            RealmModel realm = model.getRealm(event.getRealmId());
            UserModel user = session.users().getUserById(realm, event.getUserId());

            if (user == null) {
                log.warnf("User not found: %s", event.getUserId());
                return;
            }

            // Get the company attribute from the user
            List<String> companyValues = user.getAttributeStream("company").toList();
            
            if (companyValues.isEmpty()) {
                log.warnf("No company attribute found for user: %s", user.getUsername());
                return;
            }

            String companyName = companyValues.get(0);
            
            if (companyName == null || companyName.trim().isEmpty()) {
                log.warnf("Company name is empty for user: %s", user.getUsername());
                return;
            }

            log.infof("Processing company '%s' for user '%s'", companyName, user.getUsername());

            // Find or create the group
            GroupModel companyGroup = findOrCreateGroup(realm, companyName);

            // Add user to the group
            if (!user.isMemberOf(companyGroup)) {
                user.joinGroup(companyGroup);
                log.infof("Added user '%s' to group '%s'", user.getUsername(), companyName);
            } else {
                log.infof("User '%s' already member of group '%s'", user.getUsername(), companyName);
            }

            // Assign group to clients
            assignGroupToClients(realm, companyGroup);

        } catch (Exception e) {
            log.errorf(e, "Error processing registration for user %s", event.getUserId());
        }
    }

    private GroupModel findOrCreateGroup(RealmModel realm, String groupName) {
        // Try to find existing group
        GroupModel group = realm.getGroupsStream()
                .filter(g -> groupName.equals(g.getName()))
                .findFirst()
                .orElse(null);

        if (group != null) {
            log.infof("Found existing group: %s", groupName);
            return group;
        }

        // Create new group
        group = realm.createGroup(groupName);
        log.infof("Created new group: %s", groupName);
        
        return group;
    }

    private void assignGroupToClients(RealmModel realm, GroupModel group) {
        // Get the clients we want to assign the group to
        String[] clientIds = {"xbillr-web", "xbillr-mobile"};

        for (String clientId : clientIds) {
            ClientModel client = realm.getClientByClientId(clientId);
            
            if (client == null) {
                log.warnf("Client not found: %s", clientId);
                continue;
            }

            // Create a client role for this group if it doesn't exist
            String roleName = "group-" + group.getName();
            RoleModel role = client.getRole(roleName);
            
            if (role == null) {
                role = client.addRole(roleName);
                log.infof("Created client role '%s' for client '%s'", roleName, clientId);
            }

            // Add the role to the group
            if (!group.hasRole(role)) {
                group.grantRole(role);
                log.infof("Granted role '%s' to group '%s' for client '%s'", 
                         roleName, group.getName(), clientId);
            } else {
                log.infof("Group '%s' already has role '%s' for client '%s'", 
                         group.getName(), roleName, clientId);
            }
        }
    }

    @Override
    public void close() {
        // Nothing to close
    }
}
