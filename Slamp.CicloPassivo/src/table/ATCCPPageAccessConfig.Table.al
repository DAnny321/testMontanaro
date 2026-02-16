table 90213 "ATC_CP_Page Access Config."
{
    Caption = 'Page Access Configuration', comment = 'ITA="Configurazione accesso pagine"';
    DrillDownPageId = "ATC_CP_Page Access Config.";
    LookupPageId = "ATC_CP_Page Access Config.";
    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code', comment = 'ITA="Codice"';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description', comment = 'ITA="Descrizione"';
            DataClassification = CustomerContent;
        }
        field(5; "Disable Quote"; Boolean)
        {
            Caption = 'Disable Quote', comment = 'ITA="Disabilita offerte"';
            DataClassification = CustomerContent;
        }
        field(10; "Disable Order"; Boolean)
        {
            Caption = 'Disable Order', comment = 'ITA="Disabilita ordini"';
            DataClassification = CustomerContent;
        }
        field(15; "Disable Invoice"; Boolean)
        {
            Caption = 'Disable Invoice', comment = 'ITA="Disabilita fatture"';
            DataClassification = CustomerContent;
        }
        field(20; "Disable Cr. Memo"; Boolean)
        {
            Caption = 'Disable Cr. Memo', comment = 'ITA="Disabilita note credito"';
            DataClassification = CustomerContent;
        }
        field(25; "Disable Blanket Order"; Boolean)
        {
            Caption = 'Disable Blanket Order', comment = 'ITA="Disabilita ordini programmati"';
            DataClassification = CustomerContent;
        }
        field(30; "Disable Return Order"; Boolean)
        {
            Caption = 'Disable Return Order', comment = 'ITA="Disabilita ordini di reso"';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(FG1; Code, Description)
        {

        }
    }

}
