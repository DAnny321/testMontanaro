pageextension 90209 "ATC_CP_PurchaseArchiveExt" extends "Purchase Quote Archive"
{

    layout
    {
        addlast(General)
        {
            field("ATC_CP_Expense Type"; Rec."ATC_CP_Expense Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Expense Type', Comment = 'ITA="Specifica il tipo di spesa"';
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
            field("ATC_CP_Request Additional Info"; Rec."ATC_CP_Request Additional Info")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies request Additional Info', Comment = 'ITA="Specifica informazioni aggiuntive"';
                Editable = false;
            }
            field("ATC_CP_User Request"; Rec."ATC_CP_User Request")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies User Request', Comment = 'ITA="Specifica utente richiedente"';
                Editable = false;
            }
            field("ATC_CP_Request on Behalf of"; Rec."ATC_CP_Request on Behalf of")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies request on Behalf of', Comment = 'ITA="Specifica richiesta per conto di"';
                Editable = false;
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