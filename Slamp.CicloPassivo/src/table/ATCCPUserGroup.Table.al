table 90203 "ATC_CP_User Group"
{
    Caption = 'Purchase Request User Group', comment = 'ITA="Gruppi utente per richieste di acquisto"';


    DrillDownPageId = "ATC_CP_User Group";
    LookupPageId = "ATC_CP_User Group";

    fields
    {
        field(10; Code; Code[50])
        {
            Caption = 'Code', comment = 'ITA="Codice"';
            DataClassification = CustomerContent;
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description', comment = 'ITA="Descrizione"';
            DataClassification = CustomerContent;
        }

        field(30; "ATC_CP_User Role"; Enum ATC_CP_RoleExtended)
        {
            Caption = 'Purchase Request User Role', comment = 'ITA="Ruolo utente richieste di acquisto"';
            DataClassification = CustomerContent;
        }

        field(40; "E-Mail"; text[80])
        {
            Caption = 'E-Mail', comment = 'ITA="E-Mail"';
            ExtendedDatatype = EMail;
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

}
