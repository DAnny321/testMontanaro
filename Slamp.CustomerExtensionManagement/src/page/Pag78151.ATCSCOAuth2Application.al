page 78151 "ATC_SC_OAuth2Application"
{
    Caption = 'OAuth 2.0 Application Setup (ATC)', Comment = 'ITA="Setup applicazione OAuth 2.0 (ATC)"';
    LinksAllowed = false;
    ShowFilter = false;
    SourceTable = "ATC_SC_OAuth2Application";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ITA="Generale"';
                field(Code; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;

                }
                field(ATC_SC_ConnectorType; Rec.ATC_SC_ConnectorType)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Client ID"; Rec."Client ID")
                {
                    Caption = 'Application / Client ID', Comment = 'ITA="Applicazione/ID client"';
                    ApplicationArea = Basic, Suite;
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDataType = Masked;
                }
                field("Grant Type"; Rec."Grant Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Redirect URL"; Rec."Redirect URL")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Scope; Rec.Scope)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the scope.';
                }
            }
            group("Password Credentials")
            {
                Caption = 'Password Credentials', Comment = 'ITA="Credenziali"';
                Visible = Rec."Grant Type" = Rec."Grant Type"::"Password Credentials";

                field("User Name"; Rec."User Name")
                {
                    Caption = 'User Name', Comment = 'ITA="Nome utente"';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the user name.';
                }
                field("Password"; Rec."Password")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDataType = Masked;
                }
            }
            group("Endpoints")
            {
                Caption = 'Endpoints', Comment = 'ITA="Endpoints"';

                field("Authorization URL"; Rec."Authorization URL")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Access Token URL"; Rec."Access Token URL")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Auth. URL Parms"; Rec."Auth. URL Parms")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RequestAccessToken)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Request Access Token', Comment = 'ITA="Richiesta token di accesso"';
                Image = EncryptionKeys;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Open the service authorization web page. Login credentials will be prompted. The authorization code must be copied into the Enter Authorization Code field.';

                trigger OnAction()
                var
                    MessageTxt: Text;
                begin
                    if not OAuth20AppHelper.RequestAccessToken(Rec, MessageTxt) then begin
                        Commit(); // save new "Status" value
                        Error(MessageTxt);
                    end else
                        Message(SuccessfulMsg);
                end;
            }
            action(RefreshAccessToken)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Refresh Access Token', Comment = 'ITA="Rinnova token di accesso"';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Refresh the access and refresh tokens.';

                trigger OnAction()
                var
                    MessageText: Text;
                begin
                    if OAuth20AppHelper.GetRefreshToken(Rec) = '' then
                        Error(NoRefreshTokenErr);

                    if not OAuth20AppHelper.RefreshAccessToken(Rec, MessageText) then begin
                        Commit(); // save new "Status" value
                        Error(MessageText);
                    end else
                        Message(SuccessfulMsg);
                end;
            }
            action(SetupAPI)
            {
                Caption = 'Setup API Services', comment = 'ITA="Setup servizi API"';
                ToolTip = 'Opens the list containing the API service setups that have current authentication.', comment = 'ITA="Apre la lista contenente i setup dei servizi delle API che hanno l''autenticazione corrente."';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = MapSetup;
                RunObject = page ATC_SC_SetupAPIList;
                RunPageLink = ATC_SC_OAuth2Config = field(Code);
            }
        }
    }

    var
        OAuth20AppHelper: Codeunit "ATC_SC_OAuth2AppHelper";
        SuccessfulMsg: Label 'Access Token updated successfully.', Comment = 'ITA="Token di accesso aggiornato con successo"';
        NoRefreshTokenErr: Label 'No Refresh Token available', Comment = 'ITA="Nessun aggiornamento token disponibile"';
}

