table 90212 "ATC_CP_Mandatory Dimensions"
{
    Caption = 'Mandatory Dimensions', comment = 'ITA="Dimensioni obbligatorie"';
    DrillDownPageId = "ATC_CP_Mandatory Dimensions";
    LookupPageId = "ATC_CP_Mandatory Dimensions";
    fields
    {
        field(1; "Expence Type"; Code[20])
        {
            Caption = 'Expence Type', comment = 'ITA="Tipologia di spesa"';
            NotBlank = true;
            DataClassification = CustomerContent;
        }

        field(2; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code', comment = 'ITA="Codice dimensione"';
            NotBlank = true;
            TableRelation = Dimension.Code;
            DataClassification = CustomerContent;
        }

        field(3; Name; Text[30])
        {
            Caption = 'Name', comment = 'ITA="Nome dimensione"';
            FieldClass = FlowField;
            CalcFormula = lookup(Dimension.Name where(Code = field("Dimension Code")));
        }
        /*
        field(4; "Mandatory Dimension"; Boolean)
        {
            Caption = 'Mandatory Dimension on Approval Request', comment = 'ITA="Dimensione obbligatoria in invio approvazione"';
        }
        */

    }

    keys
    {
        key(Key1; "Expence Type", "Dimension Code")
        {
            Clustered = true;
        }
    }
}

