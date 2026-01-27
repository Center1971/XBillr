<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName','email','username','password','password-confirm'); section>
    <#if section = "header">
        ${msg("registerTitle")}
    <#elseif section = "form">
        <div id="kc-form">
            <div id="kc-form-wrapper">
                <form id="kc-register-form" action="${url.registrationAction}" method="post">
                    <div class="form-group">
                        <label for="user.attributes.company" class="${properties.kcLabelClass!}">${msg("company")}</label>
                        <input type="text" id="user.attributes.company" name="user.attributes.company" value="${(register.formData['user.attributes.company']!'')}"
                               aria-invalid="<#if messagesPerField.existsError('user.attributes.company')>true</#if>"
                        />
                        <#if messagesPerField.existsError('user.attributes.company')>
                            <span id="input-error-company" class="alert alert-error" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('user.attributes.company'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <div class="form-group">
                        <label for="firstName" class="${properties.kcLabelClass!}">${msg("firstName")}</label>
                        <input type="text" id="firstName" name="firstName" value="${(register.formData.firstName!'')}"
                               aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>"
                        />
                        <#if messagesPerField.existsError('firstName')>
                            <span id="input-error-firstname" class="alert alert-error" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <div class="form-group">
                        <label for="lastName" class="${properties.kcLabelClass!}">${msg("lastName")}</label>
                        <input type="text" id="lastName" name="lastName" value="${(register.formData.lastName!'')}"
                               aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>"
                        />
                        <#if messagesPerField.existsError('lastName')>
                            <span id="input-error-lastname" class="alert alert-error" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <div class="form-group">
                        <label for="email" class="${properties.kcLabelClass!}">${msg("email")}</label>
                        <input type="text" id="email" name="email" value="${(register.formData.email!'')}" autocomplete="email"
                               aria-invalid="<#if messagesPerField.existsError('email')>true</#if>"
                        />
                        <#if messagesPerField.existsError('email')>
                            <span id="input-error-email" class="alert alert-error" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('email'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <#if !realm.registrationEmailAsUsername>
                        <div class="form-group">
                            <label for="username" class="${properties.kcLabelClass!}">${msg("username")}</label>
                            <input type="text" id="username" name="username" value="${(register.formData.username!'')}" autocomplete="username"
                                   aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                            />
                            <#if messagesPerField.existsError('username')>
                                <span id="input-error-username" class="alert alert-error" aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('username'))?no_esc}
                                </span>
                            </#if>
                        </div>
                    </#if>

                    <#if passwordRequired??>
                        <div class="form-group">
                            <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label>
                            <input type="password" id="password" name="password" autocomplete="new-password"
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
                            <input type="password" id="password-confirm" name="password-confirm"
                                   aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                            />
                            <#if messagesPerField.existsError('password-confirm')>
                                <span id="input-error-password-confirm" class="alert alert-error" aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                                </span>
                            </#if>
                        </div>
                    </#if>

                    <#if recaptchaRequired??>
                        <div class="form-group">
                            <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
                        </div>
                    </#if>

                    <div id="kc-form-buttons">
                        <input class="btn-primary" type="submit" value="${msg("doRegister")}"/>
                    </div>
                </form>
            </div>
        </div>
    <#elseif section = "info" >
        <div id="kc-registration">
            <span>${msg("alreadyHaveAccount")} <a href="${url.loginUrl}">${msg("doLogIn")}</a></span>
        </div>
    </#if>
</@layout.registrationLayout>
