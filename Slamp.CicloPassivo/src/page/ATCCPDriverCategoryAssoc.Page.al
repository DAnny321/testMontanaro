page 90230 "ATC_CP_DriverCategoryAssoc"
{

    ApplicationArea = All;
    Caption = 'Driver Category Category', Comment = 'ITA="Associazione Driver Categoria"';
    PageType = List;
    SourceTable = "ATC_CP_Driver Category Assoc.";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Dimension Code', Comment = 'ITA="Inserisci codice dimensione"';
                    Editable = false;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Code', Comment = 'ITA="Inserisci codice"';
                    Editable = false;
                }
                field("Expence Category Code"; Rec."Expence Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Expence Category Code', Comment = 'ITA="Inserisci Codice Categoria di spesa"';
                }
                field("Category Description"; Rec."Category Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Category Description', Comment = 'ITA="Inserisci Descrizione categoria"';
                }
            }
        }
    }

}
