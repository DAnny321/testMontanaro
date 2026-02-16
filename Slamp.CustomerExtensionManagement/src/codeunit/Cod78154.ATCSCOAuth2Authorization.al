codeunit 78154 "ATC_SC_OAuth2Authorization"
{
    var
        UriBuilder: Codeunit Uri;

    [NonDebuggable]
    procedure AcquireAuthorizationToken(
        GrantType: Enum "ATC_SC_AuthGrantType";
        UserName: Text;
        Password: Text;
        ClientId: Text;
        ClientSecret: Text;
        AuthorizationURL: Text;
        AccessTokenURL: Text;
        RedirectURL: Text;
        AuthURLParms: Text;
        Scope: Text;
        JAccessToken: JsonObject): Boolean
    var
        AuthCode: Text;
    begin
        if GrantType = GrantType::"Authorization Code" then begin
            AuthCode := AcquireAuthorizationCode(
                ClientId,
                AuthorizationURL,
                RedirectURL,
                AuthURLParms,
                Scope);

            if AuthCode = '' then
                exit;
        end;

        exit(
            AcquireToken(
                GrantType,
                AuthCode,
                UserName,
                Password,
                ClientId,
                ClientSecret,
                Scope,
                RedirectURL,
                AccessTokenURL,
                JAccessToken));
    end;

    [NonDebuggable]
    local procedure AcquireAuthorizationCode(
        ClientId: Text;
        AuthorizationURL: Text;
        RedirectURL: Text;
        AuthURLParms: Text;
        Scope: Text): Text
    var
        OAuth20ConsentDialog: Page "ATC_SC_OAuth2ConsentDialog";
        State: Text;
        AuthRequestURL: Text;
    begin
        State := Format(CreateGuid(), 0, 4);

        AuthRequestURL := GetAuthRequestURL(
            ClientId,
            AuthorizationURL,
            RedirectURL,
            State,
            Scope,
            AuthURLParms);

        if AuthRequestURL = '' then
            exit;

        OAuth20ConsentDialog.SetOAuth2CodeFlowGrantProperties(AuthRequestURL, State);
        OAuth20ConsentDialog.RunModal();

        exit(OAuth20ConsentDialog.GetAuthCode());
    end;

    [NonDebuggable]
    local procedure AcquireToken(
        GrantType: Enum "ATC_SC_AuthGrantType";
        AuthorizationCode: Text;
        UserName: Text;
        Password: Text;
        ClientId: Text;
        ClientSecret: Text;
        Scope: Text;
        RedirectURL: Text;
        TokenEndpointURL: Text;
        JAccessToken: JsonObject): Boolean;
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        ContentText: Text;
        ResponseText: Text;
        IsSuccess: Boolean;
    begin
        case GrantType of
            GrantType::"Authorization Code":
                ContentText := 'grant_type=authorization_code' +
                    '&code=' + AuthorizationCode +
                    '&redirect_uri=' + UriBuilder.EscapeDataString(RedirectURL) +
                    '&client_id=' + UriBuilder.EscapeDataString(ClientId) +
                    '&client_secret=' + UriBuilder.EscapeDataString(ClientSecret);
            GrantType::"Password Credentials":
                ContentText := 'grant_type=password' +
                    '&username=' + UriBuilder.EscapeDataString(UserName) +
                    '&password=' + UriBuilder.EscapeDataString(Password) +
                    '&client_id=' + UriBuilder.EscapeDataString(ClientId) +
                    '&client_secret=' + UriBuilder.EscapeDataString(ClientSecret) +
                    '&scope=' + UriBuilder.EscapeDataString(Scope);
            GrantType::"Client Credentials":
                ContentText := 'grant_type=client_credentials' +
                    '&client_id=' + UriBuilder.EscapeDataString(ClientId) +
                    '&client_secret=' + UriBuilder.EscapeDataString(ClientSecret) +
                    '&scope=' + UriBuilder.EscapeDataString(Scope);
        end;
        Content.WriteFrom(ContentText);

        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        Request.Method := 'POST';
        Request.SetRequestUri(TokenEndpointURL);
        Request.Content(Content);

        if Client.Send(Request, Response) then
            if Response.IsSuccessStatusCode() then begin
                if Response.Content.ReadAs(ResponseText) then
                    IsSuccess := JAccessToken.ReadFrom(ResponseText);
            end else
                if Response.Content.ReadAs(ResponseText) then
                    JAccessToken.ReadFrom(ResponseText);

        exit(IsSuccess);
    end;

    [NonDebuggable]
    procedure AcquireTokenByRefreshToken(
        TokenEndpointURL: Text;
        ClientId: Text;
        ClientSecret: Text;
        RedirectURL: Text;
        RefreshToken: Text;
        JAccessToken: JsonObject): Boolean
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        ContentText: Text;
        ResponseText: Text;
        IsSuccess: Boolean;
    begin
        ContentText := 'grant_type=refresh_token' +
            '&refresh_token=' + UriBuilder.EscapeDataString(RefreshToken) +
            '&redirect_uri=' + UriBuilder.EscapeDataString(RedirectURL) +
            '&client_id=' + UriBuilder.EscapeDataString(ClientId) +
            '&client_secret=' + UriBuilder.EscapeDataString(ClientSecret);
        Content.WriteFrom(ContentText);

        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        Request.Method := 'POST';
        Request.SetRequestUri(TokenEndpointURL);
        Request.Content(Content);

        if Client.Send(Request, Response) then
            if Response.IsSuccessStatusCode() then begin
                if Response.Content.ReadAs(ResponseText) then
                    IsSuccess := JAccessToken.ReadFrom(ResponseText);
            end else
                if Response.Content.ReadAs(ResponseText) then
                    JAccessToken.ReadFrom(ResponseText);

        exit(IsSuccess);
    end;

    procedure GetOAuthProperties(AuthorizationCode: Text; var CodeOut: Text; var StateOut: Text)
    begin
        if AuthorizationCode = '' then
            exit;

        ReadAuthCodeFromJson(AuthorizationCode);
        CodeOut := GetPropertyFromCode(AuthorizationCode, 'code');
        StateOut := GetPropertyFromCode(AuthorizationCode, 'state');
    end;

    [NonDebuggable]
    local procedure GetAuthRequestURL(
        ClientId: Text;
        AuthRequestURL: Text;
        RedirectURL: Text;
        State: Text;
        Scope: Text;
        AuthURLParms: Text): Text
    begin
        if (ClientId = '') or (RedirectURL = '') or (state = '') then
            exit('');

        AuthRequestURL := AuthRequestURL + '?' +
            'client_id=' + UriBuilder.EscapeDataString(ClientId) +
            '&redirect_uri=' + UriBuilder.EscapeDataString(RedirectURL) +
            '&state=' + UriBuilder.EscapeDataString(State) +
            '&scope=' + UriBuilder.EscapeDataString(Scope) +
            '&response_type=code';

        if AuthURLParms <> '' then
            AuthRequestURL := AuthRequestURL + '&' + AuthURLParms;

        exit(AuthRequestURL);
    end;

    local procedure ReadAuthCodeFromJson(var AuthorizationCode: Text)
    var
        JObject: JsonObject;
        JToken: JsonToken;
    begin
        if not JObject.ReadFrom(AuthorizationCode) then
            exit;

        if not JObject.Get('code', JToken) then
            exit;

        if not JToken.IsValue() then
            exit;

        if not JToken.WriteTo(AuthorizationCode) then
            exit;

        AuthorizationCode := AuthorizationCode.TrimStart('"').TrimEnd('"');
    end;

    local procedure GetPropertyFromCode(CodeTxt: Text; Property: Text): Text
    var
        PosProperty: Integer;
        PosValue: Integer;
        PosEnd: Integer;
    begin
        PosProperty := StrPos(CodeTxt, Property);
        if PosProperty = 0 then
            exit('');

        PosValue := PosProperty + StrPos(CopyStr(Codetxt, PosProperty), '=');
        PosEnd := PosValue + StrPos(CopyStr(CodeTxt, PosValue), '&');

        if PosEnd = PosValue then
            exit(CopyStr(CodeTxt, PosValue, StrLen(CodeTxt) - 1));

        exit(CopyStr(CodeTxt, PosValue, PosEnd - PosValue - 1));
    end;
}