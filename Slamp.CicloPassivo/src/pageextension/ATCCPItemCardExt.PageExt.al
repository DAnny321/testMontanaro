pageextension 90201 "ATC_CP_ItemCardExt" extends "Item Card"
// pageextension 90201 "PR_ItemCardExt" extends "Item Card"
{
    layout
    {
        addafter(Warehouse)
        {
            group(ATC_CP_Request)
            {
                Caption = 'Purchase Request', comment = 'ITA="Richieste di acquisto"';
                field("ATC_CP_Enable Purchase Request"; Rec."ATC_CP_Enable Purchase Request")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable Purchase Request', Comment = 'ITA="Abilita per richieste di acquisto"';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("ATC_CP_Expence Category"; Rec."ATC_CP_Expence Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Expence Category Code', Comment = 'ITA="Specifica Codice Categoria di spesa"';
                    Editable = Rec."ATC_CP_Enable Purchase Request" and Show1stLivel;
                }
                field("ATC_CP_Expence SubCategory"; Rec."ATC_CP_Expence SubCategory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies expence SubCategory', Comment = 'ITA="Specifica codice sottocategoria di spesa"';
                    Editable = Rec."ATC_CP_Enable Purchase Request" and Show2ndLivel;
                }
                field("ATC_CP_Expence Details"; Rec."ATC_CP_Expence Details")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies expence Details', Comment = 'ITA="Specifica codice dettaglio spesa"';
                    Editable = Rec."ATC_CP_Enable Purchase Request" and Show3rdLivel;
                }

            }
        }
    }


    trigger OnAfterGetRecord()
    var
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin
        lRecATCCPGeneralSetup.CalcPageVisibility(Show1stLivel, Show2ndLivel, Show3rdLivel, ShowNoField);
    end;

    trigger OnOpenPage()
    var
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin
        lRecATCCPGeneralSetup.CalcPageVisibility(Show1stLivel, Show2ndLivel, Show3rdLivel, ShowNoField);
        // glbVisible := lRecATCCPGeneralSetup.isVisible();
    end;

    var
        Show1stLivel: Boolean;
        Show2ndLivel: Boolean;
        Show3rdLivel: Boolean;
        //glbVisible: Boolean;
        ShowNoField: Boolean;
}