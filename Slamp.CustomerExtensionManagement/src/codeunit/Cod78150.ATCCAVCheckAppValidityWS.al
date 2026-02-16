codeunit 78150 "ATC_CAV_CheckAppValidityWS"
{
    Access = Internal;

    trigger OnRun()
    begin

    end;

    var
        ATC_CAV_AppValidityDate: Record ATC_CAV_AgicAppManagement;

        MaxCheckAttempts: Integer;

        WSUrl: Label 'https://api.businesscentral.dynamics.com/v2.0/d5e193bb-0b46-467d-9d95-03eb0d012c42/Production/api/AgicTechnologySrl/demo/v1.0/companies(d35b640f-e247-ed11-946f-000d3a44bbc3)/CustomerAppExpirationDate(''%1'',''%2'',''%3'')';
        CompleteWSUrl: Text;

        Error002: Label 'Agic App "%1" expired on %2. Contact a system administrator.', comment = 'ITA="L''app "%1" è scaduta in data %2.Contattare un amministratore di sistema."';
        Error002EmptyDate: Label 'Agic App "%1" is not active. Contact a system administrator.', comment = 'ITA="L''app "%1" non è attiva. Contattare un amministratore di sistema."';
        Error002_mod: Label 'Agic App "%1", module "%2", expired on %3. Contact a system administrator.', comment = 'ITA="L''app "%1", modulo "%2", è scaduta in data %3.Contattare un amministratore di sistema."';
        Error001: Label 'Agic App "%1" is not yet active. Contact a system administrator.', comment = 'ITA="L''app "%1" non risulta ancora attiva. Contattare un amministratore di sistema"';
        Error001_mod: Label 'Agic App "%1", module "%2", is not yet active. Contact a system administrator.', comment = 'ITA="L''app "%1", modulo "%2", non risulta ancora attiva. Contattare un amministratore di sistema"';
        ErrorModify: Label 'Modify not allowed', Comment = 'ITA="Modifica non permessa"';
        ErrorSetup: Label 'Configuration error: there is no valid setup for Agic Extension activation. Please contact a system administrator.',
                        comment = 'ITA="Errore configurazione: non esiste un setup valido per l''attivazione delle Extension Agic. Contattare un amministratore di sistema."';
        ErrorSetup400: Label 'Configuration error: there is no valid setup for Agic Extension activation. Please contact a system administrator for "http Error 400 Bad Request".',
                        comment = 'ITA="Errore configurazione: non esiste un setup valido per l''attivazione delle Extension Agic. Contattare un amministratore di sistema per errore "http 400 Bad Request""';
        ErrorSetup404: Label 'App validity check error: there is no valid setup for checking Agic Extension or the service is not currently available. Contact a system administrator for error "http 404 Not Found".',
                        comment = 'ITA="Errore controllo validità app: non esiste un setup valido per la verifica dell'' Extension Agic oppure il servizio non è al momento disponbile. Contattare un amministratore di sistema per errore "http 404 Not Found""';
        SystemIdToCheck: Code[50];
        TenantIdToCheck: Text[50];
        AppIdToCheck: Enum ATC_SC_ExtensionAgic;
        ModuleIdToCheck: Text[50];
        SingleIstance: Codeunit ATC_CAV_SingleIstance;
        ATC_SC_SetupAPI: Record ATC_SC_SetupAPI;

        AlertMess: Label 'Attention: app "%1" was not activated correctly or could not be checked for validity. The app may become unusable after %2 runs. Please contact an administrator',
                    Comment = 'ITA="Attenzione: l''app "%1" non risulta attivata correttamente o non è stato possibile verificarne la validità. La funzionalità potrebbe diventare non utilizzabile tra "%2" esecuzioni. Contattare un amministratore"';

        AlertTrialMess: Label 'Attention: app "%1" was not activated correctly or could not be checked for validity. Is it possible to activate the trial period that will expire on "%2": proceed with activation?',
                    Comment = 'ITA="Attenzione: l''app "%1" non risulta attivata correttamente o non è stato possibile verificarne la validità. È possibile iniziare il periodo di prova che scadrà il giorno "%2": procedere con l''attivazione?"';

    procedure EnableAppValidityCheck(): Boolean;
    begin

        if ATC_CAV_AppValidityDate.ATC_CAV_TrialUsed and (Today() < ATC_CAV_AppValidityDate.ATC_CAV_TrialExpirationDT) then //Today
            exit(false);

        if ATC_CAV_AppValidityDate.ATC_CAV_AppValidityDueDate < Today() then
            exit(true)
        else begin
            if (ATC_CAV_AppValidityDate.ATC_CAV_LastCheckDate <> 0D) and ((ATC_CAV_AppValidityDate.ATC_CAV_LastCheckDate + 30) <= Today()) then
                exit(true)
            else
                exit(false);
        end;

    end;

    [NonDebuggable]
    procedure CallWebService(): Boolean;
    var
        lHttpClient: HttpClient;
        lHttpRequest: HttpRequestMessage;
        lHttpResponse: HttpResponseMessage;
        lHttpContent: HttpContent;
        lHttpHeaders: HttpHeaders;
        lcuTempBlob: Codeunit "Temp Blob";
        lWSResponseInStream: InStream;
        lcuATC_SC_APIManagement: Codeunit "ATC_SC_APIManagement";
        lenumRequestType: Enum "ATC_SC_HTTPRequestType";
        lAccessToken: Text;
        lJSONObj: JsonObject;
        lJSONToken: JsonToken;
        lAppId: Enum ATC_SC_ExtensionAgic;
        lModuleId: Text[50];
        lNewAppValidityDate: Date;
        lErrorCode: Text;
        lErrorMsg: Text;
    begin
        clear(lAppId);
        lModuleId := '';
        lNewAppValidityDate := 0D;

        MaxCheckAttempts := 10; //per definire il numero massimo di tentavi a disposizione

        PopulateIsolatedStorage();

        GetAppActivationAPIConfig();
        CompleteWSUrl := BuildAPICompleteURL();
        lAccessToken := lcuATC_SC_APIManagement.GetAccessToken(ATC_SC_SetupAPI.ATC_SC_OAuth2Config);

        Clear(lcuTempBlob);
        Clear(lWSResponseInStream);
        lcuTempBlob.CreateInStream(lWSResponseInStream);

        lHttpRequest.GetHeaders(lHttpHeaders);

        lHttpHeaders.Clear();
        lHttpHeaders.Add('Authorization', 'Bearer ' + lAccessToken);

        lHttpRequest.Method := 'GET';
        lHttpRequest.SetRequestUri(CompleteWSUrl);

        if lHttpClient.Send(lHttpRequest, lHttpResponse) then begin

            if lHttpResponse.HttpStatusCode() = 200 then begin
                lHttpResponse.Content().ReadAs(lWSResponseInStream);

                lJSONObj.ReadFrom(lWSResponseInStream);

                if not lJSONObj.Get('error', lJSONToken) then begin

                    SetLastCheck();

                    if lJSONObj.Get('ATC_CEM_AppID', lJSONToken) then
                        evaluate(lAppId, lJSONToken.AsValue().AsText());

                    if lJSONObj.Get('ATC_CEM_AppModuleID', lJSONToken) then
                        lModuleId := lJSONToken.AsValue().AsText();

                    if lJSONObj.Get('ATC_CEM_ExpirationDate', lJSONToken) then
                        lNewAppValidityDate := lJSONToken.AsValue().AsDate();

                    if ATC_CAV_AppValidityDate.Get(lAppId, lModuleId) then begin
                        if (lNewAppValidityDate <> 0D) then begin
                            if ATC_CAV_AppValidityDate.ATC_CAV_AppValidityDueDate <> lNewAppValidityDate then begin
                                UpdateAppValidityDueDateTable(lNewAppValidityDate);
                            end;
                            if ATC_CAV_AppValidityDate.ATC_CAV_AppValidityDueDate < Today() then begin
                                if Counter(false) then
                                    if ATC_CAV_AppValidityDate.ATC_CAV_ModuleName = '' then
                                        Error(Error002, ATC_CAV_AppValidityDate.ATC_CAV_AppName, ATC_CAV_AppValidityDate.ATC_CAV_AppValidityDueDate)
                                    else
                                        Error(Error002_mod, ATC_CAV_AppValidityDate.ATC_CAV_AppName, ATC_CAV_AppValidityDate.ATC_CAV_ModuleName, ATC_CAV_AppValidityDate.ATC_CAV_AppValidityDueDate)
                            end else
                                updateCounter(true); //reset counter

                        end else
                            if Counter(false) then
                                Error(Error002EmptyDate, ATC_CAV_AppValidityDate.ATC_CAV_AppName);
                    end else
                        Error('Internal Error on App Activation: contact Agic Technology Consultant');
                end;
            end else begin
                case lHttpResponse.HttpStatusCode of
                    400:
                        begin
                            Error(ErrorSetup400);
                        end;
                    401:
                        begin
                            if ATC_CAV_AppValidityDate.ATC_CAV_ModuleName = '' then
                                Error(Error001, ATC_CAV_AppValidityDate.ATC_CAV_AppName)
                            else
                                Error(Error001_mod, ATC_CAV_AppValidityDate.ATC_CAV_AppName, ATC_CAV_AppValidityDate.ATC_CAV_ModuleName);
                        end;
                    404:
                        begin
                            if Counter(false) then
                                Error(ErrorSetup404);
                        end;
                    500:
                        begin
                            if Counter(false) then
                                Error('500 Internal Server Error');
                        end;
                    else
                        Error(Format(lHttpResponse.HttpStatusCode));
                end;
            end;
        end else
            Counter(false);
    end;


    [NonDebuggable]
    local procedure PopulateIsolatedStorage()
    var
        lrecATC_SC_SetupAPI: Record ATC_SC_SetupAPI;
        lrecATC_SC_OAuth2Application: Record ATC_SC_OAuth2Application;
    begin
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

    local procedure SetLastCheck()
    begin
        SingleIstance.setAllowed(true);
        ATC_CAV_AppValidityDate.ATC_CAV_LastCheckDate := Today();
        ATC_CAV_AppValidityDate.Modify();
        SingleIstance.setAllowed(false);
    end;

    local procedure UpdateAppValidityDueDateTable(pNewDate: Date)
    begin
        SingleIstance.setAllowed(true);
        ATC_CAV_AppValidityDate.ATC_CAV_AppValidityDueDate := pNewDate;
        ATC_CAV_AppValidityDate.ATC_CAV_LastCheckDate := Today();
        ATC_CAV_AppValidityDate.Modify();
        SingleIstance.setAllowed(false);
    end;

    local procedure Counter(Reset: Boolean): Boolean
    var
        TrialExpiration: Date;
        TrialPeriodConfirmed: Label 'Trial period activated with expiry date "%1"', Comment = 'ITA="Periodo di prova attivato con scadenza "%1""';
        ErrorTrial: Label 'Unable to proceed: activate trial version or contact a system administrator.', Comment = 'ITA="Impossibile procedere: attivare la versione di prova o contattare un amministratore di sistema."';
    begin
        if not ATC_CAV_AppValidityDate.ATC_CAV_TrialUsed then begin
            TrialExpiration := CalcDate('<+7D>', Today);
            if Confirm(StrSubstNo(AlertTrialMess, CalcAppName(AppIdToCheck), Format(TrialExpiration))) then begin
                SingleIstance.setAllowed(true);
                ATC_CAV_AppValidityDate.ATC_CAV_TrialUsed := true;
                ATC_CAV_AppValidityDate.ATC_CAV_TrialExpirationDT := TrialExpiration;
                ATC_CAV_AppValidityDate.Modify();
                SingleIstance.setAllowed(false);
                exit(false);
                Message(TrialPeriodConfirmed, ATC_CAV_AppValidityDate.ATC_CAV_TrialExpirationDT);
            end else
                error(ErrorTrial);

        end;

        updateCounter(Reset);

        if not Reset then
            if (ATC_CAV_AppValidityDate.ATC_CAV_ExceptionsCounter > MaxCheckAttempts) then
                exit(true)
            else begin
                if Today() > ATC_CAV_AppValidityDate.ATC_CAV_LastExceptionDate then begin
                    updateLastExceptionDate();
                    Message(AlertMess, CalcAppName(ATC_CAV_AppValidityDate.ATC_CAV_AppID), format(MaxCheckAttempts - ATC_CAV_AppValidityDate.ATC_CAV_ExceptionsCounter));
                end;
                exit(false);
            end;

    end;

    local procedure updateCounter(Reset: Boolean)
    begin
        SingleIstance.setAllowed(true);

        if Reset then
            ATC_CAV_AppValidityDate.ATC_CAV_ExceptionsCounter := 0
        else begin
            if Today() > ATC_CAV_AppValidityDate.ATC_CAV_LastExceptionDate then
                ATC_CAV_AppValidityDate.ATC_CAV_ExceptionsCounter += 1;
        end;
        ATC_CAV_AppValidityDate.Modify();

        SingleIstance.setAllowed(false);
    end;

    local procedure updateLastExceptionDate()
    begin
        SingleIstance.setAllowed(true);
        ATC_CAV_AppValidityDate.ATC_CAV_LastExceptionDate := Today;
        ATC_CAV_AppValidityDate.Modify();
        SingleIstance.setAllowed(false);
    end;

    procedure CalcAppName(appId: Enum ATC_SC_ExtensionAgic): Text
    var
        ACCECLabel: Label 'Provision & Operation Management';
        AdvancedFinancialReportingLabel: Label 'Advanced Financial Reporting';
        CicloPassivoLabel: Label 'Advanced Purchasing Cycle Management';
        AdvancedJobQueueManagementLabel: Label 'Advanced Job Queue Management';
        ControlloBudgetLabel: Label 'Budget Control', Comment = 'ITA="Controllo Budget"';
        ExtendedConsolidatoLabel: Label 'Extended Consolidato';
        ExtendedFunctionLabel: Label 'Extended Functions';
        ExtendedVatExemptionLabel: Label 'Extended VAT Exemption';
        ExtendedWithholdingTaxModuleLabel: Label 'Extended Withholding Tax';
        GestionePartiteLabel: Label 'Linking on G/L Account', Comment = 'ITA="Gestione a partite su Conti"';
        MasterSlaveLabel: Label 'Master & Slave';
        PrintReportPackLabel: Label 'Print Reports Pack';
        ProformaAttivaLabel: Label 'Active Proforma', Comment = 'ITA="Proforma attiva"';
        ProformaPassiveLabel: Label 'Passive Proforma', Comment = 'ITA="Proforma passiva"';
        SharePointLabel: Label 'SharePoint Connector', Comment = 'ITA="Connettore SharePoint"';
        VatGroupManagementLabel: Label 'VAT Group Management';
        StarterKitLabel: Label 'StarterKit';
        FEULabel: Label 'Agic Electronic Invoicing';
        IntegrationMngt: Label 'Agic Integration Management';
        PitecoConnect: Label 'Agic Piteco Connector';
        RealEstateSuite: Label 'Real Estate Suite';
    begin
        case true of
            appId = appId::ACCEC:
                exit(ACCECLabel);
            appId = appId::AdvancedFinancialReporting:
                exit(AdvancedFinancialReportingLabel);
            appId = appId::CicloPassivo:
                exit(CicloPassivoLabel);
            appId = appId::AdvancedJobQueueManagement:
                exit(AdvancedJobQueueManagementLabel);
            appId = appId::ControlloBudget:
                exit(ControlloBudgetLabel);
            appId = appId::ExtendedConsolidato:
                exit(ExtendedConsolidatoLabel);
            appId = appId::ExtendedFunction:
                exit(ExtendedFunctionLabel);
            appId = appId::ExtendedVatExemption:
                exit(ExtendedVatExemptionLabel);
            appId = appId::ExtendedWithholdingTaxModule:
                exit(ExtendedWithholdingTaxModuleLabel);
            appId = appId::GestionePartite:
                exit(GestionePartiteLabel);
            appId = appId::MasterSlave:
                exit(MasterSlaveLabel);
            appId = appId::PrintReportPack:
                exit(PrintReportPackLabel);
            appId = appId::ProformaAttiva:
                exit(ProformaAttivaLabel);
            appId = appId::ProformaPassiva:
                exit(ProformaPassiveLabel);
            appId = appId::SharePoint:
                exit(SharePointLabel);
            appId = appId::VatGroupManagement:
                exit(VatGroupManagementLabel);
            appId = appId::StarterKit:
                exit(StarterKitLabel);
            appId = appId::FatturazioneElettronica:
                exit(FEULabel);
            appId = appId::IntegrationManagement:
                exit(IntegrationMngt);
            appId = appId::PitecoConnect:
                exit(PitecoConnect);
            appId = appId::RealEstateSuite:
                exit(RealEstateSuite);
        end;
    end;

    /*
    procedure CalcAppAttempts(appId:Enum ATC_SC_ExtensionAgic): Integer
    begin 
        case true of 
            appId = appId::ACCEC: exit(5);
            appId = appId::AdvancedFinancialReporting:exit(5);
            appId = appId::CicloPassivo:exit(5);
            appId = appId::AdvancedJobQueueManagement: exit(AdvancedJobQueueManagementLabel);
            appId = appId::ControlloBudget:exit(ControlloBudgetLabel);
            appId = appId::ExtendedConsolidato:exit(ExtendedConsolidatoLabel);
            appId = appId::ExtendedFunction:exit(ExtendedFunctionLabel);
            appId = appId::ExtendedVatExemption: exit(ExtendedVatExemptionLabel);
            appId = appId::ExtendedWithholdingTaxModule: exit(ExtendedWithholdingTaxModuleLabel);
            appId = appId::GestionePartite: exit(GestionePartiteLabel);
            appId = appId::MasterSlave: exit(MasterSlaveLabel);
            appId = appId::PrintReportPack: exit(PrintReportPackLabel);
            appId = appId::ProformaAttiva: exit(ProformaAttivaLabel);
            appId = appId::ProformaPassiva: exit(ProformaPassiveLabel);
            appId = appId::SharePoint: exit(SharePointLabel);
            appId = appId::VatGroupManagement: exit(VatGroupManagementLabel);
            appId = appId::StarterKit: exit(StarterKitLabel);
        end;
    end;
    */

    procedure SetCustomerAppParameters(pTenantId: Text[50]; pAppId: Enum ATC_SC_ExtensionAgic; pModuleId: Text[50])
    begin
        TenantIdToCheck := pTenantId;
        AppIdToCheck := pAppId;
        ModuleIdToCheck := pModuleId;

        if not ATC_CAV_AppValidityDate.Get(pAppId, pModuleId) then begin
            SingleIstance.setAllowed(true);
            ATC_CAV_AppValidityDate.Init();
            ATC_CAV_AppValidityDate.ATC_CAV_AppID := AppIdToCheck;
            ATC_CAV_AppValidityDate.ATC_CAV_AppModuleId := ModuleIdToCheck;
            ATC_CAV_AppValidityDate.ATC_CAV_AppValidityDueDate := 0D;
            ATC_CAV_AppValidityDate.ATC_CAV_LastCheckDate := 0D;
            ATC_CAV_AppValidityDate.Insert();
            SingleIstance.setAllowed(false);
        end;
    end;

    //>New Code
    local procedure GetAppActivationAPIConfig()
    begin
        ATC_SC_SetupAPI.Reset();
        ATC_SC_SetupAPI.SetRange(ATC_SC_SetupAPI.ATC_SC_ConnectorType, ATC_SC_SetupAPI.ATC_SC_ConnectorType::"App Activation");
        ATC_SC_SetupAPI.setrange(ATC_SC_Active, true);
        if not ATC_SC_SetupAPI.FindFirst() then
            Error(ErrorSetup);
    end;

    local procedure BuildAPICompleteURL(): Text;
    var
        lWSUrl: Text;
    begin
        lWSUrl := ATC_SC_SetupAPI.ATC_SC_BaseURL + '/d5e193bb-0b46-467d-9d95-03eb0d012c42/Production/' +
                    StrSubstNo('api/AgicTechnologySrl/CEM/v1.0/companies(%1)/CustomerAppExpirationDate(''%2'',''%3'',''%4'')', 'd35b640f-e247-ed11-946f-000d3a44bbc3', TenantIdToCheck, AppIdToCheck, ModuleIdToCheck);
        exit(lWSUrl);
    end;

    [EventSubscriber(ObjectType::Table, 78150, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure OnBeforeDeleteEvent()
    begin
        if not SingleIstance.getAllowed() then
            Error(ErrorModify);
    end;

    [EventSubscriber(ObjectType::Table, 78150, 'OnBeforeInsertEvent', '', true, true)]
    local procedure OnBeforeInsertEvent()
    begin
        if not SingleIstance.getAllowed() then
            Error(ErrorModify);
    end;

    [EventSubscriber(ObjectType::Table, 78150, 'OnBeforeModifyEvent', '', true, true)]
    local procedure OnBeforeModifyEvent()
    begin
        if not SingleIstance.getAllowed() then
            Error(ErrorModify);
    end;

    [EventSubscriber(ObjectType::Table, 78150, 'OnBeforeRenameEvent', '', true, true)]
    local procedure OnBeforeRenameEvent()
    begin
        if not SingleIstance.getAllowed() then
            Error(ErrorModify);
    end;
}
