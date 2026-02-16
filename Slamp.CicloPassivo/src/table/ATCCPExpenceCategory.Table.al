table 90206 "ATC_CP_Expence Category"
{
    // version CP0

    Caption = 'Expence Category',
                comment = 'ITA="Categoria di spesa"';

    LookupPageId = "ATC_CP_Expence Category";
    DrillDownPageId = "ATC_CP_Expence Category";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code',
                        comment = 'ITA="Codice"';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description',
                        comment = 'ITA="Descrizione"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
    //UserSetup: Record "User Setup";
    begin
        gRecATCCPExpenceSubCategory.SETRANGE("Category Code", Code);
        gRecATCCPExpenceSubCategory.DELETEALL(true);
    end;

    trigger OnRename();
    begin
        ERROR('Rename is not allowed');
    end;

    var
        gRecATCCPExpenceSubCategory: Record "ATC_CP_Expence SubCategory";
}

