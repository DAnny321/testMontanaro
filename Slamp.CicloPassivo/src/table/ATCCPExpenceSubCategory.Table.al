table 90207 "ATC_CP_Expence SubCategory"
{
    // version CP0

    Caption = 'Expense SubCategory',
                comment = 'ITA="Sottocategoria di spesa"';

    LookupPageId = "ATC_CP_Expence SubCategory";
    DrillDownPageId = "ATC_CP_Expence SubCategory";

    fields
    {
        field(1; "Category Code"; Code[20])
        {
            Caption = 'Category Code',
                        comment = 'ITA="Codice categoria"';
            DataClassification = CustomerContent;
            TableRelation = "ATC_CP_Expence Category".Code;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code',
                        comment = 'ITA="Codice"';
            DataClassification = CustomerContent;
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
        key(Key1; "Category Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description)
        {
        }
    }

    trigger OnDelete();
    var
        lRecATCCPExpenceDetails: Record "ATC_CP_Expence Details";
    begin
        lRecATCCPExpenceDetails.RESET();
        lRecATCCPExpenceDetails.SETRANGE("Category Code", "Category Code");
        lRecATCCPExpenceDetails.SETRANGE("SubCategory Code", Code);
        lRecATCCPExpenceDetails.DELETEALL(true);
    end;

    trigger OnRename();
    begin
        ERROR('Impossibile rinominare il record');
    end;

}

