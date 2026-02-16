table 78152 "ATC_SC_SetupAPI"
{
    Caption = 'Setup API', comment = 'ITA="Setup API"';
    DataClassification = CustomerContent;

    fields
    {
        field(10; ATC_SC_M365Services; Code[20])
        {
            Caption = 'Microsoft 365 Services', comment = 'ITA="Microsoft 365 Services"';
            DataClassification = CustomerContent;
        }
        field(20; ATC_SC_OAuth2Config; Code[20])
        {
            Caption = 'OAuth 2.0 Configuration', comment = 'ITA="Configurazione OAuth 2.0"';
            DataClassification = CustomerContent;
            TableRelation = ATC_SC_OAuth2Application.Code where(ATC_SC_ConnectorType = field(ATC_SC_ConnectorType));
        }
        field(30; ATC_SC_BaseURL; Text[50])
        {
            Caption = 'Base URL', comment = 'ITA="Base URL"';
            DataClassification = CustomerContent;
        }
        field(40; ATC_SC_APIVersion; Text[10])
        {
            Caption = 'API Version', comment = 'ITA="Versione API"';
            DataClassification = CustomerContent;
        }

        //Aggiungere altre integrazioni (Es. Microsoft Teams, OneDrive, Excel ecc..)

        field(50; ATC_SC_ConnectorType; enum ATC_SC_ConnectorType)
        {
            Caption = 'Connector Type', comment = 'ITA="Tipo connettore"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if ATC_SC_ConnectorType = ATC_SC_ConnectorType::"App Activation" then
                    FieldError(ATC_SC_ConnectorType);
            end;
        }
        field(60; ATC_SC_Active; Boolean)
        {
            Caption = 'Active', comment = 'ITA="Attiva"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lrecATC_SC_SetupAPI: Record ATC_SC_SetupAPI;
                lErr001: Label 'Field %1 cannot be empty.', comment = 'ITA="Il campo %1 non può essere vuoto."';
                lErr002: Label 'Another active API setup already exists with the same connector type.', comment = 'ITA="Esiste già un altro setup API attivo con lo stesso tipo connettore."';
            begin
                if ATC_SC_Active then begin
                    if ATC_SC_ConnectorType = ATC_SC_ConnectorType::" " then
                        Error(lErr001, FieldCaption(ATC_SC_ConnectorType));

                    lrecATC_SC_SetupAPI.SetFilter(ATC_SC_M365Services, '<>%1', ATC_SC_M365Services);
                    lrecATC_SC_SetupAPI.SetRange(ATC_SC_ConnectorType, ATC_SC_ConnectorType);
                    lrecATC_SC_SetupAPI.SetRange(ATC_SC_Active, true);
                    if not lrecATC_SC_SetupAPI.IsEmpty() then
                        Error(lErr002);
                end;
            end;
        }
        field(70; ATC_SC_EnableRealTime; Boolean)
        {
            Caption = 'Synchronize in real time', comment = 'ITA="Sincronizza in tempo reale"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; ATC_SC_M365Services)
        {
            Clustered = true;
        }
    }



}
