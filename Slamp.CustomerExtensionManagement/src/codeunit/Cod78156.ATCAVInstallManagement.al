codeunit 78156 "ATC_AV_InstallManagement"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        lrecATC_SC_SetupAPI: Record ATC_SC_SetupAPI;
        lrecATC_SC_OAuth2Application: Record ATC_SC_OAuth2Application;
        //AgicAppManagement: Record ATC_CAV_AgicAppManagement; //da cancellare
        SingleIstance: Codeunit ATC_CAV_SingleIstance;
    begin
        //TODO: da cancellare - begin
        //SingleIstance.setAllowed(true);
        //AgicAppManagement.Reset();
        //AgicAppManagement.DeleteAll();
        //SingleIstance.setAllowed(false);
        //TODO: da cancellare - end

        /// configurazione iniziale servizi ///

        lrecATC_SC_OAuth2Application.Init();
        lrecATC_SC_OAuth2Application.Code := 'AGIC WS';
        lrecATC_SC_OAuth2Application.Description := 'OAuth 2.0 attivazione app Agic';
        lrecATC_SC_OAuth2Application.ATC_SC_ConnectorType := lrecATC_SC_OAuth2Application.ATC_SC_ConnectorType::"App Activation";
        lrecATC_SC_OAuth2Application.Validate("Client ID", '9d5e5d3e-5186-4101-95dd-8f99f3afd3f1');
        lrecATC_SC_OAuth2Application.Validate("Client Secret", 'SET_IN_ENVIRONMENT');
        lrecATC_SC_OAuth2Application.Validate("Access Token URL", 'https://login.microsoftonline.com/d5e193bb-0b46-467d-9d95-03eb0d012c42/oauth2/v2.0/token');
        lrecATC_SC_OAuth2Application.Validate(Scope, 'https://api.businesscentral.dynamics.com/.default');
        lrecATC_SC_OAuth2Application."Redirect URL" := 'https://BusinessCentral.com';
        lrecATC_SC_OAuth2Application."Grant Type" := lrecATC_SC_OAuth2Application."Grant Type"::"Client Credentials";
        if not lrecATC_SC_OAuth2Application.Insert() then
            lrecATC_SC_OAuth2Application.Modify();

        lrecATC_SC_SetupAPI.Init();
        lrecATC_SC_SetupAPI.ATC_SC_M365Services := 'AGIC BC WEB SERVICES';
        lrecATC_SC_SetupAPI.ATC_SC_OAuth2Config := 'AGIC WS';
        lrecATC_SC_SetupAPI.ATC_SC_BaseURL := 'https://api.businesscentral.dynamics.com/v2.0';
        lrecATC_SC_SetupAPI.ATC_SC_APIVersion := 'v2.0';
        lrecATC_SC_SetupAPI.ATC_SC_ConnectorType := lrecATC_SC_SetupAPI.ATC_SC_ConnectorType::"App Activation";
        lrecATC_SC_SetupAPI.ATC_SC_Active := true;
        lrecATC_SC_SetupAPI.ATC_SC_EnableRealTime := false;

        if not lrecATC_SC_SetupAPI.Insert() then
            lrecATC_SC_SetupAPI.Modify();


    end;
}
