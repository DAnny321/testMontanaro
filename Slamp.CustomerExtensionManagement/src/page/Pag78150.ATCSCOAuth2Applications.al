page 78150 "ATC_SC_OAuth2Applications"
{
    ApplicationArea = Basic, Suite, Service;
    Caption = 'OAuth 2.0 Applications Setup (ATC)', Comment = 'ITA="Setup applicazioni OAuth 2.0 (ATC)"';
    CardPageID = "ATC_SC_OAuth2Application";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "ATC_SC_OAuth2Application";
    SourceTableView = where(ATC_SC_ConnectorType = filter(<> "App Activation"));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(ATC_SC_ConnectorType; Rec.ATC_SC_ConnectorType)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}
