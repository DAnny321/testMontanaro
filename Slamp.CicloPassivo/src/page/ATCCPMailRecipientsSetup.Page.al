page 90224 "ATC_CP_Mail Recipients Setup"
{

    PageType = List;
    SourceTable = "ATC_CP_Mail Recipients Setup";
    Caption = 'Mail Recipients Setup', comment = 'ITA="Setup destinatari notifiche mail"';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Purchase Events"; Rec."Purchase Events")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter Purchase Events', Comment = 'ITA="Inserisci Evento acquisto"';
                }
                field(Role; Rec.Role)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Role', Comment = 'ITA="Specifica ruolo"';
                }
                field("Send Mail As"; Rec."Send Mail As")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Send Mail As', Comment = 'ITA="Specifica invio mail come"';
                }
                field("Recover Mail Address From"; Rec."Recover Mail Address From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Recover Mail Address From', Comment = 'ITA="Recupera indirizzo mail da"';
                }
            }
        }
    }

}
