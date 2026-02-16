pageextension 90203 "ATC_CP_PurchOrderSubFormExt" extends "Purchase Order Subform"
// pageextension 90203 "PR_PurchOrderSubFormExt" extends "Purchase Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("ATC_CP_Expence Category"; Rec."ATC_CP_Expence Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Expence Category Code', Comment = 'ITA="Specifica Codice Categoria di spesa"';
                Visible = false;
                Editable = false;
            }
            field("ATC_CP_Expence SubCategory"; Rec."ATC_CP_Expence SubCategory")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies expence SubCategory', Comment = 'ITA="Specifica codice sottocategoria di spesa"';
                Visible = false;
                Editable = false;
            }
            field("ATC_CP_Expence Details"; Rec."ATC_CP_Expence Details")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies expence Details', Comment = 'ITA="Specifica codice dettaglio spesa"';
                Visible = false;
                Editable = false;
            }
            field("ATC_CP_Purchase Request"; Rec."ATC_CP_Purchase Request")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies purchase Request', Comment = 'ITA="Specifica richiesta di acquisto"';
                Visible = false;
                Editable = false;
            }
            field("ATC_CP_Request Additional Info"; Rec."ATC_CP_Request Additional Info")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies request Additional Info', Comment = 'ITA="Specifica informazioni aggiuntive"';
            }

            field("ATC_CP_New Line Type"; Rec."ATC_CP_New Line Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies new Line Type', Comment = 'ITA="Specifica nuova tipologia riga"';
            }
            field("ATC_CP_New Line No."; Rec."ATC_CP_New Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies new Line No.', Comment = 'ITA="Specifica nuovo nr."';
            }

            field("ATC_CP_1st Vendor Rating"; Rec."ATC_CP_1st Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '1st Vendor Rating', Comment = 'ITA="Pirmo rating fornitori"';
                Editable = Show1stRating;
                Visible = Show1stRating;

            }

            field("ATC_CP_2nd Vendor Rating"; Rec."ATC_CP_2nd Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '2st Vendor Rating', Comment = 'ITA="Secondo rating fornitori"';
                Editable = Show2ndRating;
                Visible = Show2ndRating;

            }

            field("ATC_CP_3rd Vendor Rating"; Rec."ATC_CP_3rd Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '3st Vendor Rating', Comment = 'ITA="Terzo rating fornitori"';
                Editable = Show3rdRating;
                Visible = Show3rdRating;

            }
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action(ATC_CP_LoseOutstandingQty)
            {
                Caption = 'LoseOutstandingQty', comment = 'ITA="Perdi quantità inevasa"';
                ApplicationArea = All;
                ToolTip = 'LoseOutstandingQty', comment = 'ITA="Perdi quantità inevasa"';
                Image = DeleteQtyToHandle;
                trigger OnAction()
                var
                    PurchRequestMngt: Codeunit ATC_CP_PurchRequestMngt;
                begin
                    PurchRequestMngt.CloseOutstandingQty(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        lRecPr_ATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin

        lRecPr_ATCCPGeneralSetup.CalcRatingVisibility(Show1stRating, Show2ndRating, Show3rdRating);
        //glbVisible := lRecPr_ATCCPGeneralSetup.isVisible();
    end;

    var
        Show1stRating: Boolean;
        Show2ndRating: Boolean;
        Show3rdRating: Boolean;
    // ShowNoField: Boolean;
    // RequestAdditionalInfo: Text;
    //glbVisible: Boolean;

}