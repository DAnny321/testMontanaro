tableextension 90202 "ATC_CP_User Setup" extends "User Setup"
{

    fields
    {

        field(90200; "ATC_CP_User Role"; Enum ATC_CP_RoleShort2)
        {
            Caption = 'Purchase Request User Role', comment = 'ITA="Ruolo utente richieste di acquisto"';
            DataClassification = CustomerContent;
        }
        field(90201; "ATC_CP_User Group"; Code[50])
        {
            Caption = 'Purchase Request User Group', comment = 'ITA="Gruppo utenti per richieste di acquisto"';
            TableRelation = "ATC_CP_User Group".Code;
            DataClassification = CustomerContent;
        }
        field(90202; "ATC_CP_Enable PurchAddFunction"; Boolean)
        {
            Caption = 'Enable Purchase Additional Function', comment = 'ITA="Abilita funzioni aggiuntive ciclo passivo"';
            DataClassification = CustomerContent;
        }
        field(90203; "ATC_CP_Disable Purch. Notif."; Boolean)
        {
            Caption = 'Disable Purch. Notifications', comment = 'ITA="Disabilita notifiche ciclo passivo"';
            DataClassification = CustomerContent;
        }
        field(90204; "ATC_CP_Page Access Config."; Code[20])
        {
            Caption = 'Page Access Config.', comment = 'ITA="Configurazione accesso pagine"';
            TableRelation = "ATC_CP_Page Access Config.".Code;
            DataClassification = CustomerContent;
        }
    }


}

