page 90223 "ATC_CP_Field Notification Mail"
{

    PageType = List;
    SourceTable = "ATC_CP_Selection Field Mail";
    Caption = 'Field Notification Mail', comment = 'ITA="Selezione campi notifiche mail"';
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
                    ToolTip = 'Purchase Events', Comment = 'ITA="Evento acquisto"';
                }
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter Table No.', Comment = 'ITA="Inserisci Nr. tabella"';
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Field No.', Comment = 'ITA="Inserisci Nr. campo"';
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Field Caption', Comment = 'ITA="Inserisci Descrizione campo"';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Active', Comment = 'ITA="Attivo"';
                }
                field("Use as Link String"; Rec."Use as Link String")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Use as Link String', Comment = 'ITA="Usa come collegamento stringa"';
                }
            }
        }
    }

}
