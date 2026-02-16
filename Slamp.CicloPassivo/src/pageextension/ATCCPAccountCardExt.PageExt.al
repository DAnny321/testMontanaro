pageextension 90202 "ATC_CP_AccountCardExt" extends "G/L Account Card"
//pageextension 90202 "PR_AccountCardExt" extends "G/L Account Card"
{
    layout
    {
        addafter("Cost Accounting")
        {
            group(ATC_CP_Request)
            {
                Caption = 'Purchase Request', comment = 'ITA="Richieste di acquisto"';
                field("ATC_CP_Enable Purchase Request"; Rec."ATC_CP_Enable Purchase Request")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable Purchase Request', Comment = 'ITA="Abilita per richieste di acquisto"';
                    Visible = glbVisible;
                }
                field("ATC_CP_Expence Category"; Rec."ATC_CP_Expence Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Expence Category Code', Comment = 'ITA="Specifica Codice Categoria di spesa"';
                    Editable = Rec."ATC_CP_Enable Purchase Request" and Show1stLivel;
                    Visible = glbVisible;
                }
                field("ATC_CP_Expence SubCategory"; Rec."ATC_CP_Expence SubCategory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies expence SubCategory', Comment = 'ITA="Specifica codice sottocategoria di spesa"';
                    Editable = Rec."ATC_CP_Enable Purchase Request" and Show2ndLivel;
                    Visible = glbVisible;
                }
                field("ATC_CP_Expence Details"; Rec."ATC_CP_Expence Details")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies expence Details', Comment = 'ITA="Specifica codice dettaglio spesa"';
                    Editable = Rec."ATC_CP_Enable Purchase Request" and Show3rdLivel;
                    Visible = glbVisible;
                }

            }
        }
    }


    trigger OnOpenPage()
    var
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin
        lRecATCCPGeneralSetup.CalcPageVisibility(Show1stLivel, Show2ndLivel, Show3rdLivel, ShowNoField);
        glbVisible := lRecATCCPGeneralSetup.isVisible();
    end;

    var
        Show1stLivel: Boolean;
        Show2ndLivel: Boolean;
        Show3rdLivel: Boolean;
        ShowNoField: Boolean;
        glbVisible: Boolean;
}