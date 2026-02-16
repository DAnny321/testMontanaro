page 90213 "ATC_CP_User Group"
{
    PageType = List;
    SourceTable = "ATC_CP_User Group";
    Caption = 'Purchase Request User Group', comment = 'ITA="Gruppo utenti richieste di acquisto"';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code', Comment = 'ITA="Specifica il codice"';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Description', Comment = 'ITA="Specifica Descrizione"';
                }
                field("ATC_CP_User Role"; Rec."ATC_CP_User Role")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user Role', Comment = 'ITA="Specifa il ruolo utente"';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the e-Mail', Comment = 'ITA="Specifica l''e-mail"';
                }
            }
        }
    }
}
