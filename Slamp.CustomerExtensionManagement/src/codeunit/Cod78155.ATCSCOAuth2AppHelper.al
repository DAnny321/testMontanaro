codeunit 78155 "ATC_SC_OAuth2AppHelper"
{

    var
        OAuth2Authorization: Codeunit "ATC_SC_OAuth2Authorization";

    [NonDebuggable]
    procedure RequestAccessToken(var Application: Record "ATC_SC_OAuth2Application"; var MessageTxt: Text): Boolean
    var
        IsSuccess: Boolean;
        JAccessToken: JsonObject;
        ElapsedSecs: Integer;
    begin
        if Application.Status = Application.Status::Connected then begin
            ElapsedSecs := Round((CurrentDateTime() - Application."Authorization Time") / 1000, 1, '>');
            if ElapsedSecs < Application."Expires In" then
                exit(true)
            else
                if RefreshAccessToken(Application, MessageTxt) then
                    exit(true);
        end;

        Application."Authorization Time" := CurrentDateTime();
        IsSuccess := OAuth2Authorization.AcquireAuthorizationToken(
            Application."Grant Type",
            Application."User Name",
            GetIsolatedValue(Application, FieldOption::Password),
            GetIsolatedValue(Application, FieldOption::ClientId),
            GetIsolatedValue(Application, FieldOption::ClientSecret),
            Application."Authorization URL",
            GetIsolatedValue(Application, FieldOption::AccessTokenUrl),
            Application."Redirect URL",
            Application."Auth. URL Parms",
            Application.Scope,
            JAccessToken);

        if IsSuccess then begin
            ReadTokenJson(Application, JAccessToken);
            Application.Status := Application.Status::Connected;
        end else begin
            MessageTxt := GetErrorDescription(JAccessToken);
            Application.Status := Application.Status::Error;
        end;

        Application.Modify();
        exit(IsSuccess);
    end;

    [NonDebuggable]
    procedure RefreshAccessToken(var Application: Record "ATC_SC_OAuth2Application"; var MessageTxt: Text): Boolean
    var
        JAccessToken: JsonObject;
        RefreshToken: Text;
        IsSuccess: Boolean;
    begin
        RefreshToken := GetRefreshToken(Application);
        if RefreshToken = '' then
            exit;

        Application."Authorization Time" := CurrentDateTime();
        IsSuccess := OAuth2Authorization.AcquireTokenByRefreshToken(
            GetIsolatedValue(Application, FieldOption::AccessTokenUrl),
            GetIsolatedValue(Application, FieldOption::ClientId),
            GetIsolatedValue(Application, FieldOption::ClientSecret),
            Application."Redirect URL",
            RefreshToken,
            JAccessToken);

        if IsSuccess then begin
            ReadTokenJson(Application, JAccessToken);
            Application.Status := Application.Status::Connected;
        end else begin
            MessageTxt := GetErrorDescription(JAccessToken);
            Application.Status := Application.Status::Error;
        end;

        Application.Modify();
        exit(IsSuccess);
    end;

    [NonDebuggable]
    procedure GetAccessToken(var Application: Record "ATC_SC_OAuth2Application"): Text
    var
        IStream: InStream;
        Buffer: TextBuilder;
        Line: Text;
    begin
        Application.CalcFields("Access Token");
        if Application."Access Token".HasValue then begin
            Application."Access Token".CreateInStream(IStream, TextEncoding::UTF8);
            while not IStream.EOS do begin
                IStream.ReadText(Line, 1024);
                Buffer.Append(Line);
            end;
        end;

        exit(Buffer.ToText())
    end;

    [NonDebuggable]
    procedure GetRefreshToken(var Application: Record "ATC_SC_OAuth2Application"): Text
    var
        IStream: InStream;
        Buffer: TextBuilder;
        Line: Text;
    begin
        Application.CalcFields("Refresh Token");
        if Application."Refresh Token".HasValue then begin
            Application."Refresh Token".CreateInStream(IStream, TextEncoding::UTF8);
            while not IStream.EOS do begin
                IStream.ReadText(Line, 1024);
                Buffer.Append(Line);
            end;
        end;

        exit(Buffer.ToText())
    end;

    local procedure GetErrorDescription(JAccessToken: JsonObject): Text
    var
        JToken: JsonToken;
    begin
        if (JAccessToken.Get('error_description', JToken)) then
            exit(JToken.AsValue().AsText());
    end;

    local procedure ReadTokenJson(var Application: Record "ATC_SC_OAuth2Application"; JAccessToken: JsonObject)
    var
        JToken: JsonToken;
        Property: Text;
        OStream: OutStream;
    begin
        foreach Property in JAccessToken.Keys() do begin
            JAccessToken.Get(Property, JToken);
            case Property of
                'token_type',
                'scope':
                    ;
                'expires_in':
                    Application."Expires In" := JToken.AsValue().AsInteger();
                'ext_expires_in':
                    Application."Ext. Expires In" := JToken.AsValue().AsInteger();
                'access_token':
                    begin
                        Application."Access Token".CreateOutStream(OStream, TextEncoding::UTF8);
                        OStream.WriteText(JToken.AsValue().AsText());
                    end;
                'refresh_token':
                    begin
                        Application."Refresh Token".CreateOutStream(OStream, TextEncoding::UTF8);
                        OStream.WriteText(JToken.AsValue().AsText());
                    end;
            end;
        end;
    end;

    [NonDebuggable]
    procedure GetIsolatedValue(Application: Record "ATC_SC_OAuth2Application"; pFieldOption: option ClientSecret,Password,ClientId,AccessTokenUrl): Text
    Var
        IsolatedValue: Text;
    begin
        case pFieldOption of
            pFieldOption::ClientId:
                begin
                    if (Application.ATC_SC_ConnectorType = Application.ATC_SC_ConnectorType::"App Activation") and (Application."Client ID" <> '') then
                        IsolatedStorage.Get(Application."Client ID", DATASCOPE::Company, IsolatedValue)
                    else
                        IsolatedValue := Application."Client ID";
                end;
            pFieldOption::ClientSecret:
                begin
                    if Application."Client Secret" <> '' then
                        IsolatedStorage.Get(Application."Client Secret", DATASCOPE::Company, IsolatedValue);
                end;
            pFieldOption::AccessTokenUrl:
                begin
                    if (Application.ATC_SC_ConnectorType = Application.ATC_SC_ConnectorType::"App Activation") and (Application."Access Token URL" <> '') then
                        IsolatedStorage.Get(Application."Access Token URL", DATASCOPE::Company, IsolatedValue)
                    else
                        IsolatedValue := Application."Access Token URL";
                end;
            pFieldOption::Password:
                begin
                    if (Application.Password <> '') then
                        IsolatedStorage.Get(Application.Password, DATASCOPE::Company, IsolatedValue);
                end;
        end;
        exit(IsolatedValue);
    end;

    var
        FieldOption: Option ClientSecret,Password,ClientId,AccessTokenUrl;

}