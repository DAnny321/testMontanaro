tableextension 90205 "ATC_CP_HierarchyGLAccountExt" extends "G/L Account"
// tableextension 90205 "PR_HierarchyGLAccountExt" extends "G/L Account"
{
    fields
    {
        field(90200; "ATC_CP_Enable Purchase Request"; Boolean)
        {
            Caption = 'Enable for Purchase Request', comment = 'ITA="Abilita per richieste di acquisto"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("Direct Posting");
            end;
        }
        field(90201; "ATC_CP_Expence Category"; Code[20])
        {
            TableRelation = "ATC_CP_Expence Category".Code;
            Caption = 'Expence Category Code', comment = 'ITA="Codice categoria di spesa"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "ATC_CP_Expence Category" <> xRec."ATC_CP_Expence Category" then
                    Validate("ATC_CP_Expence SubCategory", '');
            end;
        }
        field(90202; "ATC_CP_Expence SubCategory"; Code[20])
        {
            TableRelation = "ATC_CP_Expence SubCategory".Code where("Category Code" = field("ATC_CP_Expence Category"));
            Caption = 'Expence SubCategory', comment = 'ITA="Codice sottocategoria di spesa"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "ATC_CP_Expence SubCategory" <> '' then
                    TestField("ATC_CP_Expence Category");

                if "ATC_CP_Expence SubCategory" <> xRec."ATC_CP_Expence SubCategory" then
                    Validate("ATC_CP_Expence Details", '');

            end;
        }
        field(90203; "ATC_CP_Expence Details"; Code[20])
        {
            TableRelation = "ATC_CP_Expence Details".Code where("Category Code" = field("ATC_CP_Expence Category"), "SubCategory Code" = field("ATC_CP_Expence SubCategory"));
            Caption = 'Expence Details', comment = 'ITA="Codice dettaglio di spesa"';
            DataClassification = CustomerContent;
        }

    }
}