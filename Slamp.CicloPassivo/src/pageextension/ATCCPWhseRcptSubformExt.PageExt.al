pageextension 90206 "ATC_CP_Whse. Rcpt Subform Ext" extends "Whse. Receipt Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("ATC_CP_1st Vendor Rating"; Rec."ATC_CP_1st Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '1st Vendor Rating', Comment = 'ITA="Primo rating fornitori"';
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
    //glbVisible: Boolean;
}