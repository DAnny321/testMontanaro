table 90210 "ATC_CP_Mail Recipients Setup"
{
    DrillDownPageId = "ATC_CP_Mail Recipients Setup";
    LookupPageId = "ATC_CP_Mail Recipients Setup";
    Caption = 'Mail Recipients Setup', comment = 'ITA="Setup notifiche mail"';

    fields
    {
        field(10; "Purchase Events"; Enum "ATC_CP_Purchase Events")
        {
            Caption = 'Purchase Events', comment = 'ITA="Evento acquisto"';
            DataClassification = CustomerContent;
        }
        field(20; "Role"; Enum ATC_CP_RoleExtended)
        {
            Caption = 'Role', comment = 'ITA="Ruolo"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (Role <> xRec.Role) and (xRec.Role <> xRec.Role::" ") then begin
                    "Send Mail As" := "Send Mail As"::" ";
                    "Recover Mail Address From" := "Recover Mail Address From"::UserSetup;
                end;
            end;
        }

        field(30; "Send Mail As"; Enum "ATC_CP_Notify Mail as")
        {
            Caption = 'Notify Mail by', comment = 'ITA="Invia mail notifica in"';
            DataClassification = CustomerContent;
        }

        field(40; "Recover Mail Address From"; Enum "ATC_CP_Recover Mail From")
        {
            Caption = 'Recover Mail Address From', comment = 'ITA="Recupera mail da indirizzo"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Role_Err: Label 'Role must be %1 or %2 for generici mail', comment = 'ITA="Ruolo deve essere %1 o %2 per la mail generica"';
            begin
                if "Recover Mail Address From" = "Recover Mail Address From"::GenericMail then
                    if not (Role in [Role::"Purchase Office", Role::Administration]) then
                        FieldError("Recover Mail Address From", StrSubstNo(Role_Err, Role::"Purchase Office", Role::Administration));
            end;
        }
    }
    keys
    {
        key(Key1; "Purchase Events", Role)
        {
            Clustered = true;
        }
    }
}