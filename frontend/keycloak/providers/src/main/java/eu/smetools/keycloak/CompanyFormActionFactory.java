package eu.smetools.keycloak;

import org.keycloak.Config;
import org.keycloak.authentication.FormAction;
import org.keycloak.authentication.FormActionFactory;
import org.keycloak.models.AuthenticationExecutionModel;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;
import org.keycloak.provider.ProviderConfigProperty;

import java.util.List;
import java.util.Arrays;
import java.util.Collections;

public class CompanyFormActionFactory implements FormActionFactory {
    
    @Override
    public String getId() {
        return "company-form-action";
    }
    
    @Override
    public String getDisplayType() {
        return "Company Attribute";
    }
    
    @Override
    public String getHelpText() {
        return "Saves company attribute from registration form";
    }
    
    @Override
    public String getReferenceCategory() {
        return null; // Kann null sein
    }
    
    @Override
    public boolean isConfigurable() {
        return false;
    }
    
    @Override
    public AuthenticationExecutionModel.Requirement[] getRequirementChoices() {
        // WICHTIG: Diese Methode muss implementiert werden!
        return new AuthenticationExecutionModel.Requirement[] {
            AuthenticationExecutionModel.Requirement.REQUIRED,
            AuthenticationExecutionModel.Requirement.ALTERNATIVE,
            AuthenticationExecutionModel.Requirement.DISABLED,
            AuthenticationExecutionModel.Requirement.CONDITIONAL
        };
    }
    
    @Override
    public boolean isUserSetupAllowed() {
        return false;
    }
    
    @Override
    public List<ProviderConfigProperty> getConfigProperties() {
        return null; // Kann null sein wenn isConfigurable() false
    }
    
    @Override
    public FormAction create(KeycloakSession session) {
        return new CompanyFormAction();
    }
    
    @Override
    public void init(Config.Scope config) {
        // Initialization
    }
    
    @Override
    public void postInit(KeycloakSessionFactory factory) {
        // Post initialization
    }
    
    @Override
    public void close() {
        // Cleanup
    }
}
