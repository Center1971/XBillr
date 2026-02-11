<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username'); section>
    <#if section = "header">
        ${msg("emailForgotTitle")}
    <#elseif section = "form">
        <div id="kc-form">
            <div id="kc-form-wrapper">
                <form id="kc-reset-password-form" action="${url.loginAction}" method="post">
                    <div class="form-group">
                        <label for="username" class="${properties.kcLabelClass!}">
                            <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
                        </label>
                        <input type="text" id="username" name="username" autofocus value="${(auth.attemptedUsername!'')}"
                               aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                        />
                        <#if messagesPerField.existsError('username')>
                            <span id="input-error-username" class="alert alert-error" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('username'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <div id="kc-form-buttons">
                        <input class="btn-primary" type="submit" value="${msg("doSubmit")}"/>
                    </div>
                </form>
            </div>
        </div>
    <#elseif section = "info" >
        <div id="kc-registration">
            <span><a href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a></span>
        </div>
    </#if>
</@layout.registrationLayout>
