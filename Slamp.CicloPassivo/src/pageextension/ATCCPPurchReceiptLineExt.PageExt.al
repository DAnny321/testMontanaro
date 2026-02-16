pageextension 90204 "ATC_CP_PurchReceiptLineExt" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("ATC_CP_1st Vendor Rating"; Rec."ATC_CP_1st Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '1st Vendor Rating', Comment = 'ITA="Primo rating fornitori"';
                Editable = false;
                Visible = Show1stRating;

            }

            field("ATC_CP_2nd Vendor Rating"; Rec."ATC_CP_2nd Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '2st Vendor Rating', Comment = 'ITA="Secondo rating fornitori"';
                Editable = false;
                Visible = Show2ndRating;

            }

            field("ATC_CP_3rd Vendor Rating"; Rec."ATC_CP_3rd Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '3st Vendor Rating', Comment = 'ITA="Terzo rating fornitori"';
                Editable = false;
                Visible = Show3rdRating;

            }
        }
    }
    actions
    {
        // Add changes to page actions here
        //modify("&Undo Receipt")
        //{
        //    Visible = true;
        // }
        addlast("F&unctions")
        {
            /*
            Gestita da standard: non più utile per le nuove versioni. per le vecchie abilitare la gunzione
            action("ATC_Undo Receipt Conto")
            {
                ApplicationArea = All; ToolTip = '', Comment='ITA=" "';
                Image = Undo;
                //Caption = '&Undo Receipt', comment = 'ITA="Ann&ulla carico"';
                Caption = 'Undo G/L Account Receipt', comment = 'ITA="Ann&ulla carico su conto"';
                trigger OnAction()
                begin
                    UndoReceiptLine();
                end;
            }
            */

            action("ATC_CP_CloseQtyNotInvoiced")
            {
                ApplicationArea = All;
                ToolTip = 'Close Qty not invoiced', comment = 'ITA="Annulla quantità ricevuta non fatturata"';
                Image = UndoShipment;
                //Caption = 'Close Qty not invoiced', comment = 'ITA="Annulla quantità ricevuta non fatturata"';
                Caption = 'Close Qty not invoiced', comment = 'ITA="Annulla quantità ricevuta non fatturata"';
                trigger OnAction()
                var
                    PurchRequestMngt: Codeunit ATC_CP_PurchRequestMngt;
                    Mess_Msg: Label 'Operation Completed', comment = 'ITA="Operazione completata"';
                begin
                    if PurchRequestMngt.CloseQtyNotInvoiced(Rec) then
                        Message(Mess_Msg);
                end;
            }

        }
    }


    trigger OnOpenPage()
    var
        lRecPr_ATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin
        lRecPr_ATCCPGeneralSetup.CalcRatingVisibility(Show1stRating, Show2ndRating, Show3rdRating);
        //glbVisible := lRecPr_ATCCPGeneralSetup.isVisible();
    end;


    //Gestita da standard: non più utile per le nuove versioni. per le vecchie abilitare la funzione
    /*
    local procedure UndoReceiptLine()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(PurchRcptLine);
        Codeunit.Run(Codeunit::ATC_CP_CopUndPurRcptLine, PurchRcptLine);
    end;
    */

    var
        Show1stRating: Boolean;
        Show2ndRating: Boolean;
        Show3rdRating: Boolean;
    //ShowNoField: Boolean;
    //glbVisible: Boolean;
}