page 90210 "ATC_CP_Mandatory Dimensions"
{

    PageType = List;
    SourceTable = "ATC_CP_Mandatory Dimensions";
    Caption = 'Mandatory Dimensions', comment = 'ITA="Obbligatorietà dimensioni"';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Dimension Code', Comment = 'ITA="Specifica codice dimensione"';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies name', Comment = 'ITA="Specifica nome"';
                }
            }
        }
    }
}
