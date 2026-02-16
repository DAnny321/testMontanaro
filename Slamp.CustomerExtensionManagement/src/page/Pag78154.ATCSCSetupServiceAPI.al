page 78154 "ATC_SC_SetupServiceAPI"
{

    Caption = 'Setup Service API (ATC)', Comment = 'ITA="Setup servizi API (ATC)"';
    PageType = Card;
    SourceTable = ATC_SC_SetupAPI;
    SourceTableView = where(ATC_SC_ConnectorType = filter('<>App Activation'));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ITA="Generale"';
                field(ATC_SC_Microsoft365Services; Rec.ATC_SC_M365Services)
                {
                    ApplicationArea = All;
                }
                field(ATC_SC_BaseURL; Rec.ATC_SC_BaseURL)
                {
                    ApplicationArea = All;
                }
                field(ATC_SC_APIVersion; Rec.ATC_SC_APIVersion)
                {
                    ApplicationArea = All;
                }
                field(ATC_SC_ConnectorType; Rec.ATC_SC_ConnectorType)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(ATC_SC_OAuth2Config; Rec.ATC_SC_OAuth2Config)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }

                field(ATC_SC_Active; Rec.ATC_SC_Active)
                {
                    ApplicationArea = All;
                }
            }
        }

    }


    /// <summary>
    /// Aggiorna la visibilità del/i gruppo/i
    /// </summary>
}
