pageextension 90208 "ATC_CP_Purch Orders List Ext" extends "Purchase Order List"
{

    layout
    {

        addlast(Control1)
        {
            field(ATC_CP_QuoteNo; Rec."Quote No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Quote No.', Comment = 'ITA="Specifica nr. offerta"';
                Editable = false;
            }
            field("ATC_CP_User Request"; Rec."ATC_CP_User Request")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies User Request', Comment = 'ITA="Specifica utente richiedente"';
                Editable = false;
            }
            field("ATC_CP_Expense Type"; Rec."ATC_CP_Expense Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Expence Category Code', Comment = 'ITA="Specifica Codice Categoria di spesa"';
                Editable = false;
            }
            field("ATC_CP_Request Description"; Rec."ATC_CP_Request Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Request Description', Comment = 'ITA="Specifica descrizione richiesta"';
                Editable = false;
            }
            field("ATC_CP_Creation Date"; Rec."ATC_CP_Creation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies when the traced record was created', Comment = 'ITA="Specifica la data di creazione del record tracciato"';
                Editable = false;
            }

            field("ATC_CP_Request Priority"; Rec."ATC_CP_Request Priority")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the request Priority', Comment = 'ITA="Specifica la priorità richiesta"';
                Editable = false;
            }
        }
    }
    actions
    {
        addlast("Request Approval")
        {

            action(ATC_CP_RequestPurchPost)
            {
                Caption = 'Request Receipt Post', comment = 'ITA="Richiedi reg. carico"';
                Image = ReceiptReminder;
                ApplicationArea = All;
                ToolTip = 'Request Receipt Post', comment = 'ITA="Richiedi reg. carico"';
                trigger OnAction()
                begin
                    Message('Ok');
                end;
            }

        }
    }

    trigger OnOpenPage()
    var
    //lRecPr_ATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin
        //glbVisible := lRecPr_ATCCPGeneralSetup.isVisible();
    end;

    var
    //glbVisible: Boolean;
}