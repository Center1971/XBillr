package eu.smetools.keycloak;

import org.keycloak.authentication.FormAction;
import org.keycloak.authentication.FormContext;
import org.keycloak.authentication.ValidationContext;
import org.keycloak.forms.login.LoginFormsProvider;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CompanyFormAction implements FormAction {
    
    private static final Logger logger = LoggerFactory.getLogger(CompanyFormAction.class);
    
    @Override
    public void buildPage(FormContext context, LoginFormsProvider form) {
        // Nothing to do
    }
    
    @Override
    public void validate(ValidationContext context) {
        String company = context.getHttpRequest()
            .getDecodedFormParameters()
            .getFirst("user.attributes.company");
        
        logger.warn("Company from form: '{}'", company);
        
        if (company != null && !company.trim().isEmpty()) {
            context.getAuthenticationSession()
                .setAuthNote("COMPANY_ATTRIBUTE", company.trim());
            logger.warn("Saved company to auth session: '{}'", company);
        }
        
        context.success();
    }
    
    @Override
    public void success(FormContext context) {
        UserModel user = context.getUser();
        String company = context.getAuthenticationSession()
            .getAuthNote("COMPANY_ATTRIBUTE");
        
        logger.warn("Processing company for user: {}", user.getUsername());
        
        if (company != null && !company.trim().isEmpty()) {
            user.setSingleAttribute("company", company.trim());
            logger.warn("Saved company '{}' for user {}", company, user.getUsername());
            
            // Debug: Alle Attribute ausgeben
            user.getAttributes().forEach((key, values) -> {
                logger.warn("  Attribute {} = {}", key, values);
            });
        }
    }
    
    @Override
    public boolean requiresUser() {
        return false;
    }
    
    @Override
    public boolean configuredFor(KeycloakSession session, RealmModel realm, UserModel user) {
        return true;
    }
    
    @Override
    public void setRequiredActions(KeycloakSession session, RealmModel realm, UserModel user) {
        // Nothing to do
    }
    
    @Override
    public void close() {
        // Nothing to do
    }
}
