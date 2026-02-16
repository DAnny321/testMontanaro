page 90228 "ATC_CP_Page Access Config."
{

    PageType = List;
    SourceTable = "ATC_CP_Page Access Config.";
    Caption = 'Page Access Configuration', comment = 'ITA="Configurazione accesso page"';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Code', Comment = 'ITA="Specifica codice"';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Description', Comment = 'ITA="Specifica descrizione"';
                }
                field("Disable Quote"; Rec."Disable Quote")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Disable Quote', Comment = 'ITA="Specifica se disabilitare l''offerta"';
                }
                field("Disable Order"; Rec."Disable Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Disable Order', Comment = 'ITA="Specifica se disabilitare l''ordine"';
                }
                field("Disable Invoice"; Rec."Disable Invoice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Disable Invoice', Comment = 'ITA="Specifica se disabilitare la fattura"';
                }
                field("Disable Cr. Memo"; Rec."Disable Cr. Memo")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Disable Cr. Memo', Comment = 'ITA="Specifica se disabilitare la nota credito"';
                }
                field("Disable Blanket Order"; Rec."Disable Blanket Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Disable Blanket Order', Comment = 'ITA="Specifica se disabilitare gli ordini di reso programmati"';
                }
                field("Disable Return Order"; Rec."Disable Return Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Disable Return Order', Comment = 'ITA="Specifica se disabilitare gli ordini di reso"';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CheckAll)
            {
                Caption = 'Selected All', comment = 'ITA="Seleziona tutti"';
                ToolTip = 'Selected All', comment = 'ITA="Seleziona tutti"';
                ApplicationArea = all;
                Image = ExpandAll;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    Rec."Disable Blanket Order" := true;
                    Rec."Disable Cr. Memo" := true;
                    Rec."Disable Invoice" := true;
                    Rec."Disable Order" := true;
                    Rec."Disable Quote" := true;
                    Rec."Disable Return Order" := true;
                end;
            }

            action(UncheckAll)
            {
                Caption = 'Uncheck All', comment = 'ITA="Deseleziona tutti"';
                ToolTip = 'Uncheck All', comment = 'ITA="Deseleziona tutti"';
                ApplicationArea = all;
                Image = Compress;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Rec."Disable Blanket Order" := false;
                    Rec."Disable Cr. Memo" := false;
                    Rec."Disable Invoice" := false;
                    Rec."Disable Order" := false;
                    Rec."Disable Quote" := false;
                    Rec."Disable Return Order" := false;
                end;
            }
        }
    }

}
