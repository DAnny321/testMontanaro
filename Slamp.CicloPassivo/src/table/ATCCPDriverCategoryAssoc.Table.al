table 90214 "ATC_CP_Driver Category Assoc."
{
    Caption = 'Driver & Category Association', comment = 'ITA="Associone driver e categoria"';

    DrillDownPageId = "ATC_CP_Dimension User Role";
    LookupPageId = "ATC_CP_Dimension User Role";

    fields
    {
        field(1; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code',
                        comment = 'ITA="Codice dimensione"';
            NotBlank = true;
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code',
                        comment = 'ITA="Codice"';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code"));
        }

        field(5; "Expence Category Code"; Code[20])
        {
            Caption = 'Expence Category Code', comment = 'ITA="Codice Categoria di spesa"';
            DataClassification = CustomerContent;
            TableRelation = "ATC_CP_Expence Category".Code;
        }
        field(6; "Category Description"; Text[100])
        {
            Caption = 'Category Description',
                        comment = 'ITA="Descrizione categoria"';
            FieldClass = FlowField;
            CalcFormula = lookup("ATC_CP_Expence Category".Description where(Code = field("Expence Category Code")));
        }

    }

    keys
    {
        key(Key1; "Dimension Code", Code, "Expence Category Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

