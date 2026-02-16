codeunit 78153 "ATC_SC_APIManagement"
{
    var
        ProblemRequestURIErr: Label 'Problem to set request URI', comment = 'ITA="Errore nel settare la richiesta URI."';
        ProblemSendHTTPRequestErr: Label 'Problem to sends an HTTP request.', comment = 'ITA="Errore durante l''invio della richiesta HTTP."';
        WebServiceReturnErr: Label 'The web service returned an error message:\\', comment = 'ITA="Il web service restituisce un messaggio di errore:\\"';
        BearerLbl: Label 'Bearer %1', comment = 'ITA="Bearer %1"';

    /// <summary>
    /// Restituisce il token per l'autenticazione OAuth2.0.
    /// </summary>
    /// <param name="OAuth2Config">Il provider del token (AAD, Google ecc..)Code[20].</param>
    /// <returns>Return il token ricevuto, value of type Text.</returns>
    procedure GetAccessToken(OAuth2Config: Code[20]): Text
    var
        OAuth20Appln: Record "ATC_SC_OAuth2Application";
        OAuth20AppHelper: Codeunit "ATC_SC_OAuth2AppHelper";
        MessageText: Text;
    begin
        OAuth20Appln.Get(OAuth2Config);
        if not OAuth20AppHelper.RequestAccessToken(OAuth20Appln, MessageText) then
            Error(MessageText);

        exit(OAuth20AppHelper.GetAccessToken(OAuth20Appln));
    end;

    procedure CallAPI(RequestType: Enum ATC_SC_HTTPRequestType; OAuth2Config: Code[20]; APIQueryUri: Text): JsonObject
    var
        JsonBodyEmpty: JsonObject;
        InStreamBodyEmpty: InStream;
    begin
        exit(SendRequest(RequestType, OAuth2Config, APIQueryUri, JsonBodyEmpty, InStreamBodyEmpty));
    end;

    procedure CallAPI(RequestType: Enum ATC_SC_HTTPRequestType; OAuth2Config: Code[20]; APIQueryUri: Text; JsonBody: JsonObject): JsonObject
    var
        InStreamBodyEmpty: InStream;
    begin
        exit(SendRequest(RequestType, OAuth2Config, APIQueryUri, JsonBody, InStreamBodyEmpty));
    end;


    procedure CallAPI(RequestType: Enum ATC_SC_HTTPRequestType; OAuth2Config: Code[20]; APIQueryUri: Text; InstreamBody: InStream): JsonObject
    var
        JsonBodyEmpty: JsonObject;
    begin
        exit(SendRequest(RequestType, OAuth2Config, APIQueryUri, JsonBodyEmpty, InstreamBody));
    end;

    internal procedure SendRequest(RequestType: Enum ATC_SC_HTTPRequestType; OAuth2Config: Code[20]; APIQueryUri: Text; JsonBody: JsonObject; var InstreamBody: InStream): JsonObject
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        JsonResponse: JsonObject;
        AccessToken: Text;
        JsonContentResponse: Text;
    begin
        AccessToken := GetAccessToken(OAuth2Config);

        if not RequestMessage.SetRequestUri(APIQueryUri) then
            Error(ProblemRequestURIErr);

        Headers := Client.DefaultRequestHeaders();
        Headers.Add('Authorization', StrSubstNo(BearerLbl, AccessToken));

        case RequestType of
            RequestType::GET:
                GetRequest(RequestMessage);

            RequestType::POST:
                PostRequest(RequestMessage, JsonBody);

            RequestType::PATCH:
                PatchRequest(RequestMessage, JsonBody);

            RequestType::PUT:
                PutRequest(RequestMessage, JsonBody, InstreamBody);

            RequestType::DELETE:
                DeleteRequest(RequestMessage);
        end;

        if not Client.Send(RequestMessage, ResponseMessage) then
            Error(ProblemSendHTTPRequestErr);

        if not responseMessage.IsSuccessStatusCode then
            Error(WebServiceReturnErr +
                  'Status Code: %1\' +
                  'Description: %2',
                   responseMessage.HttpStatusCode,
                   responseMessage.ReasonPhrase);

        ResponseMessage.Content().ReadAs(JsonContentResponse);
        if not JsonResponse.ReadFrom(JsonContentResponse) then
            ResponseMessage.Content().ReadAs(InstreamBody); //Ottengo il body della response contenente un file binario InStream

        exit(JsonResponse);
    end;

    local procedure GetRequest(var RequestMessage: HttpRequestMessage)
    begin
        RequestMessage.Method('GET');
    end;

    local procedure DeleteRequest(var RequestMessage: HttpRequestMessage)
    begin
        RequestMessage.Method('DELETE');
    end;

    local procedure PostRequest(var RequestMessage: HttpRequestMessage; Body: JsonObject)
    var
        JsonContenBody: Text;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
    begin
        //Converto JsonObject in Text
        Body.WriteTo(JsonContenBody);

        //Aggiungo il body alla richiesta
        RequestContent.WriteFrom(JsonContenBody);

        RequestContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);
    end;

    local procedure PatchRequest(var RequestMessage: HttpRequestMessage; Body: JsonObject)
    var
        JsonContenBody: Text;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
    begin
        //Converto JsonObject in Text
        Body.WriteTo(JsonContenBody);

        //Aggiungo il body alla richiesta
        RequestContent.WriteFrom(JsonContenBody);

        RequestContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Method('PATCH');
        RequestMessage.Content(RequestContent);
    end;

    local procedure PutRequest(var RequestMessage: HttpRequestMessage; JsonBody: JsonObject; InStreamBody: InStream)
    var
        JsonContenBody: Text;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
    begin
        if JsonBody.Keys().Count() > 0 then begin
            JsonBody.WriteTo(JsonContenBody); //Converto JsonObject in Text
            RequestContent.WriteFrom(JsonContenBody); //Aggiungo il body Text alla richiesta
        end
        else
            RequestContent.WriteFrom(InStreamBody); //Aggiungo il body Instream alla richiesta

        RequestContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');

        if RequestHeaderValues.Count() <> 0 then
            InserHeaderToHTTPHeader(ContentHeaders, RequestHeaderValues) //valori Header passati tramite funzione SetHeader
        else
            ContentHeaders.Add('Content-Type', 'text/plain'); //Default Header nella richiesta PUT

        RequestMessage.Method('PUT');
        RequestMessage.Content(RequestContent);

        Clear(RequestHeaderValues);
    end;

    /// <summary>
    /// Importa l'header di una richiesta. 
    /// </summary>
    /// <param name="HeaderValues">Dictionary of [Text, Text]. Dizionario contenente le coppie chiave - valore di una richiesta</param>
    procedure SetHeader(HeaderValues: Dictionary of [Text, Text])
    begin
        RequestHeaderValues := HeaderValues;
    end;

    /// <summary>
    /// Inserisce i valori all'interno dell'header.
    /// </summary>
    /// <param name="ContentHeaders">VAR HttpHeaders. L'header di una richiesta</param>
    /// <param name="HeaderValues">Dictionary of [Text, Text]. Il dizionario contenente i valori da inserire nell'header</param>
    local procedure InserHeaderToHTTPHeader(var ContentHeaders: HttpHeaders; HeaderValues: Dictionary of [Text, Text])
    var
        KeysList: List of [Text];
        i: Integer;
        ValuesList: List of [Text];
    begin

        KeysList := HeaderValues.Keys();
        ValuesList := HeaderValues.Values();

        for i := 1 to KeysList.Count() do
            ContentHeaders.Add(KeysList.Get(i), ValuesList.Get(i));
    end;


    var
        RequestHeaderValues: Dictionary of [Text, Text];

}