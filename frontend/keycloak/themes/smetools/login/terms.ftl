<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        ${msg("termsTitle")}
    <#elseif section = "form">
        <div id="kc-terms-text">
            ${kcSanitize(msg("termsText"))?no_esc}
        </div>
        <form action="${url.loginAction}" method="POST">
            <div id="kc-form-buttons">
                <input class="btn-primary" name="accept" id="kc-accept" type="submit" value="${msg("doAccept")}"/>
                <input class="btn-secondary" name="cancel" id="kc-decline" type="submit" value="${msg("doDecline")}"/>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>
