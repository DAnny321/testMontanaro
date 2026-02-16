pageextension 90200 "ATC_CP_User Setup" extends "Approval User Setup"
{
    layout
    {
        modify(PhoneNo)
        {
            Visible = not Show;
        }
        modify("Sales Amount Approval Limit")
        {
            Visible = not Show;
        }
        modify("Unlimited Sales Approval")
        {
            Visible = not Show;
        }


        addlast(Control1)
        {
            field("ATC_CP_User Role"; Rec."ATC_CP_User Role")
            {
                ApplicationArea = All;
                ToolTip = 'Specifie user Role', Comment = 'ITA="Specifica ruolo utente"';
                Visible = Show;
                Editable = Show;
            }
            field("ATC_CP_User Group"; Rec."ATC_CP_User Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies user Group', Comment = 'ITA="Specifica gruppo utenti per richieste di acquisto"';
                Visible = Show;
                Editable = Show;
            }
            field("ATC_CP_Enable PurchAddFunction"; Rec."ATC_CP_Enable PurchAddFunction")
            {
                ApplicationArea = All;
                ToolTip = 'Enable PurchAddFunction', Comment = 'ITA="Abilita funzioni aggiuntive ciclo passivo"';
                Visible = Show;
                Editable = Show;
            }
            field("ATC_CP_Disable Purch. Notif."; Rec."ATC_CP_Disable Purch. Notif.")
            {
                ApplicationArea = All;
                ToolTip = 'Disable Purch. Notif.', Comment = 'ITA="Disabilita notifiche ciclo passivo"';
                Visible = Show;
                Editable = Show;
            }

            field("ATC_CP_Page Access Config."; Rec."ATC_CP_Page Access Config.")
            {
                ApplicationArea = All;
                ToolTip = 'Page Access Config.', Comment = 'ITA="Specifica configurazione accesso pagine"';
                Visible = Show;
                Editable = Show;
            }
        }
    }


    trigger OnOpenPage()
    var
        lRecPr_ATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin
        Show := lRecPr_ATCCPGeneralSetup.isVisible() and glbVis;
    end;

    procedure ATC_CP_setVisibility()
    begin
        glbVis := true;
    end;

    var
        Show: Boolean;
        glbVis: Boolean;
}