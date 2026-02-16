codeunit 78151 "ATC_CAV_RunCheckApp"
{
    trigger OnRun()
    begin

    end;

    var
        ATC_CAV_CheckAppValidityWS: Codeunit ATC_CAV_CheckAppValidityWS;

    procedure RunCheck(pAppId: Enum ATC_SC_ExtensionAgic; pModuleId: Text[50])
    var
        lcuAzureADTenant: Codeunit "Azure AD Tenant";
        AzureADTenant: Codeunit "Azure AD Tenant";
    begin
        Clear(ATC_CAV_CheckAppValidityWS);
        ATC_CAV_CheckAppValidityWS.SetCustomerAppParameters(AzureADTenant.GetAadTenantId(), pAppId, pModuleId);

        if ATC_CAV_CheckAppValidityWS.EnableAppValidityCheck() then begin
            ATC_CAV_CheckAppValidityWS.CallWebService();
            Commit();
        end;
    end;
}
