<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-confirm'); section>
    <#if section = "header">
        ${msg("updatePasswordTitle")}
    <#elseif section = "form">
        <div id="kc-form">
            <div id="kc-form-wrapper">
                <form id="kc-passwd-update-form" action="${url.loginAction}" method="post">
                    <input type="text" id="username" name="username" value="${username}" autocomplete="username" readonly="readonly" style="display:none;"/>
                    <input type="password" id="password" name="password" autocomplete="current-password" style="display:none;"/>

                    <div class="form-group">
                        <label for="password-new" class="${properties.kcLabelClass!}">${msg("passwordNew")}</label>
                        <input type="password" id="password-new" name="password-new" autofocus autocomplete="new-password"
                               aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                        />
                        <#if messagesPerField.existsError('password')>
                            <span id="input-error-password" class="alert alert-error" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('password'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <div class="form-group">
                        <label for="password-confirm" class="${properties.kcLabelClass!}">${msg("passwordConfirm")}</label>
                        <input type="password" id="password-confirm" name="password-confirm" autocomplete="new-password"
                               aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                        />
                        <#if messagesPerField.existsError('password-confirm')>
                            <span id="input-error-password-confirm" class="alert alert-error" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <div id="kc-form-buttons">
                        <#if isAppInitiatedAction??>
                            <input class="btn-primary" type="submit" value="${msg("doSubmit")}" />
                            <button class="btn-secondary" type="submit" name="cancel-aia" value="true" />${msg("doCancel")}</button>
                        <#else>
                            <input class="btn-primary" type="submit" value="${msg("doSubmit")}" />
                        </#if>
                    </div>
                </form>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>
