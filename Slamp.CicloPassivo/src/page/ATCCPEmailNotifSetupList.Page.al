page 90221 "ATC_CP_Email Notif. Setup List"
{

    PageType = List;
    SourceTable = "ATC_CP_Email Notific. Setup";
    Caption = 'Email Notification Setup List', comment = 'ITA="Lista setup notifiche mail"';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = 90222;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Purchase Events"; Rec."Purchase Events")
                {
                    ApplicationArea = All;
                    ToolTip = 'Purchase Events', Comment = 'ITA="Evento acquisto"';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Description', Comment = 'ITA="Inserisci Descrizione"';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Active', Comment = 'ITA="Attivo"';
                }
            }
        }
    }

}
