page 78152 "ATC_SC_OAuth2ConsentDialog"
{
    Extensible = false;
    Caption = 'Waiting for a response - do not close this page', comment = 'ITA="In attesa di una risposta - non chiudere questa pagina"';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;


    layout
    {
        area(Content)
        {
            usercontrol(OAuthIntegration; "ATC_SC_OAuth2Integration")
            {
                ApplicationArea = All;

                trigger AuthorizationCodeRetrieved(code: Text)
                var
                    StateOut: Text;
                begin
                    OAuth20Authorization.GetOAuthProperties(code, AuthCode, StateOut);

                    if AuthCode = '' then
                        AuthCodeError := NoAuthCodeErr;

                    if State = '' then
                        AuthCodeError := AuthCodeError + NoStateErr
                    else
                        if StateOut <> State then
                            AuthCodeError := AuthCodeError + NotMatchingStateErr;

                    CurrPage.Close();
                end;

                trigger AuthorizationErrorOccurred(error: Text; desc: Text);
                begin
                    AuthCodeError := StrSubstNo(AuthCodeErrorLbl, error, desc);
                    CurrPage.Close();
                end;

                trigger ControlAddInReady();
                begin
                    CurrPage.OAuthIntegration.StartAuthorization(OAuthRequestUrl);
                end;
            }
        }
    }

    procedure SetOAuth2CodeFlowGrantProperties(AuthRequestUrl: Text; AuthInitialState: Text)
    begin
        OAuthRequestUrl := AuthRequestUrl;
        State := AuthInitialState;
    end;

    procedure GetAuthCode(): Text
    begin
        exit(AuthCode);
    end;

    procedure GetAuthCodeError(): Text
    begin
        exit(AuthCodeError);
    end;

    var
        OAuth20Authorization: Codeunit "ATC_SC_OAuth2Authorization";
        OAuthRequestUrl: Text;
        State: Text;
        AuthCode: Text;
        AuthCodeError: Text;
        NoAuthCodeErr: Label 'No authorization code has been returned', comment = 'ITA="Non è stato restituito alcun codice di autorizzazione"';
        NoStateErr: Label 'No state has been returned', comment = 'ITA="No state has been returned"';
        NotMatchingStateErr: Label 'The state parameter value does not match.', comment = 'ITA="Il valore del parametro di stato non corrisponde."';
        AuthCodeErrorLbl: Label 'Error: %1, description: %2', comment = 'ITA="Errore: %1, descrizione: %2"';   //Comment = '%1 = The authorization error message, %2 = The authorization error description';
}