table 90202 "ATC_CP_Dimension User Role"
{
    Caption = 'Purchase Request Dimension User Role', comment = 'ITA="Ruoli utente per dimensione per richieste di acquisto"';

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

        field(5; Type; enum ATC_CP_AssociationType)
        {
            Caption = 'Type', comment = 'ITA="Tipologia"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Type <> xRec.Type then
                    Validate("User Id", '');
            end;
        }
        field(10; "User Id"; Code[50])
        {
            Caption = 'Code', comment = 'ITA="Codice"';
            DataClassification = CustomerContent;
            TableRelation = if (Type = const(User)) "User Setup"."User ID" else
            "ATC_CP_User Group".Code;
            trigger OnValidate()
            var
                prUserGroup: Record "ATC_CP_User Group";
            begin
                if (Type = Type::UserGroup) and prUserGroup.Get("User Id") then
                    if (prUserGroup."ATC_CP_User Role".AsInteger() = prUserGroup."ATC_CP_User Role"::Requester.AsInteger()) then
                        Validate(Role, Role::Requester)
                    else
                        if (prUserGroup."ATC_CP_User Role" = prUserGroup."ATC_CP_User Role"::"Division Owner") then
                            Validate(Role, Role::"Division Owner");
            end;
        }
        field(20; "Role"; Enum ATC_CP_RoleShort)
        {
            Caption = 'Role', comment = 'ITA="Ruolo"';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "Dimension Code", Code, Type, "User Id")
        {
            Clustered = true;
        }

        key(Key2; Type, Role)
        {

        }
    }

    fieldgroups
    {
    }
}

