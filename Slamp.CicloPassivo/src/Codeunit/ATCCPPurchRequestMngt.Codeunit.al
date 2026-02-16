Codeunit 90200 ATC_CP_PurchRequestMngt
{
    Permissions = tabledata 121 = rmdi;
    trigger OnRun()
    begin
    end;


    procedure CloseOutstandingQty(VAR PurchaseLine: Record "Purchase Line")
    var
        UserSetup: Record "User Setup";
        LoseOutstandingQtyLbl: Label 'Do you want lose Outstanding Qty for line %1?', comment = 'ITA="Si desidera lanciare la funzione e annullare il residuo per la riga %1 selezionata?"';
        ErrLineLbl: Label 'Function is not allowed', comment = 'ITA="Utente non abilitato alla funzionalità di Perdi Quantità Inevasa"';
        ErrConfLbl: Label 'Operation Canceled', comment = 'ITA="Operazione annullata"';
    begin
        //ID_AppCheckControl_begin
        clear(cuCheckApp);
        cuCheckApp.RunCheck(Enum::ATC_SC_ExtensionAgic::CicloPassivo, '');
        //ID_AppCheckControl_end

        UserSetup.GET(USERID);
        if not (UserSetup."ATC_CP_Enable PurchAddFunction") then
            Error(ErrLineLbl);

        if not CONFIRM(LoseOutstandingQtyLbl, FALSE, PurchaseLine."Line No.") then
            ERROR(ErrConfLbl);

        PurchaseLine.TestField("ATC_CP_Lost Outstanding Qty", false);
        PurchaseLine.testfield("Outstanding Qty. (Base)");

        OnBeforeCloseOutstandingQty(PurchaseLine);

        PurchaseLine."ATC_CP_Lost Outstanding Qty" := TRUE;
        PurchaseLine."Completely Received" := TRUE;
        PurchaseLine.VALIDATE("Qty. to Receive", 0);
        PurchaseLine.VALIDATE("Outstanding Quantity", 0);
        PurchaseLine.VALIDATE("Outstanding Amount", 0);
        PurchaseLine.VALIDATE("Qty. to Invoice", PurchaseLine."Quantity Received" - PurchaseLine."Quantity Invoiced");
        PurchaseLine.VALIDATE("Qty. to Invoice (Base)", PurchaseLine."Qty. Received (Base)"
                                                           - PurchaseLine."Qty. Invoiced (Base)");
        PurchaseLine."Qty. to Receive (Base)" := 0;
        PurchaseLine."Outstanding Qty. (Base)" := 0;
        PurchaseLine.Quantity := PurchaseLine."Quantity Received";
        PurchaseLine."Quantity (Base)" := PurchaseLine."Qty. Received (Base)";


        IF PurchaseLine.Quantity = 0 THEN BEGIN
            PurchaseLine.Amount := 0;
            PurchaseLine."Amount Including VAT" := 0;
            PurchaseLine."VAT Base Amount" := 0;
        END;
        PurchaseLine.UpdateAmounts();

        PurchaseLine.MODIFY();

        OnAfterCloseOutstandingQty(PurchaseLine);

    END;

    procedure CloseQtyNotInvoiced(VAR PurchRcptLine: Record "Purch. Rcpt. Line"): Boolean
    var
        lRecPurchaseLine: Record "Purchase Line";
        UserSetup: Record "User Setup";
        CloseQtyNotInvoicedMsg: Label 'Do you want lose Outstanding Qty for line %1?', comment = 'ITA="Si desidera lanciare la funzione e annullare il residuo per la riga %1 selezionata?"';
        ErrLineLbl: Label 'Function is not allowed', comment = 'ITA="Utente non abilitato alla funzionalità"';
        ErrLine2Lbl: Label 'It is not possible run function on line wuth Type Blank %1,%2,%3,%4', comment = 'ITA="Non è possibile annullare %1 per le righe descrittive in %2 %3, linea %4"';
        ErrConfLbl: Label 'Operation Canceled', comment = 'ITA="Operazione annullata"';
    begin
        //ID_AppCheckControl_begin
        clear(cuCheckApp);
        cuCheckApp.RunCheck(Enum::ATC_SC_ExtensionAgic::CicloPassivo, '');
        //ID_AppCheckControl_end

        UserSetup.GET(USERID);
        if not (UserSetup."ATC_CP_Enable PurchAddFunction") then
            Error(ErrLineLbl);

        if not CONFIRM(CloseQtyNotInvoicedMsg, FALSE, PurchRcptLine."Line No.") then
            ERROR(ErrConfLbl);

        IF PurchRcptLine.Type = PurchRcptLine.Type::" " THEN
            ERROR(ErrLine2Lbl, PurchRcptLine.FIELDCAPTION("Qty. Rcd. Not Invoiced"), PurchRcptLine.TABLECAPTION, PurchRcptLine."Document No.", PurchRcptLine."Line No.");

        PurchRcptLine.TestField("Qty. Rcd. Not Invoiced");

        OnBeforeCloseQtyNotInvoiced(lRecPurchaseLine, PurchRcptLine);

        if lRecPurchaseLine.get(lRecPurchaseLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.") then begin

            lRecPurchaseLine."Qty. Rcd. Not Invoiced" := lRecPurchaseLine."Qty. Rcd. Not Invoiced" - PurchRcptLine."Qty. Rcd. Not Invoiced";
            IF lRecPurchaseLine."Qty. to Invoice" > lRecPurchaseLine."Qty. Rcd. Not Invoiced" THEN
                lRecPurchaseLine."Qty. to Invoice" := lRecPurchaseLine."Qty. Rcd. Not Invoiced";
            lRecPurchaseLine."Qty. to Invoice (Base)" := ROUND(lRecPurchaseLine."Qty. to Invoice" * lRecPurchaseLine."Qty. per Unit of Measure", 0.00001);
            lRecPurchaseLine.MODIFY();
        end;

        PurchRcptLine."Qty. Rcd. Not Invoiced" := 0;
        PurchRcptLine.MODIFY();

        OnAfterCloseQtyNotInvoiced(lRecPurchaseLine, PurchRcptLine);
        exit(true);
    end;

    procedure CreateFieldArray(var SelectedValue: array[11] of Text; variant: Variant; ParRec_ATCCPEmailNotificSetup: Record "ATC_CP_Email Notific. Setup")
    var
        lRecATCCPSelectionFieldMail: Record "ATC_CP_Selection Field Mail";
        PageManagement: Codeunit "Page Management";
        //SettingsURL: Text;
        lRecRef_RecordRef: RecordRef;
        fieldRef: FieldRef;
        contatore: Integer;
        valore: Text;
    begin
        lRecRef_RecordRef.GetTable(variant);
        lRecATCCPSelectionFieldMail.Reset();
        lRecATCCPSelectionFieldMail.SetRange("Purchase Events", lRecATCCPSelectionFieldMail."Purchase Events"::RequestRelease);
        lRecATCCPSelectionFieldMail.SetRange("Table No.", 38);
        lRecATCCPSelectionFieldMail.setrange(Active, true);
        if lRecATCCPSelectionFieldMail.FindSet() then begin
            contatore := 0;
            repeat
                contatore += 1;
                fieldRef := lRecRef_RecordRef.Field(lRecATCCPSelectionFieldMail."Field No.");
                if fieldRef.Class = fieldRef.Class::FlowField then
                    fieldRef.CalcField();
                if fieldRef.Type = fieldRef.Type::Decimal then
                    valore := Format(FORMAT(fieldRef.Value, 0, '<Precision,2:2><Integer><Decimals,0>'))
                else
                    evaluate(valore, Format(fieldRef.Value));
                SelectedValue[contatore] := valore;
            until lRecATCCPSelectionFieldMail.Next() = 0;
        end;

        if ParRec_ATCCPEmailNotificSetup."Create Link" then begin
            if ParRec_ATCCPEmailNotificSetup."Link Target Page" = 0 then
                ParRec_ATCCPEmailNotificSetup."Link Target Page" := PageManagement.GetPageID(lRecRef_RecordRef);

            SelectedValue[11] := PageManagement.GetWebUrl(lRecRef_RecordRef, ParRec_ATCCPEmailNotificSetup."Link Target Page");
        end;
    end;

    procedure verifyMoveAttach(ParRecQuote_PurchaseHeader: Record "Purchase Header"): Boolean
    var
        DocumentAttachment: Record "Document Attachment";
        DocumentAttachmentReplace: Record "Document Attachment";
    begin
        DocumentAttachment.Reset();
        DocumentAttachment.SetFilter("Table ID", '%1|%2', 38, 39);
        DocumentAttachment.SetRange("Document Type", DocumentAttachment."Document Type"::Quote);
        DocumentAttachment.SetRange("No.", ParRecQuote_PurchaseHeader."No.");
        if DocumentAttachment.FindSet() then begin
            repeat
                DocumentAttachmentReplace.Get(DocumentAttachment."Table ID", DocumentAttachment."No.", DocumentAttachment."Document Type", DocumentAttachment."Line No.", DocumentAttachment.ID);
                DocumentAttachmentReplace.Rename(DocumentAttachment."Table ID", DocumentAttachment."No.", DocumentAttachment."Document Type".AsInteger() + 10, DocumentAttachment."Line No.", DocumentAttachment.ID);
            until DocumentAttachment.Next() = 0;
            exit(true);
        end;
        exit(false);
    end;

    procedure UpdatePurchaseRequestLine(var VarPurchaseLine: Record "Purchase Line")
    var
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
        blnResetPrice: Boolean;
        blnDefaultPrice: Boolean;
    begin
        if not lRecATCCPGeneralSetup.isActiveCheck() then
            exit;
        if (VarPurchaseLine."Document Type" <> VarPurchaseLine."Document Type"::Quote) or (not VarPurchaseLine."ATC_CP_Purchase Request") then
            exit;

        if lRecATCCPGeneralSetup.isActiveHierarchy() then
            populateHierarchyFields(VarPurchaseLine);

        lRecATCCPGeneralSetup.AmountMngt(blnResetPrice, blnDefaultPrice);
        if blnResetPrice then
            ResetPriceDiscount(VarPurchaseLine);
        if blnDefaultPrice then
            DefaultPrice(VarPurchaseLine);
    end;

    procedure VerifyPermissionPurchPage(PageId: Integer)
    var
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
        userSetup: Record "User Setup";
        lRecATCCPPageAccessConfig: Record "ATC_CP_Page Access Config.";
        MessErr: Label 'Unauthorized User: please contact a Purchase Administrator for information.', comment = 'ITA="Utente non autorizzato: contattare un utente amministratore acquisti per informazioni"';
    begin
        if not lRecATCCPGeneralSetup.isActiveCheck() then
            exit;

        userSetup.Get(UserId);
        if not lRecATCCPPageAccessConfig.Get(userSetup."ATC_CP_Page Access Config.") then
            exit;

        //with pageSetupPerm do begin
        case PageId of
            9306: //quote
                if lRecATCCPPageAccessConfig."Disable Quote" then
                    Error(MessErr);
            9307: //Order
                if lRecATCCPPageAccessConfig."Disable Order" then
                    Error(MessErr);
            9308: //Invoice
                if lRecATCCPPageAccessConfig."Disable Invoice" then
                    Error(MessErr);
            9309: //Cr. Memo
                if lRecATCCPPageAccessConfig."Disable Cr. Memo" then
                    Error(MessErr);
            9310: //Blanket Order
                if lRecATCCPPageAccessConfig."Disable Blanket Order" then
                    Error(MessErr);
            9311: //return Order
                if lRecATCCPPageAccessConfig."Disable Return Order" then
                    Error(MessErr);
        end;
        //end;
    end;


    procedure populateHierarchyFields(var PurchaseLine: Record "Purchase Line")
    var
        locItem: Record Item;
        locGLAccount: Record "G/L Account";
    begin
        case PurchaseLine.Type of
            PurchaseLine.Type::Item:
                if locItem.Get(PurchaseLine."No.") then begin
                    PurchaseLine."ATC_CP_Expence Category" := locItem."ATC_CP_Expence Category";
                    PurchaseLine."ATC_CP_Expence SubCategory" := locItem."ATC_CP_Expence SubCategory";
                    PurchaseLine."ATC_CP_Expence Details" := locItem."ATC_CP_Expence Details";
                end;
            PurchaseLine.Type::"G/L Account":
                if locGLAccount.Get(PurchaseLine."No.") then begin
                    PurchaseLine."ATC_CP_Expence Category" := locGLAccount."ATC_CP_Expence Category";
                    PurchaseLine."ATC_CP_Expence SubCategory" := locGLAccount."ATC_CP_Expence SubCategory";
                    PurchaseLine."ATC_CP_Expence Details" := locGLAccount."ATC_CP_Expence Details";
                end;
        end;
    end;

    procedure ResetPriceDiscount(var VarPurchaseLine: Record "Purchase Line")
    begin
        VarPurchaseLine.Validate("Direct Unit Cost", 0);
        VarPurchaseLine.Validate("Line Discount %", 0);
    end;

    procedure DefaultPrice(var VarPurchaseLine: Record "Purchase Line")
    begin
        VarPurchaseLine.Validate("Direct Unit Cost", 1);
    end;


    procedure CheckLineRating(Par_PurchaseLine: Record "Purchase Line")
    var
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
        lMessErr: Label 'Error: for %1 it is mandatory to specify the field "%2"', comment = 'ITA="Specificare per la riga %1 il campo "%2""';
    begin
        lRecATCCPGeneralSetup.Get();
        if (lRecATCCPGeneralSetup."First Vendor Rating" <> '') and (Par_PurchaseLine."ATC_CP_1st Vendor Rating" = Par_PurchaseLine."ATC_CP_1st Vendor Rating"::" ") then
            Error(lMessErr, Par_PurchaseLine.RecordId, lRecATCCPGeneralSetup.getRatingCaption(1));
        if (lRecATCCPGeneralSetup."Second Vendor Rating" <> '') and (Par_PurchaseLine."ATC_CP_2nd Vendor Rating" = Par_PurchaseLine."ATC_CP_2nd Vendor Rating"::" ") then
            Error(lMessErr, Par_PurchaseLine.RecordId, lRecATCCPGeneralSetup.getRatingCaption(2));
        if (lRecATCCPGeneralSetup."Third Vendor Rating" <> '') and (Par_PurchaseLine."ATC_CP_3rd Vendor Rating" = Par_PurchaseLine."ATC_CP_3rd Vendor Rating"::" ") then
            Error(lMessErr, Par_PurchaseLine.RecordId, lRecATCCPGeneralSetup.getRatingCaption(3));
    end;

    procedure ReplaceAttach(recOrder_PurchaseHeader: Record "Purchase Header")
    var
        DocumentAttachment: Record "Document Attachment";
        DocumentAttachmentReplace: Record "Document Attachment";
    begin
        DocumentAttachment.Reset();
        DocumentAttachment.SetFilter("Table ID", '%1|%2', 38, 39);
        DocumentAttachment.SetRange("Document Type", DocumentAttachment."Document Type"::Quote.AsInteger() + 10);
        DocumentAttachment.SetRange("No.", recOrder_PurchaseHeader."Quote No.");
        if DocumentAttachment.FindSet() then
            repeat
                DocumentAttachmentReplace.Get(DocumentAttachment."Table ID", DocumentAttachment."No.", DocumentAttachment."Document Type", DocumentAttachment."Line No.", DocumentAttachment.ID);
                DocumentAttachmentReplace.Rename(DocumentAttachment."Table ID", recOrder_PurchaseHeader."No.", DocumentAttachment."Document Type"::Order, DocumentAttachment."Line No.", DocumentAttachment.ID);
            until DocumentAttachment.Next() = 0;
    end;

    procedure SendPurchMail(PurchaseHeader: Record "Purchase Header"; PurchEvent: Enum "ATC_CP_Purchase Events")
    var
        userSetup: Record "User Setup";
        lRecATCCPEmailNotificSetup: Record "ATC_CP_Email Notific. Setup";
        /*
        Old Code begin
        SMTPMail_l: Codeunit 400;
        SMTPMailSetup: Record "SMTP Mail Setup";
        Old Code End
        */
        // new code Begin
        EmailMessage: Codeunit "Email Message";
        lCuSmtp_EmailAccount: Codeunit "Email Account";
        Email: Codeunit Email;
        // new code End
        cuTempBlob: Codeunit "Temp Blob";
        //MailManagement_l: Codeunit 9520;
        SenderMail: Text;
        ReceiptMail: List of [text];
        CCMail: List of [text];
        CCNMail: List of [text];
        EmailBodyText_par: Text;
        Body_par_1: Text;
        Object_par: Text;
        SelectedValue: array[11] of text;
        inStream: InStream;
        Send2CC: Boolean;
        Send2CCN: Boolean;
        ConfirmMsg: Label 'Do you want sent Noficiation Mail for "%1"?', comment = 'ITA="Si desidera inviare la mail di notifica configurata per l''evento "%1"?"';
        CompletedMsg: Label 'Operation completed', comment = 'ITA="Operazione completata"';
        PrGenSetup: Record "ATC_CP_General Setup";
    begin
        if not PrGenSetup.isActiveCheck() then
            exit;

        if not lRecATCCPEmailNotificSetup.Get(PurchEvent) or not lRecATCCPEmailNotificSetup.Active then
            exit;

        //TODO: aggiungere un campo per farlo parametrico
        if lRecATCCPEmailNotificSetup."Request Confirm Message" then
            if not Confirm(StrSubstNo(ConfirmMsg, lRecATCCPEmailNotificSetup."Purchase Events")) then
                exit;

        CreateFieldArray(SelectedValue, PurchaseHeader, lRecATCCPEmailNotificSetup);
        Object_par := lRecATCCPEmailNotificSetup.GetObjectMail();

        Object_par := StrSubstNo(Object_par,
            SelectedValue[1], SelectedValue[2], SelectedValue[3], SelectedValue[4], SelectedValue[5]
            , SelectedValue[6], SelectedValue[7], SelectedValue[8], SelectedValue[9], SelectedValue[10]);

        CLEAR(SenderMail);
        CLEAR(ReceiptMail);
        Clear(CCMail);
        Clear(CCNMail);
        Clear(Send2CC);
        Clear(Send2CCN);

        userSetup.Get(PurchaseHeader."ATC_CP_User Request");
        /* Old Code Begin
        CLEAR(SMTPMail_l);
        SMTPMailSetup.Get();  
           Old Code End
        */
        //creo destinatari, CC, CCN
        FindReceipt(PurchaseHeader, ReceiptMail, lRecATCCPEmailNotificSetup."Purchase Events");
        FindCC(PurchaseHeader, CCMail, lRecATCCPEmailNotificSetup."Purchase Events", Send2CC);
        FindCCN(PurchaseHeader, CCNMail, lRecATCCPEmailNotificSetup."Purchase Events", Send2CCN);

        cuTempBlob.FromRecord(lRecATCCPEmailNotificSetup, lRecATCCPEmailNotificSetup.FieldNo("Mail Body"));
        cuTempBlob.CreateInStream(inStream);
        inStream.Read(Body_par_1);
        EmailBodyText_par := StrSubstNo(Body_par_1,
            SelectedValue[1], SelectedValue[2], SelectedValue[3], SelectedValue[4], SelectedValue[5]
            , SelectedValue[6], SelectedValue[7], SelectedValue[8], SelectedValue[9], SelectedValue[10], SelectedValue[11]);

        /* Old Code Begin

        SMTPMail_l.CreateMessage(
            NotificationSetup."Send Mail As",
            SMTPMailSetup."User ID",
            ReceiptMail,
            Object_par,
            EmailBodyText_par,
            true);

        if Send2CC then
            SMTPMail_l.AddCC(CCMail);
        if Send2CCN then
            SMTPMail_l.AddBCC(CCNMail);
        SMTPMail_l.Send;
        Old code end */

        // new code - begin
        clear(Email);
        clear(EmailMessage);
        clear(lCuSmtp_EmailAccount);

        if not Send2CC then
            Clear(CCMail);
        if not Send2CCN then
            Clear(CCNMail);
        EmailMessage.Create(ReceiptMail, Object_par, EmailBodyText_par, true, CCMail, CCNMail);
        Email.Send(EmailMessage, PrGenSetup."Send Email Scenario");

        // new code - end

        if lRecATCCPEmailNotificSetup."Request Confirm Message" then
            Message(CompletedMsg);
    end;

    procedure FindReceipt(P_PurchaseHeader: Record "Purchase Header"; var ReceiptMail: List of [Text]; purchEvents: enum "ATC_CP_Purchase Events")
    var
        lRecATCCPMailRecipientsSetup: Record "ATC_CP_Mail Recipients Setup";
        userSetup: Record "User Setup";
        lRecATCCPUserGroup: Record "ATC_CP_User Group";
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
        //SmtpMail: Codeunit "SMTP Mail"; Old Code
        lRecATCCPDimensionUserRole: Record "ATC_CP_Dimension User Role";
        GeneralLedgerSetup: Record "General Ledger Setup";
        MailManagement: Codeunit "Mail Management";
    begin
        GeneralLedgerSetup.Get();
        lRecATCCPMailRecipientsSetup.Reset();
        lRecATCCPMailRecipientsSetup.setrange("Purchase Events", purchEvents);
        lRecATCCPMailRecipientsSetup.SetRange("Send Mail As", lRecATCCPMailRecipientsSetup."Send Mail As"::A);
        if lRecATCCPMailRecipientsSetup.FindSet() then
            repeat
                case lRecATCCPMailRecipientsSetup.Role of
                    lRecATCCPMailRecipientsSetup.Role::Requester:
                        case lRecATCCPMailRecipientsSetup."Recover Mail Address From" of
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::UserSetup:
                                begin
                                    P_PurchaseHeader.TestField("ATC_CP_User Request");
                                    userSetup.Get(P_PurchaseHeader."ATC_CP_User Request");
                                    if (userSetup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                        MailManagement.CheckValidEmailAddresses(userSetup."E-Mail");
                                        ReceiptMail.Add(userSetup."E-Mail");
                                    end;
                                end;
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::GroupMail:
                                begin
                                    P_PurchaseHeader.TestField("ATC_CP_User Request");
                                    userSetup.Get(P_PurchaseHeader."ATC_CP_User Request");
                                    if (userSetup."ATC_CP_User Group" <> '') and lRecATCCPUserGroup.get(userSetup."ATC_CP_User Group") then
                                        if lRecATCCPUserGroup."E-Mail" <> '' then begin
                                            MailManagement.CheckValidEmailAddresses(lRecATCCPUserGroup."E-Mail");
                                            ReceiptMail.Add(lRecATCCPUserGroup."E-Mail");
                                        end;
                                end;
                        end;
                    lRecATCCPMailRecipientsSetup.Role::"Division Owner":
                        begin
                            lRecATCCPDimensionUserRole.Reset();
                            if lRecATCCPGeneralSetup.isGlobalDim1() then begin
                                lRecATCCPDimensionUserRole.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 1 Code");
                                lRecATCCPDimensionUserRole.SetRange(Code, P_PurchaseHeader."Shortcut Dimension 1 Code");
                            end else begin
                                lRecATCCPDimensionUserRole.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 2 Code");
                                lRecATCCPDimensionUserRole.SetRange(Code, P_PurchaseHeader."Shortcut Dimension 2 Code");
                            end;

                            lRecATCCPDimensionUserRole.SetRange(Role, lRecATCCPDimensionUserRole.Role::"Division Owner");
                            if lRecATCCPDimensionUserRole.FindSet() then
                                repeat
                                    case lRecATCCPMailRecipientsSetup."Recover Mail Address From" of
                                        lRecATCCPMailRecipientsSetup."Recover Mail Address From"::UserSetup:
                                            if lRecATCCPDimensionUserRole.Type = lRecATCCPDimensionUserRole.Type::User then begin
                                                userSetup.Get(lRecATCCPDimensionUserRole."User Id");
                                                if (userSetup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                                    MailManagement.CheckValidEmailAddresses(userSetup."E-Mail");
                                                    ReceiptMail.Add(userSetup."E-Mail");
                                                end;
                                            end else begin
                                                lRecATCCPUserGroup.Get(lRecATCCPDimensionUserRole."User Id");
                                                if lRecATCCPUserGroup."E-Mail" <> '' then begin
                                                    MailManagement.CheckValidEmailAddresses(lRecATCCPUserGroup."E-Mail");
                                                    ReceiptMail.Add(lRecATCCPUserGroup."E-Mail");
                                                end;
                                            end;
                                        lRecATCCPMailRecipientsSetup."Recover Mail Address From"::GroupMail:
                                            if lRecATCCPDimensionUserRole.Type = lRecATCCPDimensionUserRole.Type::UserGroup then begin
                                                lRecATCCPUserGroup.Get(lRecATCCPDimensionUserRole."User Id");
                                                if lRecATCCPUserGroup."E-Mail" <> '' then begin
                                                    MailManagement.CheckValidEmailAddresses(lRecATCCPUserGroup."E-Mail");
                                                    ReceiptMail.Add(lRecATCCPUserGroup."E-Mail");
                                                end;
                                            end
                                            else
                                                if (lRecATCCPDimensionUserRole.Type = lRecATCCPDimensionUserRole.Type::User) then begin
                                                    userSetup.Get(lRecATCCPDimensionUserRole."User Id");
                                                    if (userSetup."ATC_CP_User Group" <> '') and lRecATCCPUserGroup.Get(userSetup."ATC_CP_User Group") and (lRecATCCPUserGroup."E-Mail" <> '') then begin
                                                        MailManagement.CheckValidEmailAddresses(lRecATCCPUserGroup."E-Mail");
                                                        ReceiptMail.Add(lRecATCCPUserGroup."E-Mail");
                                                    end;
                                                end;
                                    end;
                                until lRecATCCPDimensionUserRole.Next() = 0;
                        end;
                    lRecATCCPMailRecipientsSetup.Role::Administration:
                        case lRecATCCPMailRecipientsSetup."Recover Mail Address From" of
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::UserSetup:
                                begin
                                    userSetup.Reset();
                                    userSetup.SetRange("ATC_CP_User Role", userSetup."ATC_CP_User Role"::Administration);
                                    userSetup.SetFilter("E-Mail", '<>%1', '');
                                    if userSetup.FindSet() then
                                        repeat
                                            if (userSetup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                                MailManagement.CheckValidEmailAddresses(userSetup."E-Mail");
                                                ReceiptMail.Add(userSetup."E-Mail");
                                            end;
                                        until userSetup.Next() = 0;
                                end;
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::GenericMail:
                                begin
                                    lRecATCCPGeneralSetup.Get();
                                    lRecATCCPGeneralSetup.TestField("Administration E-Mail");
                                    MailManagement.CheckValidEmailAddresses(lRecATCCPGeneralSetup."Administration E-Mail");
                                    ReceiptMail.Add(lRecATCCPUserGroup."E-Mail");
                                end;
                        end;
                    lRecATCCPMailRecipientsSetup.Role::"Purchase Office":
                        case lRecATCCPMailRecipientsSetup."Recover Mail Address From" of
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::UserSetup:
                                begin
                                    userSetup.Reset();
                                    userSetup.SetRange("ATC_CP_User Role", userSetup."ATC_CP_User Role"::"Purchase Office");
                                    userSetup.SetFilter("E-Mail", '<>%1', '');
                                    if userSetup.FindSet() then
                                        repeat
                                            if (userSetup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                                MailManagement.CheckValidEmailAddresses(userSetup."E-Mail");
                                                ReceiptMail.Add(userSetup."E-Mail");
                                            end;
                                        until userSetup.Next() = 0;
                                end;
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::GenericMail:
                                begin
                                    lRecATCCPGeneralSetup.Get();
                                    lRecATCCPGeneralSetup.TestField("Purchase Office E-Mail");
                                    MailManagement.CheckValidEmailAddresses(lRecATCCPGeneralSetup."Purchase Office E-Mail");
                                    ReceiptMail.Add(lRecATCCPUserGroup."E-Mail");
                                end;
                        end;
                end;
            until lRecATCCPMailRecipientsSetup.Next() = 0;
    end;

    procedure FindCC(pRecPurchaseHeader: Record "Purchase Header"; var CCMail: List of [Text]; purchEvents: enum "ATC_CP_Purchase Events"; var Send2CC: Boolean)
    var
        lRecATCCPMailRecipientsSetup: Record "ATC_CP_Mail Recipients Setup";
        userSetup: Record "User Setup";
        lRecATCCPUserGroup: Record "ATC_CP_User Group";
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
        // SmtpMail: Codeunit "SMTP Mail"; Old Code
        lRecATCCPDimensionUserRole: Record "ATC_CP_Dimension User Role";
        GeneralLedgerSetup: Record "General Ledger Setup";
        MailManagement: Codeunit "Mail Management";
    begin
        GeneralLedgerSetup.Get();
        lRecATCCPMailRecipientsSetup.Reset();
        lRecATCCPMailRecipientsSetup.setrange("Purchase Events", purchEvents);
        lRecATCCPMailRecipientsSetup.SetRange("Send Mail As", lRecATCCPMailRecipientsSetup."Send Mail As"::CC);
        if lRecATCCPMailRecipientsSetup.FindSet() then
            repeat
                case lRecATCCPMailRecipientsSetup.Role of
                    lRecATCCPMailRecipientsSetup.Role::Requester:
                        case lRecATCCPMailRecipientsSetup."Recover Mail Address From" of
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::UserSetup:
                                begin
                                    pRecPurchaseHeader.TestField("ATC_CP_User Request");
                                    userSetup.Get(pRecPurchaseHeader."ATC_CP_User Request");
                                    if (userSetup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                        MailManagement.CheckValidEmailAddresses(userSetup."E-Mail");
                                        Send2CC := true;
                                        CCMail.Add(userSetup."E-Mail");
                                    end;
                                end;
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::GroupMail:
                                begin
                                    pRecPurchaseHeader.TestField("ATC_CP_User Request");
                                    userSetup.Get(pRecPurchaseHeader."ATC_CP_User Request");
                                    if (userSetup."ATC_CP_User Group" <> '') and lRecATCCPUserGroup.get(userSetup."ATC_CP_User Group") then
                                        if (lRecATCCPUserGroup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                            MailManagement.CheckValidEmailAddresses(lRecATCCPUserGroup."E-Mail");
                                            Send2CC := true;
                                            CCMail.Add(lRecATCCPUserGroup."E-Mail");
                                        end;
                                end;
                        end;
                    lRecATCCPMailRecipientsSetup.Role::"Division Owner":
                        begin
                            lRecATCCPDimensionUserRole.Reset();
                            if lRecATCCPGeneralSetup.isGlobalDim1() then begin
                                lRecATCCPDimensionUserRole.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 1 Code");
                                lRecATCCPDimensionUserRole.SetRange(Code, pRecPurchaseHeader."Shortcut Dimension 1 Code");
                            end else begin
                                lRecATCCPDimensionUserRole.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 2 Code");
                                lRecATCCPDimensionUserRole.SetRange(Code, pRecPurchaseHeader."Shortcut Dimension 2 Code");
                            end;

                            lRecATCCPDimensionUserRole.SetRange(Role, lRecATCCPDimensionUserRole.Role::"Division Owner");
                            if lRecATCCPDimensionUserRole.FindSet() then
                                repeat
                                    case lRecATCCPMailRecipientsSetup."Recover Mail Address From" of
                                        lRecATCCPMailRecipientsSetup."Recover Mail Address From"::UserSetup:
                                            if lRecATCCPDimensionUserRole.Type = lRecATCCPDimensionUserRole.Type::User then begin
                                                userSetup.Get(lRecATCCPDimensionUserRole."User Id");
                                                if (userSetup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                                    MailManagement.CheckValidEmailAddresses(userSetup."E-Mail");
                                                    Send2CC := true;
                                                    CCMail.Add(userSetup."E-Mail");
                                                end;
                                            end else begin
                                                lRecATCCPUserGroup.Get(lRecATCCPDimensionUserRole."User Id");
                                                if lRecATCCPUserGroup."E-Mail" <> '' then begin
                                                    MailManagement.CheckValidEmailAddresses(lRecATCCPUserGroup."E-Mail");
                                                    Send2CC := true;
                                                    CCMail.Add(lRecATCCPUserGroup."E-Mail");
                                                end;
                                            end;
                                        lRecATCCPMailRecipientsSetup."Recover Mail Address From"::GroupMail:
                                            if lRecATCCPDimensionUserRole.Type = lRecATCCPDimensionUserRole.Type::UserGroup then begin
                                                lRecATCCPUserGroup.Get(lRecATCCPDimensionUserRole."User Id");
                                                if lRecATCCPUserGroup."E-Mail" <> '' then begin
                                                    MailManagement.CheckValidEmailAddresses(lRecATCCPUserGroup."E-Mail");
                                                    Send2CC := true;
                                                    CCMail.Add(lRecATCCPUserGroup."E-Mail");
                                                end;
                                            end
                                            else
                                                if (lRecATCCPDimensionUserRole.Type = lRecATCCPDimensionUserRole.Type::User) then begin
                                                    userSetup.Get(lRecATCCPDimensionUserRole."User Id");
                                                    if (userSetup."ATC_CP_User Group" <> '') and lRecATCCPUserGroup.Get(userSetup."ATC_CP_User Group") and (lRecATCCPUserGroup."E-Mail" <> '') then begin
                                                        MailManagement.CheckValidEmailAddresses(lRecATCCPUserGroup."E-Mail");
                                                        Send2CC := true;
                                                        CCMail.Add(lRecATCCPUserGroup."E-Mail");
                                                    end;
                                                end;
                                    end;
                                until lRecATCCPDimensionUserRole.Next() = 0;
                        end;
                    lRecATCCPMailRecipientsSetup.Role::Administration:
                        case lRecATCCPMailRecipientsSetup."Recover Mail Address From" of
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::UserSetup:
                                begin
                                    userSetup.Reset();
                                    userSetup.SetRange("ATC_CP_User Role", userSetup."ATC_CP_User Role"::Administration);
                                    userSetup.SetFilter("E-Mail", '<>%1', '');
                                    if userSetup.FindSet() then
                                        repeat
                                            if (userSetup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                                MailManagement.CheckValidEmailAddresses(userSetup."E-Mail");
                                                Send2CC := true;
                                                CCMail.Add(userSetup."E-Mail");
                                            end;
                                        until userSetup.Next() = 0;
                                end;
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::GenericMail:
                                begin
                                    lRecATCCPGeneralSetup.Get();
                                    lRecATCCPGeneralSetup.TestField("Administration E-Mail");
                                    MailManagement.CheckValidEmailAddresses(lRecATCCPGeneralSetup."Administration E-Mail");
                                    Send2CC := true;
                                    CCMail.Add(lRecATCCPGeneralSetup."Administration E-Mail");
                                end;
                        end;
                    lRecATCCPMailRecipientsSetup.Role::"Purchase Office":
                        case lRecATCCPMailRecipientsSetup."Recover Mail Address From" of
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::UserSetup:
                                begin
                                    userSetup.Reset();
                                    userSetup.SetRange("ATC_CP_User Role", userSetup."ATC_CP_User Role"::"Purchase Office");
                                    userSetup.SetFilter("E-Mail", '<>%1', '');
                                    if userSetup.FindSet() then
                                        repeat
                                            if (userSetup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                                MailManagement.CheckValidEmailAddresses(userSetup."E-Mail");
                                                Send2CC := true;
                                                CCMail.Add(userSetup."E-Mail");
                                            end;
                                        until userSetup.Next() = 0;
                                end;
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::GenericMail:
                                begin
                                    lRecATCCPGeneralSetup.Get();
                                    lRecATCCPGeneralSetup.TestField("Purchase Office E-Mail");
                                    MailManagement.CheckValidEmailAddresses(lRecATCCPGeneralSetup."Purchase Office E-Mail");
                                    Send2CC := true;
                                    CCMail.Add(lRecATCCPGeneralSetup."Purchase Office E-Mail");
                                end;
                        end;
                end;
            until lRecATCCPMailRecipientsSetup.Next() = 0;
    end;

    procedure FindCCN(pRecPurchaseHeader: Record "Purchase Header"; var CCNMail: List of [Text]; purchEvents: enum "ATC_CP_Purchase Events"; var Send2CCN: Boolean);
    var
        lRecATCCPMailRecipientsSetup: Record "ATC_CP_Mail Recipients Setup";
        userSetup: Record "User Setup";
        lRecATCCPUserGroup: Record "ATC_CP_User Group";
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
        // SmtpMail: Codeunit "SMTP Mail"; Old Code
        lRecATCCPDimensionUserRole: Record "ATC_CP_Dimension User Role";
        GeneralLedgerSetup: Record "General Ledger Setup";
        MailManagement: Codeunit "Mail Management";
    begin
        GeneralLedgerSetup.Get();
        lRecATCCPMailRecipientsSetup.Reset();
        lRecATCCPMailRecipientsSetup.setrange("Purchase Events", purchEvents);
        lRecATCCPMailRecipientsSetup.SetRange("Send Mail As", lRecATCCPMailRecipientsSetup."Send Mail As"::BCC);
        if lRecATCCPMailRecipientsSetup.FindSet() then
            repeat
                case lRecATCCPMailRecipientsSetup.Role of
                    lRecATCCPMailRecipientsSetup.Role::Requester:
                        case lRecATCCPMailRecipientsSetup."Recover Mail Address From" of
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::UserSetup:
                                begin
                                    pRecPurchaseHeader.TestField("ATC_CP_User Request");
                                    userSetup.Get(pRecPurchaseHeader."ATC_CP_User Request");
                                    if (userSetup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                        MailManagement.CheckValidEmailAddresses(userSetup."E-Mail");
                                        Send2CCN := true;
                                        CCNMail.Add(userSetup."E-Mail");
                                    end;
                                end;
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::GroupMail:
                                begin
                                    pRecPurchaseHeader.TestField("ATC_CP_User Request");
                                    userSetup.Get(pRecPurchaseHeader."ATC_CP_User Request");
                                    if (userSetup."ATC_CP_User Group" <> '') and lRecATCCPUserGroup.get(userSetup."ATC_CP_User Group") then
                                        if lRecATCCPUserGroup."E-Mail" <> '' then begin
                                            MailManagement.CheckValidEmailAddresses(lRecATCCPUserGroup."E-Mail");
                                            Send2CCN := true;
                                            CCNMail.Add(lRecATCCPUserGroup."E-Mail");
                                        end;
                                end;
                        end;
                    lRecATCCPMailRecipientsSetup.Role::"Division Owner":
                        begin
                            lRecATCCPDimensionUserRole.Reset();
                            if lRecATCCPGeneralSetup.isGlobalDim1() then begin
                                lRecATCCPDimensionUserRole.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 1 Code");
                                lRecATCCPDimensionUserRole.SetRange(Code, pRecPurchaseHeader."Shortcut Dimension 1 Code");
                            end else begin
                                lRecATCCPDimensionUserRole.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 2 Code");
                                lRecATCCPDimensionUserRole.SetRange(Code, pRecPurchaseHeader."Shortcut Dimension 2 Code");
                            end;

                            lRecATCCPDimensionUserRole.SetRange(Role, lRecATCCPDimensionUserRole.Role::"Division Owner");
                            if lRecATCCPDimensionUserRole.FindSet() then
                                repeat
                                    case lRecATCCPMailRecipientsSetup."Recover Mail Address From" of
                                        lRecATCCPMailRecipientsSetup."Recover Mail Address From"::UserSetup:
                                            if lRecATCCPDimensionUserRole.Type = lRecATCCPDimensionUserRole.Type::User then begin
                                                userSetup.Get(lRecATCCPDimensionUserRole."User Id");
                                                if (userSetup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                                    MailManagement.CheckValidEmailAddresses(userSetup."E-Mail");
                                                    Send2CCN := true;
                                                    CCNMail.Add(userSetup."E-Mail");
                                                end;
                                            end else begin
                                                lRecATCCPUserGroup.Get(lRecATCCPDimensionUserRole."User Id");
                                                if lRecATCCPUserGroup."E-Mail" <> '' then begin
                                                    MailManagement.CheckValidEmailAddresses(lRecATCCPUserGroup."E-Mail");
                                                    Send2CCN := true;
                                                    CCNMail.Add(lRecATCCPUserGroup."E-Mail");
                                                end;
                                            end;
                                        lRecATCCPMailRecipientsSetup."Recover Mail Address From"::GroupMail:
                                            if lRecATCCPDimensionUserRole.Type = lRecATCCPDimensionUserRole.Type::UserGroup then begin
                                                lRecATCCPUserGroup.Get(lRecATCCPDimensionUserRole."User Id");
                                                if lRecATCCPUserGroup."E-Mail" <> '' then begin
                                                    MailManagement.CheckValidEmailAddresses(lRecATCCPUserGroup."E-Mail");
                                                    Send2CCN := true;
                                                    CCNMail.Add(lRecATCCPUserGroup."E-Mail");
                                                end;
                                            end
                                            else
                                                if (lRecATCCPDimensionUserRole.Type = lRecATCCPDimensionUserRole.Type::User) then begin
                                                    userSetup.Get(lRecATCCPDimensionUserRole."User Id");
                                                    if (userSetup."ATC_CP_User Group" <> '') and lRecATCCPUserGroup.Get(userSetup."ATC_CP_User Group") and (lRecATCCPUserGroup."E-Mail" <> '') then begin
                                                        MailManagement.CheckValidEmailAddresses(lRecATCCPUserGroup."E-Mail");
                                                        Send2CCN := true;
                                                        CCNMail.Add(lRecATCCPUserGroup."E-Mail");
                                                    end;
                                                end;
                                    end;
                                until lRecATCCPDimensionUserRole.Next() = 0;
                        end;
                    lRecATCCPMailRecipientsSetup.Role::Administration:

                        case lRecATCCPMailRecipientsSetup."Recover Mail Address From" of
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::UserSetup:
                                begin
                                    userSetup.Reset();
                                    userSetup.SetRange("ATC_CP_User Role", userSetup."ATC_CP_User Role"::Administration);
                                    userSetup.SetFilter("E-Mail", '<>%1', '');
                                    if userSetup.FindSet() then
                                        repeat
                                            if (userSetup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                                MailManagement.CheckValidEmailAddresses(userSetup."E-Mail");
                                                Send2CCN := true;
                                                CCNMail.Add(userSetup."E-Mail");
                                            end;
                                        until userSetup.Next() = 0;
                                end;
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::GenericMail:
                                begin
                                    lRecATCCPGeneralSetup.Get();
                                    lRecATCCPGeneralSetup.TestField("Administration E-Mail");
                                    MailManagement.CheckValidEmailAddresses(lRecATCCPGeneralSetup."Administration E-Mail");
                                    Send2CCN := true;
                                    CCNMail.Add(lRecATCCPGeneralSetup."Administration E-Mail");
                                end;
                        end;
                    lRecATCCPMailRecipientsSetup.Role::"Purchase Office":
                        case lRecATCCPMailRecipientsSetup."Recover Mail Address From" of
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::UserSetup:
                                begin
                                    userSetup.Reset();
                                    userSetup.SetRange("ATC_CP_User Role", userSetup."ATC_CP_User Role"::"Purchase Office");
                                    userSetup.SetFilter("E-Mail", '<>%1', '');
                                    if userSetup.FindSet() then
                                        repeat
                                            if (userSetup."E-Mail" <> '') and not userSetup."ATC_CP_Disable Purch. Notif." then begin
                                                MailManagement.CheckValidEmailAddresses(userSetup."E-Mail");
                                                Send2CCN := true;
                                                CCNMail.Add(userSetup."E-Mail");
                                            end;
                                        until userSetup.Next() = 0;
                                end;
                            lRecATCCPMailRecipientsSetup."Recover Mail Address From"::GenericMail:
                                begin
                                    lRecATCCPGeneralSetup.Get();
                                    lRecATCCPGeneralSetup.TestField("Purchase Office E-Mail");
                                    MailManagement.CheckValidEmailAddresses(lRecATCCPGeneralSetup."Purchase Office E-Mail");
                                    Send2CCN := true;
                                    CCNMail.Add(lRecATCCPGeneralSetup."Purchase Office E-Mail");
                                end;
                        end;

                end;
            until lRecATCCPMailRecipientsSetup.Next() = 0;
    end;


    procedure InitHeaderDefaultsCustom(var varRecPurchaseLine: Record "Purchase Line")
    var
        lRecPurchaseHeader: Record "Purchase Header";
    begin
        lRecPurchaseHeader.Get(varRecPurchaseLine."Document Type", varRecPurchaseLine."Document No.");
        lRecPurchaseHeader.TESTFIELD("Buy-from Vendor No.");

        varRecPurchaseLine."Buy-from Vendor No." := lRecPurchaseHeader."Buy-from Vendor No.";
        varRecPurchaseLine."Currency Code" := lRecPurchaseHeader."Currency Code";
        varRecPurchaseLine."Expected Receipt Date" := lRecPurchaseHeader."Expected Receipt Date";
        varRecPurchaseLine."Shortcut Dimension 1 Code" := lRecPurchaseHeader."Shortcut Dimension 1 Code";
        varRecPurchaseLine."Shortcut Dimension 2 Code" := lRecPurchaseHeader."Shortcut Dimension 2 Code";
        IF NOT varRecPurchaseLine.IsNonInventoriableItem() THEN
            varRecPurchaseLine."Location Code" := lRecPurchaseHeader."Location Code";
        varRecPurchaseLine."Transaction Type" := lRecPurchaseHeader."Transaction Type";
        varRecPurchaseLine."Transport Method" := lRecPurchaseHeader."Transport Method";
        varRecPurchaseLine."Pay-to Vendor No." := lRecPurchaseHeader."Pay-to Vendor No.";
        varRecPurchaseLine."Gen. Bus. Posting Group" := lRecPurchaseHeader."Gen. Bus. Posting Group";
        varRecPurchaseLine."VAT Bus. Posting Group" := lRecPurchaseHeader."VAT Bus. Posting Group";
        varRecPurchaseLine."Entry Point" := lRecPurchaseHeader."Entry Point";
        //PurchLine."Refers to Period" := PurchHeader."Refers to Period";
        varRecPurchaseLine.Area := lRecPurchaseHeader.Area;
        varRecPurchaseLine."Transaction Specification" := lRecPurchaseHeader."Transaction Specification";
        varRecPurchaseLine."Tax Area Code" := lRecPurchaseHeader."Tax Area Code";
        varRecPurchaseLine."Tax Liable" := lRecPurchaseHeader."Tax Liable";
        varRecPurchaseLine."Prepayment Tax Area Code" := lRecPurchaseHeader."Tax Area Code";
        varRecPurchaseLine."Prepayment Tax Liable" := lRecPurchaseHeader."Tax Liable";
        varRecPurchaseLine."Responsibility Center" := lRecPurchaseHeader."Responsibility Center";
        varRecPurchaseLine."Requested Receipt Date" := lRecPurchaseHeader."Requested Receipt Date";
        varRecPurchaseLine."Promised Receipt Date" := lRecPurchaseHeader."Promised Receipt Date";
        varRecPurchaseLine."Inbound Whse. Handling Time" := lRecPurchaseHeader."Inbound Whse. Handling Time";
        varRecPurchaseLine."Order Date" := lRecPurchaseHeader."Order Date";
    end;


    procedure CheckOnApproval(var PurchaseHeader: Record "Purchase Header")
    var
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
        lRecATCCPExpenceType: Record "ATC_CP_Expence Type";
    begin
        if not lRecATCCPGeneralSetup.isActiveCheck() then
            exit;
        if not (PurchaseHeader."Document Type" in [PurchaseHeader."Document Type"::Quote, PurchaseHeader."Document Type"::Order]) then
            exit;

        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Quote then begin
            PurchaseHeader.TestField("Requested Receipt Date");
            lRecATCCPExpenceType.VerifyDimOnApproval(PurchaseHeader);
        end;
        lRecATCCPGeneralSetup.VerifyLocationOnApproval(PurchaseHeader);
        lRecATCCPGeneralSetup.VerifyNoOnApproval(PurchaseHeader);
        if lRecATCCPGeneralSetup."Line Amount Check" then
            lRecATCCPGeneralSetup.VerifyAmountOnApproval(PurchaseHeader);
        if (lRecATCCPGeneralSetup."Same Driver Check") then
            lRecATCCPGeneralSetup.VerifySameDim(PurchaseHeader);
    end;


    procedure CheckDimAss(Vendor: Code[20]; xVendor: Code[20]): Boolean
    var
        DefaultDimension: record "Default Dimension";
    begin
        DefaultDimension.Reset();
        DefaultDimension.Setrange("Table ID", 23);
        DefaultDimension.SetRange("No.", Vendor);
        DefaultDimension.SetFilter("Dimension Value Code", '<>%1', '');
        if (DefaultDimension.IsEmpty) then begin
            DefaultDimension.SetRange("No.", xVendor);
            exit(not DefaultDimension.IsEmpty);
        end else
            exit(true);

    end;


    [IntegrationEvent(false, false)]
    procedure OnBeforeCloseQtyNotInvoiced(var varRecPurchaseLine: Record "Purchase Line"; var pRecPurchRcptLine: Record "Purch. Rcpt. Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCloseOutstandingQty(var varRecPurchaseLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCloseQtyNotInvoiced(var varRecPurchaseLine: Record "Purchase Line"; var pRecPurchRcptLine: Record "Purch. Rcpt. Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCloseOutstandingQty(var varRecPurchaseLine: Record "Purchase Line")
    begin
    end;

    var
        cuCheckApp: Codeunit ATC_CAV_RunCheckApp; //ID_AppCheckControl_
}