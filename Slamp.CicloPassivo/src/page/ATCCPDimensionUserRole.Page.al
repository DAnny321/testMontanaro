page 90205 "ATC_CP_Dimension User Role"
{

    PageType = List;
    SourceTable = "ATC_CP_Dimension User Role";
    Caption = 'Dimension User Role', comment = 'ITA="Ruoli utenti per dimensione"';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Enter Code', Comment = 'ITA="Inserisci codice"';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Type', Comment = 'ITA="Inserisco tipo"';
                }
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter User Id', Comment = 'ITA="Inserisci ID Utente"';
                }
                field(Role; Rec.Role)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    ToolTip = 'Enter Role', Comment = 'ITA="Inserisci ruolo"';
                }
            }
        }
    }

    actions
    {
    }
}

