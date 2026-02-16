page 90217 "ATC_CP_Expence Details"
{

    PageType = List;
    SourceTable = "ATC_CP_Expence Details";
    Caption = 'Expence Details',
        comment = 'ITA="Dettaglio di spesa"';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Code', Comment = 'ITA="Inserisci Codice"';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Description', Comment = 'ITA="Inserisci Descrizione"';
                }
            }
        }
    }

    actions
    {
    }
}

