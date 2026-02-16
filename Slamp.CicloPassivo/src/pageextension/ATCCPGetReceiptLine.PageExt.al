pageextension 90205 "ATC_CP_GetReceiptLine" extends "Get Receipt Lines"
//pageextension 90205 "EXT-GetReceiptLine" extends "Get Receipt Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("ATC_CP_1st Vendor Rating"; Rec."ATC_CP_1st Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '1st Vendor Rating', Comment = 'ITA="Primo rating fornitori"';
                Editable = false;
                Visible = Show1stRating;

            }

            field("ATC_CP_2nd Vendor Rating"; Rec."ATC_CP_1st Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '2st Vendor Rating', Comment = 'ITA="Secondo rating fornitori"';
                Editable = false;
                Visible = Show2ndRating;

            }

            field("ATC_CP_3rd Vendor Rating"; Rec."ATC_CP_1st Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '2st Vendor Rating', Comment = 'ITA="Terzo rating fornitori"';
                Editable = false;
                Visible = Show3rdRating;

            }
            field("ATC_CP_Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Order No.', Comment = 'ITA=Specifica nr. ordine "';
                Editable = false;
            }
            field("ATC_CP_Order Line No."; Rec."Order Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Order Line No.', Comment = 'ITA="Specifica nr. riga ordine"';
                Editable = false;
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
    //ShowNoField: Boolean;
    //glbVisible: Boolean;
}