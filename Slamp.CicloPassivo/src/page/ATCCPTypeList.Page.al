page 90212 "ATC_CP_Type List"
{

    PageType = List;
    SourceTable = "ATC_CP_Expence Type";
    Caption = 'Purchase Request Type List', comment = 'ITA="Lista tipologie richieste di acquisto"';
    CardPageId = "ATC_CP_Type";
    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code', Comment = 'ITA="Specifica il codice"';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the entry, depending on what you chose in the Type field.',
                                comment = 'ITA="Specifica una descrizione del movimento, in base alla scelta nel campo Tipo."';
                }
                field("Enable Purchase Requests On"; Rec."Enable Purchase Requests On")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable Purchase Requests On', Comment = 'ITA="Abilita richieste di acquisto su"';
                }
            }
        }
    }

}
