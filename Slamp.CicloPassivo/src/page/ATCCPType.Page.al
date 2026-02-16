page 90211 "ATC_CP_Type"
{

    PageType = Card;
    SourceTable = "ATC_CP_Expence Type";
    Caption = 'Purchase Request Type', comment = 'ITA="Tipologia richiesta di acquisto"';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', comment = 'ITA="Generale"';
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies code', Comment = 'ITA="Specifica codice"';
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

                field("Default Value"; Rec."Default Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies default Value', Comment = 'ITA="Specifica valore di default"';
                }
                field("Default Value Modifiable"; Rec."Default Value Modifiable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Default Value Modifiable', Comment = 'ITA="Valore di default modificabile"';
                }

                field("Active Mandatory Dim. Checks"; Rec."Active Mandatory Dim. Checks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Active Mandatory Dim. Checks', Comment = 'ITA="Attiva controlli obbligatori dimensioni su righe all'' invio in approvazione"';
                }
                field("Exists Dim. Mandatory Setup"; Rec."Exists Dim. Mandatory Setup")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if exists Dim. Mandatory Setup', Comment = 'ITA="Specifica se esistono setup per obbligatorietà dimensioni"';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(MandatoryDimension)
            {
                PromotedOnly = true;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = DimensionSets;
                Caption = 'Mandatory Dimensions', comment = 'ITA="Obbligatorietà dimensioni"';
                ToolTip = 'Mandatory Dimensions', comment = 'ITA="Obbligatorietà dimensioni"';
                Visible = Rec."Active Mandatory Dim. Checks" = true;
                RunObject = page "ATC_CP_Mandatory Dimensions";
                RunPageLink = "Expence Type" = field(Code);
            }
        }
    }
}
