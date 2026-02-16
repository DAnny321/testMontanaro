table 90208 "ATC_CP_Expence Details"
{

    Caption = 'Expence Details',
                comment = 'ITA="Dettaglio di spesa"';


    LookupPageId = "ATC_CP_Expence Details";
    DrillDownPageId = "ATC_CP_Expence Details";
    fields
    {
        field(1; "Category Code"; Code[20])
        {
            Caption = 'Category Code',
                        comment = 'ITA="Codice categoria"';
            TableRelation = "ATC_CP_Expence Category".Code;
            DataClassification = CustomerContent;
        }
        field(2; "SubCategory Code"; Code[20])
        {
            Caption = 'SubCategory Code',
                        comment = 'ITA="Codice sottocategoria"';
            DataClassification = CustomerContent;
            TableRelation = "ATC_CP_Expence SubCategory".Code;
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Code',
                        comment = 'ITA="Codice"';
            DataClassification = CustomerContent;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description',
                        comment = 'ITA="Descrizione"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Category Code", "SubCategory Code", "Code")
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

    trigger OnRename();
    begin
        ERROR('Rename is not allowed');
    end;
}

