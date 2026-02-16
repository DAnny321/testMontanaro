controladdin "ATC_SC_OAuth2Integration"
{
    Scripts = 'src\OAuth2ControlAddIn\js\OAuthIntegration.js';
    RequestedWidth = 0;
    RequestedHeight = 0;
    HorizontalStretch = false;
    VerticalStretch = false;

    procedure StartAuthorization(AuthRequestUrl: Text);

    event AuthorizationCodeRetrieved(AuthCode: Text);
    event AuthorizationErrorOccurred(AuthError: Text; AuthErrorDescription: Text);
    event ControlAddInReady();
}
