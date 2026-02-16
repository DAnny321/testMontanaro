page 78153 "ATC_SC_SetupAPIList"
{

    ApplicationArea = All;
    Caption = 'Setup Services API (ATC)', comment = 'ITA="Setup servizi API (ATC)"';
    PageType = List;
    SourceTable = ATC_SC_SetupAPI;
    SourceTableView = where(ATC_SC_ConnectorType = filter('<>App Activation'));
    UsageCategory = Lists;
    CardPageID = "ATC_SC_SetupServiceAPI";
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ATC_SC_Microsoft365Services; Rec.ATC_SC_M365Services)
                {
                    ApplicationArea = All;
                }
                field(ATC_SC_ConnectorType; Rec.ATC_SC_ConnectorType)
                {
                    ApplicationArea = All;
                }
                field(ATC_SC_Active; Rec.ATC_SC_Active)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
