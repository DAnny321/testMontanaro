table 90209 "ATC_CP_Vendor Rating"
{

    Caption = 'Vendor Rating',
                comment = 'ITA="Rating fornitori"';

    DrillDownPageId = "ATC_CP_Vendor Rating";
    LookupPageId = "ATC_CP_Vendor Rating";

    fields
    {
        field(1; "Rating Code"; Code[20])
        {
            Caption = 'Rating Code',
                        comment = 'ITA="Codice rating"';
            DataClassification = CustomerContent;
        }

        field(5; RatingDescription; Text[100])
        {
            Caption = 'Description',
                        comment = 'ITA="Descrizione"';
            DataClassification = CustomerContent;
        }
        field(10; RatingLabel; Text[80])
        {
            Caption = 'Rating Label',
                        comment = 'ITA="Etichetta rating"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Rating Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        checkRatingChange();
    end;

    trigger OnModify()
    begin
        checkRatingChange();
    end;

    procedure checkRatingChange()
    begin
        gRecATCCPGeneralSetup.Get();
        if (gRecATCCPGeneralSetup."First Vendor Rating" <> '') and (gRecATCCPGeneralSetup."First Vendor Rating" = Rec."Rating Code") then
            gRecATCCPGeneralSetup.CheckRatingModify(1);
        if (gRecATCCPGeneralSetup."Second Vendor Rating" <> '') and (gRecATCCPGeneralSetup."Second Vendor Rating" = Rec."Rating Code") then
            gRecATCCPGeneralSetup.CheckRatingModify(2);
        if (gRecATCCPGeneralSetup."Third Vendor Rating" <> '') and (gRecATCCPGeneralSetup."Third Vendor Rating" = Rec."Rating Code") then
            gRecATCCPGeneralSetup.CheckRatingModify(3);

    end;


    var
        gRecATCCPGeneralSetup: Record "ATC_CP_General Setup";

}

