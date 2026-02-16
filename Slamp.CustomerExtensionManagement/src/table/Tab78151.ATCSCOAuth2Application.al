table 78151 "ATC_SC_OAuth2Application"
{
    Caption = 'OAuth 2.0 Application', Comment = 'ITA="Applicazione OAuth 2.0 (ATC)"';
    DrillDownPageId = "ATC_SC_OAuth2Applications";
    LookupPageId = "ATC_SC_OAuth2Applications";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code', comment = 'ITA="Codice"';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description', Comment = 'ITA="Descrizione"';
            DataClassification = CustomerContent;

        }
        field(3; "Client ID"; Text[250])
        {
            Caption = 'Client ID', Comment = 'ITA="ID Client"';
            DataClassification = EndUserIdentifiableInformation;
            trigger OnValidate()
            begin
                if Rec."Client ID" = '' then
                    DeletePassword(FieldOption::ClientId)
                else
                    SetPassword(rec."Client ID", FieldOption::ClientId);
                Commit();
            end;
        }
        field(4; "Client Secret"; Text[250])
        {
            Caption = 'Client Secret', Comment = 'ITA="Client segreto"';
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = Masked;
            trigger OnValidate()
            begin
                if Rec."Client Secret" = '' then
                    DeletePassword(FieldOption::ClientSecret)
                else
                    SetPassword(rec."Client Secret", FieldOption::ClientSecret);
                Commit();
            end;
        }
        field(5; "Redirect URL"; Text[250])
        {
            Caption = 'Redirect URL', Comment = 'ITA="URL reindirizzamento"';
            DataClassification = CustomerContent;
        }
        field(6; "Auth. URL Parms"; Text[250])
        {
            Caption = 'Auth. URL Parms', Comment = 'ITA="Parametri autorizzazione URL"';
            DataClassification = CustomerContent;
        }
        field(7; Scope; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Scope', Comment = 'ITA="Scopo"';
        }
        field(8; "Authorization URL"; Text[250])
        {
            Caption = 'Authorization URL', Comment = 'ITA="URL autorizzazione"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                WebRequestHelper: Codeunit "Web Request Helper";
            begin
                if "Authorization URL" <> '' then
                    WebRequestHelper.IsSecureHttpUrl("Authorization URL");
            end;
        }
        field(9; "Access Token URL"; Text[250])
        {
            Caption = 'Access Token URL', Comment = 'ITA="URL del token di accesso"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                WebRequestHelper: Codeunit "Web Request Helper";
            begin
                if "Access Token URL" <> '' then
                    WebRequestHelper.IsSecureHttpUrl("Access Token URL");

                if Rec."Access Token URL" = '' then
                    DeletePassword(FieldOption::AccessTokenUrl)
                else
                    SetPassword(rec."Access Token URL", FieldOption::AccessTokenUrl);

                Commit();
            end;
        }
        field(10; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status', Comment = 'ITA="Stato"';
            OptionCaption = ' ,Enabled,Disabled,Connected,Error';
            OptionMembers = " ",Enabled,Disabled,Connected,Error;
        }
        field(11; "Access Token"; Blob)
        {
            Caption = 'Access Token', Comment = 'ITA="Token di accesso"';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(12; "Refresh Token"; Blob)
        {
            Caption = 'Refresh Token', Comment = 'ITA="Token di aggiornamento"';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(13; "Authorization Time"; DateTime)
        {
            Caption = 'Authorization Time', Comment = 'ITA="Ora autorizzazione"';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(14; "Expires In"; Integer)
        {
            Caption = 'Expires In', Comment = 'ITA="Scade in"';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(15; "Ext. Expires In"; Integer)
        {
            Caption = 'Ext. Expires In', Comment = 'ITA="Scade in ext."';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(16; "Grant Type"; Enum "ATC_SC_AuthGrantType")
        {
            Caption = 'Grant Type', Comment = 'ITA="Tipo permesso"';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(17; "User Name"; Text[80])
        {
            Caption = 'User Name', Comment = 'ITA="Nome utente"';
            DataClassification = CustomerContent;
        }
        field(18; Password; Text[100])
        {
            Caption = 'Password';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;

            trigger OnValidate()
            begin
                if Rec.Password = '' then
                    DeletePassword(FieldOption::Password)
                else
                    SetPassword(rec.Password, FieldOption::Password);
                Commit();
            end;
        }
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
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
        Status := Status::" ";
        Clear("Access Token");
        Clear("Refresh Token");
        "Expires In" := 0;
        "Ext. Expires In" := 0;
        "Authorization Time" := 0DT;
    end;

    [NonDebuggable]
    procedure SetPassword(NewPassword: Text; pFieldOption: Option ClientSecret,Password,ClientId,AccessTokenUrl)
    begin
        case pFieldOption of
            pFieldOption::ClientSecret:
                begin
                    rec."Client Secret" := CreateGuid();
                    IsolatedStorage.Set(rec."Client Secret", NewPassword, DATASCOPE::Company);
                end;
            pFieldOption::Password:
                begin
                    Rec.Password := CreateGuid();
                    IsolatedStorage.Set(Rec.Password, NewPassword, DATASCOPE::Company);
                end;
            pFieldOption::ClientId:
                begin
                    if Rec.ATC_SC_ConnectorType <> Rec.ATC_SC_ConnectorType::"App Activation" then
                        exit;
                    rec."Client ID" := CreateGuid();
                    IsolatedStorage.Set(rec."Client ID", NewPassword, DATASCOPE::Company);
                end;
            pFieldOption::AccessTokenUrl:
                begin
                    if Rec.ATC_SC_ConnectorType <> Rec.ATC_SC_ConnectorType::"App Activation" then
                        exit;
                    Rec."Access Token URL" := CreateGuid();
                    IsolatedStorage.Set(Rec."Access Token URL", NewPassword, DATASCOPE::Company);
                end;
        end;
    end;

    [NonDebuggable]
    procedure DeletePassword(pFieldOption: Option ClientSecret,Password,ClientId,AccessTokenUrl)
    begin
        case pFieldOption of
            pFieldOption::ClientSecret:
                begin
                    IsolatedStorage.Delete(xrec."Client Secret", DATASCOPE::Company);
                    Clear(Rec."Client Secret");
                end;
            pFieldOption::Password:
                begin
                    IsolatedStorage.Delete(xrec.Password, DATASCOPE::Company);
                    Clear(Rec.Password);
                end;
            pFieldOption::ClientId:
                begin
                    if Rec.ATC_SC_ConnectorType <> Rec.ATC_SC_ConnectorType::"App Activation" then
                        exit;
                    IsolatedStorage.Delete(xrec."Client ID", DATASCOPE::Company);
                    Clear(Rec."Client ID");
                end;
            pFieldOption::AccessTokenUrl:
                begin
                    if Rec.ATC_SC_ConnectorType <> Rec.ATC_SC_ConnectorType::"App Activation" then
                        exit;
                    IsolatedStorage.Delete(xrec."Access Token URL", DATASCOPE::Company);
                    Clear(Rec."Access Token URL");
                end;
        end;
    end;

    var
        FieldOption: Option ClientSecret,Password,ClientId,AccessTokenUrl;
}