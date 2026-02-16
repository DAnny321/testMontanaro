page 90218 "ATC_CP_Vendor Rating"
{

    PageType = List;
    SourceTable = "ATC_CP_Vendor Rating";
    Caption = 'Vendor Rating', comment = 'ITA="Rating fornitori"';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Rating Code"; Rec."Rating Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies rating Code', Comment = 'ITA="Specifica codice rating"';
                }
                field(RatingDescription; Rec.RatingDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies ratingDescription', Comment = 'ITA="Specifica la descrizione rating"';
                }
                field(RatingLabel; Rec.RatingLabel)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rating label', Comment = 'ITA="Specifica l''etichetta rating"';
                }
            }
        }
    }

}
