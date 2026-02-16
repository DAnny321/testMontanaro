Codeunit 90201 "ATC_CP_PurchRequestEvents"
{

    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterInitRecord', '', false, false)]
    local procedure PR_OnAfterInitRecord(var PurchHeader: Record "Purchase Header")
    var
        PrSetup: Record "ATC_CP_General Setup";
    begin
        if not PrSetup.Get() or not PrSetup."Active Purchase Request" or (PurchHeader."Document Type" <> PurchHeader."Document Type"::Quote) then
            exit;
        if PrSetup."Default Expence Type" <> '' then
            PurchHeader.Validate("ATC_CP_Expense Type", PrSetup."Default Expence Type");
        if PrSetup."Default Vendor" <> '' then
            PurchHeader.Validate("Buy-from Vendor No.", PrSetup."Default Vendor");
        PurchHeader.validate("ATC_CP_User Request", UserId);
        PurchHeader.Validate("ATC_CP_Request Priority", PrSetup."Default Request Priority");
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterModifyEvent', '', false, false)]
    local procedure PR_OnAfterModifyEvent(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; RunTrigger: Boolean)
    var
        PrSetup: Record "ATC_CP_General Setup";
        userSetup: Record "User Setup";
    //ErrorModifyLbl: Label 'It is not possible proceed: modify allowed only for requester.', comment = 'ITA="Impossibile procedere: modifica permessa solo per utente richiedente %1"';
    begin
        if not PrSetup.Get() or not PrSetup."Active Purchase Request" or not RunTrigger then
            exit;

        userSetup.Get(UserId);

        Rec."ATC_CP_Glob. Dim. 1" := Rec."Shortcut Dimension 1 Code";
        Rec."ATC_CP_Glob. Dim. 2" := Rec."Shortcut Dimension 2 Code";
        Rec."ATC_CP_Last Modifier User" := CopyStr(UserId, 1, 50);
        Rec."ATC_CP_Last Modifier DateTime" := CreateDateTime(Today, Time);
        rec.Modify();
    end;




    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeInsertEvent', '', false, false)]
    local procedure PR_OnBeforeInsertEvent38(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    var
        PrSetup: Record "ATC_CP_General Setup";
    begin
        if Rec.IsTemporary then
            exit;
        Rec."ATC_CP_Creation Date" := Today;
        Rec."ATC_CP_Creation Time" := Time;

        if PrSetup.isActiveCheck() and (rec."Document Type" in [rec."Document Type"::Quote, rec."Document Type"::Order]) then begin
            rec."ATC_CP_Purchase Request" := true;
            if rec."ATC_CP_User Request" = '' then
                rec."ATC_CP_User Request" := CopyStr(UserId, 1, 50);
        end;

    end;


    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeInsertEvent', '', false, false)]
    local procedure PR_OnBeforeInsertEvent39(var Rec: Record "Purchase Line"; RunTrigger: Boolean)
    var
        PrSetup: Record "ATC_CP_General Setup";
        PurchHeader: Record "Purchase Header";
        locItem: Record Item;
        locGlAcc: Record "G/L Account";
    begin
        if not PrSetup.isActiveCheck() or (rec.IsTemporary) then
            exit;

        if (rec."Document Type" <> Rec."Document Type"::Quote) or (not rec."ATC_CP_Purchase Request") then
            exit;

        if Rec."No." = '' then
            exit;

        if Rec.Type = Rec.Type::"G/L Account" then begin
            locGlAcc.Get(Rec."No.");
            locGlAcc.TestField("ATC_CP_Enable Purchase Request");
            if Rec."ATC_CP_Expence Category" <> '' then
                Rec.TestField("ATC_CP_Expence Category", locGlAcc."ATC_CP_Expence Category");
            if Rec."ATC_CP_Expence SubCategory" <> '' then
                Rec.TestField("ATC_CP_Expence SubCategory", locGlAcc."ATC_CP_Expence SubCategory");
            if Rec."ATC_CP_Expence Details" <> '' then
                Rec.TestField("ATC_CP_Expence Details", locGlAcc."ATC_CP_Expence Details");
        end else
            if Rec.Type = Rec.Type::Item then begin
                locItem.Get(Rec."No.");
                locItem.TestField("ATC_CP_Enable Purchase Request");
                if Rec."ATC_CP_Expence Category" <> '' then
                    Rec.TestField("ATC_CP_Expence Category", locItem."ATC_CP_Expence Category");
                if Rec."ATC_CP_Expence SubCategory" <> '' then
                    Rec.TestField("ATC_CP_Expence SubCategory", locItem."ATC_CP_Expence SubCategory");
                if Rec."ATC_CP_Expence Details" <> '' then
                    Rec.TestField("ATC_CP_Expence Details", locItem."ATC_CP_Expence Details");
            end;

        PrSetup.get();
        if PrSetup."Active VDS Selection Hierarchy" and PrSetup."Mandatory Hierarchy" then begin
            if PrSetup.HierarchyVisibility(1) then
                Rec.TestField("ATC_CP_Expence Category");
            if PrSetup.HierarchyVisibility(2) then
                Rec.TestField("ATC_CP_Expence SubCategory");
            if PrSetup.HierarchyVisibility(3) then
                Rec.TestField("ATC_CP_Expence Details");
        end;

        if Rec."ATC_CP_1st Vendor Rating" <> Rec."ATC_CP_1st Vendor Rating"::" " then
            Rec."ATC_CP_1st Vendor Rating" := PurchHeader."ATC_CP_1st Vendor Rating";
        if Rec."ATC_CP_2nd Vendor Rating" <> Rec."ATC_CP_2nd Vendor Rating"::" " then
            Rec."ATC_CP_2nd Vendor Rating" := PurchHeader."ATC_CP_2nd Vendor Rating";
        if Rec."ATC_CP_3rd Vendor Rating" <> Rec."ATC_CP_3rd Vendor Rating"::" " then
            Rec."ATC_CP_3rd Vendor Rating" := PurchHeader."ATC_CP_3rd Vendor Rating";
    end;


    [EventSubscriber(ObjectType::Table, 39, 'OnAfterInsertEvent', '', false, false)]
    local procedure PR_OnAfterInsertEvent39(var Rec: Record "Purchase Line"; RunTrigger: Boolean)
    var
        PrSetup: Record "ATC_CP_General Setup";
        PurchHeader: Record "Purchase Header";
    //locItem: Record Item;
    //locGlAcc: Record "G/L Account";
    begin
        if not RunTrigger then
            exit;

        if not PrSetup.isActiveCheck() or rec.IsTemporary then
            exit;

        if (rec."Document Type" <> Rec."Document Type"::Quote) or (not rec."ATC_CP_Purchase Request") then
            exit;

        if Rec."No." = '' then
            exit;

        PurchHeader.Get(rec."Document Type", rec."Document No.");
        if PrSetup.isGlobalDim1() then
            PurchHeader.TestField("Shortcut Dimension 1 Code")
        else
            PurchHeader.TestField("Shortcut Dimension 2 Code");
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterTestNoSeries', '', false, false)]
    local procedure PR_OnAfterTestNoSeries(var PurchHeader: Record "Purchase Header")
    var
        PrSetup: Record "ATC_CP_General Setup";
    begin

        if (PurchHeader."Document Type" <> PurchHeader."Document Type"::Quote) or (not PurchHeader."ATC_CP_Purchase Request") then
            exit;

        PrSetup.isActiveError();

        if PurchHeader."ATC_CP_Request Template" then
            PrSetup.testfield("Template Request Nos.")
        else
            PrSetup.TestField("Request Nos.");

    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterGetNoSeriesCode', '', false, false)]
    local procedure PR_OnAfterGetNoSeriesCode(var PurchHeader: Record "Purchase Header"; PurchSetup: Record "Purchases & Payables Setup"; var NoSeriesCode: Code[20])
    var
        PrSetup: Record "ATC_CP_General Setup";
    begin

        if (PurchHeader."Document Type" <> PurchHeader."Document Type"::Quote) or (not PurchHeader."ATC_CP_Purchase Request") then
            exit;
        if not PrSetup.isActiveCheck() then
            exit;
        //PrSetup.isActiveError();

        if PurchHeader."ATC_CP_Request Template" then
            NoSeriesCode := PrSetup."Template Request Nos."
        else
            NoSeriesCode := PrSetup."Request Nos.";
    end;

    [EventSubscriber(ObjectType::Page, 9306, 'OnOpenPageEvent', '', false, false)]
    local procedure PR9306_OnOpenPageEvent(var Rec: Record "Purchase Header")
    begin
        CuPuchaseMngt.VerifyPermissionPurchPage(9306);
        rec.ATC_CP_setPurchaseRequestFilter();
    end;

    //filtro per gli ordini di acquisto 
    [EventSubscriber(ObjectType::Page, 9307, 'OnOpenPageEvent', '', false, false)]
    local procedure PR9307_OnOpenPageEvent(var Rec: Record "Purchase Header")
    begin
        CuPuchaseMngt.VerifyPermissionPurchPage(9307);
        rec.ATC_CP_setPurchaseRequestFilter();
    end;

    [EventSubscriber(ObjectType::Page, 9308, 'OnOpenPageEvent', '', false, false)]
    local procedure PR9308_OnOpenPageEvent(var Rec: Record "Purchase Header")
    begin
        CuPuchaseMngt.VerifyPermissionPurchPage(9308);
    end;

    [EventSubscriber(ObjectType::Page, 9309, 'OnOpenPageEvent', '', false, false)]
    local procedure PR9309_OnOpenPageEvent(var Rec: Record "Purchase Header")
    begin
        CuPuchaseMngt.VerifyPermissionPurchPage(9309);
    end;

    [EventSubscriber(ObjectType::Page, 9310, 'OnOpenPageEvent', '', false, false)]
    local procedure PR9310_OnOpenPageEvent(var Rec: Record "Purchase Header")
    begin
        CuPuchaseMngt.VerifyPermissionPurchPage(9310);

    end;

    [EventSubscriber(ObjectType::Page, 9311, 'OnOpenPageEvent', '', false, false)]
    local procedure PR9311_OnOpenPageEvent(var Rec: Record "Purchase Header")
    begin
        CuPuchaseMngt.VerifyPermissionPurchPage(9311);
    end;



    //filtro gli archivi di vendita
    [EventSubscriber(ObjectType::Page, 9346, 'OnOpenPageEvent', '', false, false)]
    local procedure PR9346_OnOpenPageEvent(var Rec: Record "Purchase Header Archive")
    begin
        rec.ATC_CP_setPurchaseRequestFilter();
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnRecreatePurchLinesOnBeforeInsertPurchLine', '', false, false)]
    local procedure OnRecreatePurchLinesOnBeforeInsertPurchLine(var PurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line")
    var
        prSetup: Record "ATC_CP_General Setup";
    begin
        if not prSetup.isActiveCheck() then
            exit;
        PurchaseLine."ATC_CP_Expence Category" := TempPurchaseLine."ATC_CP_Expence Category";
        PurchaseLine."ATC_CP_Expence SubCategory" := TempPurchaseLine."ATC_CP_Expence SubCategory";
        PurchaseLine."ATC_CP_Expence Details" := TempPurchaseLine."ATC_CP_Expence Details";
    end;




    [EventSubscriber(ObjectType::Table, 39, 'OnValidateNoOnCopyFromTempPurchLine', '', false, false)]
    local procedure PR_OnValidateNoOnCopyFromTempPurchLine(var PurchLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line")
    begin
        PurchLine."ATC_CP_Purchase Request" := TempPurchaseLine."ATC_CP_Purchase Request";
        PurchLine."ATC_CP_Expence Category" := TempPurchaseLine."ATC_CP_Expence Category";
        PurchLine."ATC_CP_Expence SubCategory" := TempPurchaseLine."ATC_CP_Expence SubCategory";
        PurchLine."ATC_CP_Expence Details" := TempPurchaseLine."ATC_CP_Expence Details";
        PurchLine."ATC_CP_Request Additional Info" := TempPurchaseLine."ATC_CP_Request Additional Info";
        CuPuchaseMngt.UpdatePurchaseRequestLine(PurchLine);
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure PR_OnAfterValidateEventNo39(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        PR_OnBeforeInsertEvent39(Rec, true);
        CuPuchaseMngt.UpdatePurchaseRequestLine(Rec);

    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure PR_OnAfterValidateEventQty39(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        CuPuchaseMngt.UpdatePurchaseRequestLine(Rec);
    end;

    /*
    [EventSubscriber(ObjectType::Page, 118, 'OnBeforeActionEvent', 'ChangeGlobalDimensions', false, false)]
    procedure P118_OnBeforeActionEvent(var Rec: Record "General Ledger Setup")
    var
        PrSetup: Record "ATC_CP_General Setup";
        MessDim: Label 'Attention, if you change the global dimension of the purchase requests the setup must be recreated', 
            comment = 'ITA="Attenzione, se si cambia la dimensione globale delle richieste di acquisto deve essere ricreato il setup."';
    begin
        if PrSetup.get then begin
            if PrSetup."Active Purchase Request" and (PrSetup."Driver Dimension Code" <> '') then
                Message(MessDim);
        end;
    end;
    */

    [EventSubscriber(ObjectType::Page, 577, 'OnOpenPageEvent', '', false, false)]
    local procedure P577_OnOpenPageEvent(var Rec: Record "Change Global Dim. Header")
    var
        PrSetup: Record "ATC_CP_General Setup";
        MessDimLbl: Label 'Attention, if you change the global dimension of the purchase requests the setup must be recreated',
            comment = 'ITA="Attenzione, se si cambia la dimensione globale delle richieste di acquisto deve essere ricreato il setup."';
    begin
        if PrSetup.get() then
            if PrSetup."Active Purchase Request" and (PrSetup."Driver Dimension Code" <> '') then
                Message(MessDimLbl);
    end;


    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure UpdatePurchLine(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]);
    var
        PurchaseLine: Record "Purchase Line";
        prSetup: Record "ATC_CP_General Setup";
    begin

        if not prSetup.get() or not prSetup."Active Purchase Request" or not prSetup."Enable Vendor Rating" or (PurchaseHeader."Document Type" in [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo"]) then
            exit;

        PurchaseLine.RESET();
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchaseLine.MODIFYALL(PurchaseLine."ATC_CP_1st Vendor Rating", 0);
        PurchaseLine.MODIFYALL(PurchaseLine."ATC_CP_2nd Vendor Rating", 0);
        PurchaseLine.MODIFYALL(PurchaseLine."ATC_CP_3rd Vendor Rating", 0);
        PurchaseHeader."ATC_CP_1st Vendor Rating" := PurchaseHeader."ATC_CP_1st Vendor Rating"::" ";
        PurchaseHeader."ATC_CP_2nd Vendor Rating" := PurchaseHeader."ATC_CP_2nd Vendor Rating"::" ";
        PurchaseHeader."ATC_CP_3rd Vendor Rating" := PurchaseHeader."ATC_CP_3rd Vendor Rating"::" ";
        if PurchaseHeader.Modify() then;
    end;

    [EventSubscriber(ObjectType::Table, 7317, 'OnBeforeValidateEvent', 'ATC_CP_1st Vendor Rating', false, false)]
    local procedure Rating1OnWhseReceipt(var Rec: Record "Warehouse Receipt Line"; var xRec: Record "Warehouse Receipt Line"; CurrFieldNo: Integer);
    var
        gblRecPurchaseLine: Record "Purchase Line";
    //ErrorText1: Label 'Use the field Q.ty To Receive with Tolerance for items with tollerance"';//, comment = 'ITA="Usare il campo Qtà da ricevere con tolleranza per gestire le tolleranze"';
    begin

        if not ((Rec."Source Type" = 39) and (Rec."Source Subtype" = Rec."Source Subtype"::"1")) then
            exit;
        if not gRecATCCPGeneralSetup.isActiveCheck() then
            exit;

        gblRecPurchaseLine.GET(gblRecPurchaseLine."Document Type"::Order, Rec."Source No.", Rec."Source Line No.");
        gblRecPurchaseLine."ATC_CP_1st Vendor Rating" := Rec."ATC_CP_1st Vendor Rating";
        gblRecPurchaseLine.Modify();
    end;

    [EventSubscriber(ObjectType::Table, 7317, 'OnBeforeValidateEvent', 'ATC_CP_2nd Vendor Rating', false, false)]
    local procedure Rating2OnWhseReceipt(var Rec: Record "Warehouse Receipt Line"; var xRec: Record "Warehouse Receipt Line"; CurrFieldNo: Integer);
    var
        gblRecPurchaseLine: Record "Purchase Line";
    //ErrorText1: Label 'Use the field Q.ty To Receive with Tolerance for items with tollerance"';//, comment = 'ITA="Usare il campo Qtà da ricevere con tolleranza per gestire le tolleranze"';
    begin
        if not ((Rec."Source Type" = 39) and (Rec."Source Subtype" = Rec."Source Subtype"::"1")) then
            exit;
        if not gRecATCCPGeneralSetup.isActiveCheck() then
            exit;

        gblRecPurchaseLine.GET(gblRecPurchaseLine."Document Type"::Order, Rec."Source No.", Rec."Source Line No.");
        gblRecPurchaseLine."ATC_CP_2nd Vendor Rating" := Rec."ATC_CP_2nd Vendor Rating";
        gblRecPurchaseLine.Modify();
    end;

    [EventSubscriber(ObjectType::Table, 7317, 'OnBeforeValidateEvent', 'ATC_CP_3rd Vendor Rating', false, false)]
    local procedure Rating3OnWhseReceipt(var Rec: Record "Warehouse Receipt Line"; var xRec: Record "Warehouse Receipt Line"; CurrFieldNo: Integer);
    var
        gblRecPurchaseLine: Record "Purchase Line";
    //ErrorText1: Label 'Use the field Q.ty To Receive with Tolerance for items with tollerance"';//, comment = 'ITA="Usare il campo Qtà da ricevere con tolleranza per gestire le tolleranze"';
    begin
        if not ((Rec."Source Type" = 39) and (Rec."Source Subtype" = Rec."Source Subtype"::"1")) then
            exit;
        if not gRecATCCPGeneralSetup.isActiveCheck() then
            exit;

        gblRecPurchaseLine.GET(gblRecPurchaseLine."Document Type"::Order, Rec."Source No.", Rec."Source Line No.");
        gblRecPurchaseLine."ATC_CP_3rd Vendor Rating" := Rec."ATC_CP_3rd Vendor Rating";
        gblRecPurchaseLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean)
    var
        prSetup: Record "ATC_CP_General Setup";
        purchLine: Record "Purchase Line";
    begin
        prSetup.Get();
        if not prSetup."Active Purchase Request" then
            exit;
        if (not prSetup."Enable Vendor Rating") or (not prSetup."Mandatory Rating") then
            exit;
        if (PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order) or not PurchaseHeader.Receive then
            exit;

        purchLine.Reset();
        purchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        purchLine.SetRange("Document No.", PurchaseHeader."No.");
        purchLine.SetFilter("Qty. to Receive", '<>%1', 0);
        if purchLine.FindSet() then
            repeat
                CuPuchaseMngt.CheckLineRating(purchLine);
            until purchLine.Next() = 0;
    end;




    [EventSubscriber(ObjectType::Table, 121, 'OnBeforeInsertInvLineFromRcptLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromRcptLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchLine: Record "Purchase Line"; PurchOrderLine: Record "Purchase Line")
    begin
        PurchLine."ATC_CP_Purchase Request" := PurchOrderLine."ATC_CP_Purchase Request";
        PurchLine."ATC_CP_1st Vendor Rating" := PurchRcptLine."ATC_CP_1st Vendor Rating";
        PurchLine."ATC_CP_2nd Vendor Rating" := PurchRcptLine."ATC_CP_2nd Vendor Rating";
        PurchLine."ATC_CP_3rd Vendor Rating" := PurchRcptLine."ATC_CP_3rd Vendor Rating";
    end;

    [EventSubscriber(ObjectType::Codeunit, 96, 'OnBeforeRun', '', false, false)]
    local procedure cu96OnBeforeRun(var PurchaseHeader: Record "Purchase Header")
    var
        prSetup: Record "ATC_CP_General Setup";
        userSetup: Record "User Setup";
        prUserGroup: Record "ATC_CP_User Group";
        MessErr: Label 'User not enabled to create orders', comment = 'ITA="Utente non abilitato alla creazione degli ordini"';
    begin

        if prSetup.get() and prSetup."Active Purchase Request" then begin
            if (PurchaseHeader."Buy-from Vendor No." = prSetup."Default Vendor") then
                PurchaseHeader.TestField("ATC_CP_Create Order Vendor No.");

            userSetup.Get(UserId);
            if userSetup."ATC_CP_User Role" = userSetup."ATC_CP_User Role"::"Purchase Office" then
                exit;
            if (userSetup."ATC_CP_User Group" <> '') and prUserGroup.Get(userSetup."ATC_CP_User Group") then
                if prUserGroup."ATC_CP_User Role" = prUserGroup."ATC_CP_User Role"::"Purchase Office" then
                    exit;

            Error(MessErr);
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, 96, 'OnBeforeDeletePurchQuote', '', false, false)]
    local procedure OnBeforeDeletePurchQuote(var QuotePurchHeader: Record "Purchase Header"; var OrderPurchHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        OrderLine: Record "Purchase Line";
        RequestLine: Record "Purchase Line";
        prSetup: Record "ATC_CP_General Setup";
        MovedAttach: Boolean;
        recVendor: Record Vendor;
        VendorNo: Code[20];
        SkipReplaceDim: Boolean;
        ErrorConfirm: Label 'Operation Canceled', comment = 'ITA="Operazione annullata"';
        LabelDimAssociated: Label 'There are dimensions associated with the selected providers. Press Yes to continue maintaining quote dimensions  or press No to cancel.',
            Comment = 'ITA="Sono presenti delle dimensioni associate ai fornitori selezionati. Premere Sì per continuare mantenendo le dimensioni presenti in offerta o premere No per annullare."';
    //cuPurchRequestMngt: Codeunit ATC_CP_PurchRequestMngt;
    begin
        if not QuotePurchHeader."ATC_CP_Purchase Request" then
            exit;
        prSetup.Get();
        if not prSetup."Active Purchase Request" then
            exit;

        VendorNo := OrderPurchHeader."ATC_CP_Create Order Vendor No.";
        Clear(SkipReplaceDim);


        if (OrderPurchHeader."ATC_CP_Create Order Vendor No." = '') or (OrderPurchHeader."Buy-from Vendor No." = VendorNo) then
            exit;

        recVendor.get(OrderPurchHeader."ATC_CP_Create Order Vendor No.");
        if (recVendor."Pay-to Vendor No." <> '') then
            VendorNo := recVendor."Pay-to Vendor No.";

        if not prSetup."Skip Alert Vendor Ass. Dim." and CuPuchaseMngt.CheckDimAss(OrderPurchHeader."Pay-to Vendor No.", VendorNo) then
            if not Confirm(LabelDimAssociated) then
                Error(ErrorConfirm);



        MovedAttach := CuPuchaseMngt.verifyMoveAttach(QuotePurchHeader);

        OrderPurchHeader.SetHideValidationDialog(true);
        OnBeforeChangeVendorForSkipBudget(QuotePurchHeader, OrderPurchHeader, SkipReplaceDim);
        OrderPurchHeader.Validate("Buy-from Vendor No.", QuotePurchHeader."ATC_CP_Create Order Vendor No.");
        OrderPurchHeader.Validate("Shortcut Dimension 1 Code", QuotePurchHeader."Shortcut Dimension 1 Code");
        OrderPurchHeader.Validate("Shortcut Dimension 2 Code", QuotePurchHeader."Shortcut Dimension 2 Code");
        OrderPurchHeader.validate("Requested Receipt Date", QuotePurchHeader."Requested Receipt Date");
        OrderPurchHeader.Validate("Location Code", QuotePurchHeader."Location Code");
        OrderPurchHeader.Modify(true);
        OrderLine.Reset();
        OrderLine.SetRange("Document Type", OrderPurchHeader."Document Type");
        OrderLine.SetRange("Document No.", OrderPurchHeader."No.");
        if OrderLine.FindSet() then
            repeat
                RequestLine.Get(RequestLine."Document Type"::Quote, QuotePurchHeader."No.", OrderLine."Line No.");
                CuPuchaseMngt.InitHeaderDefaultsCustom(OrderLine);
                OrderLine.Validate("No.");
                OrderLine.Validate("Location Code", RequestLine."Location Code");
                OrderLine.Validate(Quantity, RequestLine.Quantity);
                OrderLine.Validate("Direct Unit Cost", RequestLine."Direct Unit Cost");
                OrderLine.Validate("Line Discount %", RequestLine."Line Discount %");
                if (RequestLine."Dimension Set ID" <> 0) and not SkipReplaceDim then begin
                    OrderLine.Validate("Shortcut Dimension 1 Code", RequestLine."Shortcut Dimension 1 Code");
                    OrderLine.Validate("Shortcut Dimension 2 Code", RequestLine."Shortcut Dimension 2 Code");
                    OrderLine.Validate("Dimension Set ID", RequestLine."Dimension Set ID");
                    OnAfterRestoreDimensionID(OrderLine, RequestLine);
                end;
                OrderLine.Validate("ATC_CP_Expence Category", RequestLine."ATC_CP_Expence Category");
                OrderLine.Validate("ATC_CP_Expence SubCategory", RequestLine."ATC_CP_Expence SubCategory");
                OrderLine.Validate("ATC_CP_Expence Details", RequestLine."ATC_CP_Expence Details");
                OrderLine.Validate("ATC_CP_Purchase Request", RequestLine."ATC_CP_Purchase Request");
                OrderLine.Validate("ATC_CP_Request Additional Info", RequestLine."ATC_CP_Request Additional Info");
                OrderLine.modify(true);
            until OrderLine.Next() = 0;

        if MovedAttach then
            CuPuchaseMngt.ReplaceAttach(OrderPurchHeader);
    end;







    [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
    local procedure PR_OnAfterValidateEventBuyVendorNo(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        prSetup: Record "ATC_CP_General Setup";
    begin
        if not prSetup.isActiveCheck() then
            exit;
        if not Rec."ATC_CP_Purchase Request" or (Rec."Document Type" <> Rec."Document Type"::Quote) then
            exit;

        if (Rec."Buy-from Vendor No." <> xRec."Buy-from Vendor No.") and (xRec."Buy-from Vendor No." <> '') then begin
            if prSetup.isGlobalDim1() then
                if (Rec."Shortcut Dimension 1 Code" <> xRec."Shortcut Dimension 1 Code") and (xRec."Shortcut Dimension 1 Code" <> '') then
                    Rec.Validate("Shortcut Dimension 1 Code", xRec."Shortcut Dimension 1 Code");
        end else
            if (Rec."Shortcut Dimension 2 Code" <> xRec."Shortcut Dimension 2 Code") and (xRec."Shortcut Dimension 2 Code" <> '') then
                Rec.Validate("Shortcut Dimension 2 Code", xRec."Shortcut Dimension 2 Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, 415, 'OnAfterReleasePurchaseDoc', '', false, false)]
    local procedure OnAfterReleasePurchaseDocCu415(var PurchaseHeader: Record "Purchase Header"; var LinesWereModified: Boolean; PreviewMode: Boolean)
    var
        prSetup: Record "ATC_CP_General Setup";
        NotificationSetup: Record "ATC_CP_Email Notific. Setup";
    begin
        if not prSetup.isActiveCheck() then
            exit;
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Quote:
                CuPuchaseMngt.SendPurchMail(PurchaseHeader, NotificationSetup."Purchase Events"::RequestRelease);
            PurchaseHeader."Document Type"::Order:
                CuPuchaseMngt.SendPurchMail(PurchaseHeader, NotificationSetup."Purchase Events"::ReleaseOrder);
            else
                exit;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 96, 'OnAfterRun', '', false, false)]
    local procedure OnAfterRunCu415(var PurchaseHeader: Record "Purchase Header"; PurchOrderHeader: Record "Purchase Header")
    var
        prSetup: Record "ATC_CP_General Setup";
        NotificationSetup: Record "ATC_CP_Email Notific. Setup";
    begin

        if not prSetup.isActiveCheck() then
            exit;

        CuPuchaseMngt.SendPurchMail(PurchOrderHeader, NotificationSetup."Purchase Events"::OrderCreation);
    end;

    [EventSubscriber(ObjectType::Page, 9307, 'OnAfterActionEvent', 'ATC_CP_RequestPurchPost', false, false)]
    local procedure OnAfterActionEvent9307(var Rec: Record "Purchase Header")
    var
        prSetup: Record "ATC_CP_General Setup";
        NotificationSetup: Record "ATC_CP_Email Notific. Setup";
    begin

        if not prSetup.isActiveCheck() then
            exit;

        Rec.CalcFields("Completely Received");
        Rec.testfield("Completely Received", false);
        CuPuchaseMngt.SendPurchMail(Rec, NotificationSetup."Purchase Events"::RequestReceiptPost);
    end;

    [EventSubscriber(ObjectType::Page, 50, 'OnAfterActionEvent', 'ATC_CP_RequestPurchPost', false, false)]
    local procedure OnAfterActionEvent50(var Rec: Record "Purchase Header")
    var
        prSetup: Record "ATC_CP_General Setup";
        NotificationSetup: Record "ATC_CP_Email Notific. Setup";
    begin

        if not prSetup.isActiveCheck() then
            exit;

        Rec.CalcFields("Completely Received");
        Rec.testfield("Completely Received", false);
        CuPuchaseMngt.SendPurchMail(Rec, NotificationSetup."Purchase Events"::RequestReceiptPost);
    end;



    [EventSubscriber(ObjectType::Table, 90211, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEvent90211(var Rec: Record "ATC_CP_Selection Field Mail"; var xRec: Record "ATC_CP_Selection Field Mail"; RunTrigger: Boolean)
    var
        FieldMail: Record "ATC_CP_Selection Field Mail";
        link: code[3];
        ErrorCount_Err: Label 'You have exceeded the maximum number of selectable fields. Choose a maximum of 10 fields.', comment = 'ITA="Avete superato il numero massimo di campi selezionabili. Scegliere al massimo 10 campi."';
    begin
        if rec.Active = xRec.Active then
            exit;
        if not RunTrigger then
            exit;

        link := '%0';
        FieldMail.Reset();
        FieldMail.SetRange("Purchase Events", Rec."Purchase Events");
        FieldMail.SetRange("Table No.", Rec."Table No.");
        //FieldMail.SetFilter("Field No.", '<>%1', Rec."Field No.");
        FieldMail.ModifyAll("Use as Link String", '');
        FieldMail.SetRange(Active, true);
        if FieldMail.Count > 10 then
            Error(ErrorCount_Err)
        else begin
            FieldMail.Reset();
            FieldMail.SetRange("Purchase Events", Rec."Purchase Events");
            FieldMail.SetRange("Table No.", Rec."Table No.");
            FieldMail.SetRange(Active, true);
            if FieldMail.FindSet() then
                repeat
                    link := IncStr(link);
                    FieldMail."Use as Link String" := link;
                    FieldMail.Modify();
                until FieldMail.Next() = 0;
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]

    local procedure RequesterPost(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean; var HideDialog: Boolean; var DefaultOption: Integer);
    var
        prSetup: Record "ATC_CP_General Setup";
        userSetup: Record "User Setup";
        ErrorConfirmLbl: Label 'Operation Canceled', comment = 'ITA="Operazione annullata"';
        MessConfirmLbl: Label 'Do you want post receipt?', comment = 'ITA="Procedere con la registazione del carico?"';
    begin

        if not prSetup.Get() or not prSetup."Active Purchase Request" then
            exit;

        if (PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order) then
            exit;

        if not GuiAllowed and prSetup."Aut. Purch. Rcpt. Batch. Post" then begin
            if PurchaseHeader.ATC_CP_PostRecepitStatus = PurchaseHeader.ATC_CP_PostRecepitStatus::Processable then begin
                HideDialog := true;
                PurchaseHeader.Receive := true;

            end;
        end else begin
            userSetup.Get(UserId);
            //if (PurchaseHeader."ATC_CP_User Request"<> UserId) or (userSetup."ATC_CP_User Role" <> userSetup."ATC_CP_User Role"::" ") then
            if (userSetup."ATC_CP_User Role" <> userSetup."ATC_CP_User Role"::" ") then
                exit;
            if not Confirm(MessConfirmLbl) then
                Error(ErrorConfirmLbl);
            HideDialog := true;
            PurchaseHeader.Receive := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Shortcut Dimension 1 Code', false, false)]
    local procedure OnAfterValidateEvent38Dim1(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    begin
        Rec.ATC_CP_OnValidateGlobDim(true);
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Shortcut Dimension 2 Code', false, false)]
    local procedure OnAfterValidateEvent38Dim2(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    begin
        Rec.ATC_CP_OnValidateGlobDim(false);
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterGetPurchHeader', '', false, false)]
    local procedure OnAfterGetPurchHeader(var PurchaseHeader: Record "Purchase Header")
    var
        prSetup: Record "ATC_CP_General Setup";
    begin
        if not prSetup.isActiveCheck() or (PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Quote) then
            exit;
        if (PurchaseHeader."ATC_CP_Purchase Request") and ((PurchaseHeader."Buy-from Vendor No." = '') or (PurchaseHeader."Buy-from Vendor No." = prSetup."Default Vendor")) then
            PurchaseHeader.get(PurchaseHeader."Document Type", PurchaseHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, 5760, 'OnAfterRun', '', false, false)]
    local procedure OnAfterRun(var WarehouseReceiptLine: Record "Warehouse Receipt Line")
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        WhseRcptHdr: Record "Warehouse Receipt Header";
        prSetup: Record "ATC_CP_General Setup";
    begin
        if not prSetup.isActiveCheck() then
            exit;

        //WITH WhseRcptLine DO BEGIN
        WhseRcptLine.SETCURRENTKEY("No.");
        WhseRcptLine.SETRANGE("No.", WarehouseReceiptLine."No.");
        WhseRcptLine.ModifyAll("ATC_CP_1st Vendor Rating", WhseRcptLine."ATC_CP_1st Vendor Rating"::" ");
        WhseRcptLine.ModifyAll("ATC_CP_2nd Vendor Rating", WhseRcptLine."ATC_CP_2nd Vendor Rating"::" ");
        WhseRcptLine.ModifyAll("ATC_CP_3rd Vendor Rating", WhseRcptLine."ATC_CP_3rd Vendor Rating"::" ");
        //end;

        if WhseRcptHdr.Get(WarehouseReceiptLine."No.") then begin
            WhseRcptHdr."ATC_CP_1st Vendor Rating" := WhseRcptHdr."ATC_CP_1st Vendor Rating"::" ";
            WhseRcptHdr."ATC_CP_2nd Vendor Rating" := WhseRcptHdr."ATC_CP_2nd Vendor Rating"::" ";
            WhseRcptHdr."ATC_CP_3rd Vendor Rating" := WhseRcptHdr."ATC_CP_3rd Vendor Rating"::" ";
            WhseRcptHdr.Modify();
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, 97, 'OnBeforeRun', '', false, false)]
    local procedure CheckPurchaseReleaseRestrictionsBlanketOrder(var PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader.CheckPurchaseReleaseRestrictions();
    end;

    [EventSubscriber(ObjectType::Codeunit, 700, 'OnAfterGetPageID', '', false, true)]
    local procedure OnAfterGetPageId(RecordRef: RecordRef; var PageID: Integer)
    var
        prSetup: Record "ATC_CP_General Setup";
        purchTable: Record "Purchase Header";
        userSetup: Record "User Setup";
    begin
        if not prSetup.isActiveCheck() then
            exit;
        if not purchTable.get(RecordRef.RecordId) or not (purchTable."Document Type" in [purchTable."Document Type"::Quote, purchTable."Document Type"::Order]) then
            exit;
        if not userSetup.Get(UserId) or (userSetup."ATC_CP_User Role" <> userSetup."ATC_CP_User Role"::" ") then
            exit;

        case purchTable."Document Type" of
            purchTable."Document Type"::Quote:
                PageID := page::"ATC_CP_Purchase Request";
            purchTable."Document Type"::Order:
                PageID := page::"ATC_CP_Purchase Order";
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckPurchaseApprovalPossible', '', false, false)]
    local procedure OnAfterCheckPurchaseApprovalPossible(var PurchaseHeader: Record "Purchase Header")
    begin
        CuPuchaseMngt.CheckOnApproval(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', false, false)]
    local procedure OnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    begin
        CuPuchaseMngt.CheckOnApproval(PurchaseHeader);
    end;






    //TODO sviluppo di Fabio De Angelis per il registra carico?
    //TODO ordini  programmati di Bartolini
    //TODO gestione cespiti Bartolini
    //TODO gestire creazione ordini programmati
    //TODO mergiare i template ora che sono differenti
    //TODO colori per movimenti di approvazione presenti. c        apire logiche da applicare come per le pile
    //TODO creazione automatica[EventSubscriber(ObjectType::Page, page::"Approval Entries", 'OnOpenPageEvent', '', false, false)]


    [IntegrationEvent(false, false)]
    procedure OnBeforeChangeVendorForSkipBudget(var QuoteHeader: Record "Purchase Header"; var OrderHeader: Record "Purchase Header"; var SkipReplaceDim: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRestoreDimensionID(var OrderLine: Record "Purchase Line"; RequestLine: record "Purchase Line")
    begin
    end;

    [EventSubscriber(ObjectType::Table, 454, 'OnBeforeMarkAllWhereUserisApproverOrSender', '', false, false)]
    local procedure OnBeforeMarkAllWhereUserisApproverOrSender(var ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean)
    var
    //UserSetup: record "User Setup";
    begin
        if not gRecATCCPGeneralSetup.isActiveCheck() then
            exit;
        IsHandled := true;

    end;

    var
        gRecATCCPGeneralSetup: record "ATC_CP_General Setup";
        CuPuchaseMngt: Codeunit ATC_CP_PurchRequestMngt;
}