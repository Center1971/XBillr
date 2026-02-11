<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>
    <#if section = "header">
        ${msg("emailVerifyTitle")}
    <#elseif section = "form">
        <div class="alert alert-info">
            <p class="instruction">${msg("emailVerifyInstruction1")}</p>
            <p class="instruction">${msg("emailVerifyInstruction2")} <a href="${url.loginAction}">${msg("doClickHere")}</a> ${msg("emailVerifyInstruction3")}</p>
        </div>
    <#elseif section = "info">
        <#if realm.duplicateEmailsAllowed>
            <p>${msg("emailVerifyInstruction1")}</p>
            <p><a href="${url.loginAction}">${msg("doClickHere")}</a> ${msg("emailVerifyInstruction3")}</p>
        </#if>
    </#if>
</@layout.registrationLayout>
