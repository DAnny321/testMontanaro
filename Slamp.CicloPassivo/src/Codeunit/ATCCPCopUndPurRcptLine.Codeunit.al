/*
codeunit 90202 "ATC_CP_CopUndPurRcptLine"
{
    TableNo = "Purch. Rcpt. Line";
    Permissions = TableData "Purchase Line" = imd, TableData "Purch. Rcpt. Line" = imd, TableData "Item Entry Relation" = ri, TableData "Whse. Item Entry Relation" = rimd;
    trigger OnRun()
    begin
        //SetFilter(Type, '%1|%2', Type::"G/L Account", Type::Item);
        SetRange(Type, Type::"G/L Account");
        if not Find('-') then
            Error(Text005) else begin
            repeat
                TestField("Quantity Invoiced", 0);
            until Next() = 0;
        end;

        if not HideDialog then
            if not Confirm(Text000) then
                exit;

        PurchRcptLine.Copy(Rec);
        Code;
        Rec := PurchRcptLine;
    end;

    local procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    local procedure Code()
    var
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        PurchLine: Record "Purchase Line";
        Window: Dialog;
        ItemRcptEntryNo: Integer;
        docLineNo: Integer;
        PostedWhseRcptLineFound: Boolean;
    begin

        with PurchRcptLine do begin
            SetRange(Correction, false);
            if IsEmpty then
                Error(AllLinesCorrectedErr);

            repeat
                if not HideDialog then
                    Window.Open(Text003);
                CheckPurchRcptLine(PurchRcptLine);
            until Next() = 0;

            Find('-');
            repeat
                TempGlobalItemLedgEntry.Reset();
                if not TempGlobalItemLedgEntry.IsEmpty then
                    TempGlobalItemLedgEntry.DeleteAll();
                TempGlobalItemEntryRelation.Reset();
                if not TempGlobalItemEntryRelation.IsEmpty then
                    TempGlobalItemEntryRelation.DeleteAll();

                if not HideDialog then
                    Window.Open(Text001);
                if (Type = Type::Item) then begin
                    PostedWhseRcptLineFound :=
                      WhseUndoQty.FindPostedWhseRcptLine(
                        PostedWhseRcptLine,
                        DATABASE::"Purch. Rcpt. Line",
                        "document No.",
                        DATABASE::"Purchase Line",
                        PurchLine."document Type"::Order,
                        "Order No.",
                        "Order Line No.");
                end;
                if type = Type::Item then
                    ItemRcptEntryNo := PostItemJnlLine(PurchRcptLine, docLineNo);

                if Type = Type::"G/L Account" then
                    DocLineNo := PurchRcptLine."Line No." + 1;

                InsertNewReceiptLine(PurchRcptLine, ItemRcptEntryNo, docLineNo);
                if (Type = Type::Item) then
                    if PostedWhseRcptLineFound then
                        WhseUndoQty.UndoPostedWhseRcptLine(PostedWhseRcptLine);

                UpdateOrderLine(PurchRcptLine);
                if (Type = Type::Item) then
                    if PostedWhseRcptLineFound then
                        WhseUndoQty.UpdateRcptSourcedocLines(PostedWhseRcptLine);

                if ("Blanket Order No." <> '') and ("Blanket Order Line No." <> 0) then
                    UpdateBlanketOrder(PurchRcptLine);

                "Quantity Invoiced" := Quantity;
                "Qty. Invoiced (Base)" := "Quantity (Base)";
                "Qty. Rcd. not Invoiced" := 0;
                Correction := true;

                Modify();

                if not JobItem then
                    JobItem := (Type = Type::Item) and ("Job No." <> '');
            until Next() = 0;

            InvtSetup.Get();
            if InvtSetup."Automatic Cost Adjustment" <>
               InvtSetup."Automatic Cost Adjustment"::Never
            then begin
                InvtAdjmt.SetProperties(true, InvtSetup."Automatic Cost Posting");
                InvtAdjmt.SetJobUpdateProperties(not JobItem);
                InvtAdjmt.MakeMultiLevelAdjmt;
            end;

            WhseUndoQty.PostTempWhseJnlLine(TempWhseJnlLine);
        end;
    end;

    local procedure CheckPurchRcptLine(PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
    begin

        with PurchRcptLine do begin
            if (Type <> Type::"G/L Account") and (Type <> Type::Item) then
                Error(Text006);

            if "Qty. Rcd. not Invoiced" <> Quantity then
                Error(Text004);
            TestField("Prod. Order No.", '');
            TestField("Sales Order No.", '');
            TestField("Sales Order Line No.", 0);

            UndoPostingMgt.TestPurchRcptLine(PurchRcptLine);
            if (Type = Type::Item) then begin
                UndoPostingMgt.CollectItemLedgEntries(TempItemLedgEntry, DATABASE::"Purch. Rcpt. Line",
                  "document No.", "Line No.", "Quantity (Base)", "Item Rcpt. Entry No.");
                UndoPostingMgt.CheckItemLedgEntries(TempItemLedgEntry, "Line No.");
            end;
        end;
    end;

    local procedure PostItemJnlLine(PurchRcptLine: Record "Purch. Rcpt. Line"; var docLineNo: Integer): Integer
    var
        ItemJnlLine: Record "Item Journal Line";
        PurchLine: Record "Purchase Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine2: Record "Purch. Rcpt. Line";
        SourceCodeSetup: Record "Source Code Setup";
        TempApplyToEntryList: Record "Item Ledger Entry";
        LineSpacing: Integer;
        ItemApplicationEntry: Record "Item Application Entry";
        Item: Record Item;
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        IsHandled: Boolean;
    begin

        with PurchRcptLine do begin
            PurchRcptLine2.SetRange("document No.", "document No.");
            PurchRcptLine2."document No." := "document No.";
            PurchRcptLine2."Line No." := "Line No.";
            PurchRcptLine2.Find('=');

            if PurchRcptLine2.Find('>') then begin
                LineSpacing := (PurchRcptLine2."Line No." - "Line No.") DIV 2;
                if LineSpacing = 0 then
                    Error(Text002);
            end else
                LineSpacing := 10000;
            docLineNo := "Line No." + LineSpacing;

            SourceCodeSetup.Get();
            PurchRcptHeader.Get("document No.");
            ItemJnlLine.Init();
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Purchase;
            ItemJnlLine."Item No." := "No.";
            ItemJnlLine."Posting Date" := PurchRcptHeader."Posting Date";
            ItemJnlLine."document No." := "document No.";
            ItemJnlLine."document Line No." := docLineNo;
            ItemJnlLine."document Type" := ItemJnlLine."document Type"::"Purchase Receipt";
            ItemJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
            ItemJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            ItemJnlLine."Location Code" := "Location Code";
            ItemJnlLine."Source Code" := SourceCodeSetup.Purchases;
            ItemJnlLine."Variant Code" := "Variant Code";
            ItemJnlLine."Bin Code" := "Bin Code";
            ItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
            ItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
            ItemJnlLine."document Date" := PurchRcptHeader."document Date";
            ItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            ItemJnlLine."Dimension Set ID" := "Dimension Set ID";

            if "Job No." = '' then begin
                ItemJnlLine.Correction := true;
                ItemJnlLine."Applies-to Entry" := "Item Rcpt. Entry No.";
            end else begin
                ItemJnlLine."Job No." := "Job No.";
                ItemJnlLine."Job Task No." := "Job Task No.";
                ItemJnlLine."Job Purchase" := true;
                ItemJnlLine."Unit Cost" := "Unit Cost (LCY)";
            end;
            ItemJnlLine.Quantity := -Quantity;
            ItemJnlLine."Quantity (Base)" := -"Quantity (Base)";

            WhseUndoQty.InsertTempWhseJnlLine(ItemJnlLine,
              DATABASE::"Purchase Line",
              PurchLine."document Type"::Order,
              "Order No.",
              "Line No.",
              TempWhseJnlLine."Reference document"::"Posted Rcpt.",
              TempWhseJnlLine,
              NextLineNo);

            if "Item Rcpt. Entry No." <> 0 then begin
                if "Job No." <> '' then
                    UndoPostingMgt.TransferSourceValues(ItemJnlLine, "Item Rcpt. Entry No.");
                UndoPostingMgt.PostItemJnlLine(ItemJnlLine);
                if "Job No." <> '' then begin
                    Item.Get("No.");
                    if Item.Type = Item.Type::Inventory then begin
                        UndoPostingMgt.FindItemReceiptApplication(ItemApplicationEntry, "Item Rcpt. Entry No.");
                        ItemJnlPostLine.UndoValuePostingwithJob(
                          "Item Rcpt. Entry No.", ItemApplicationEntry."Outbound Item Entry No.");
                        IsHandled := false;
                        if not IsHandled then begin
                            UndoPostingMgt.FindItemShipmentApplication(ItemApplicationEntry, ItemJnlLine."Item Shpt. Entry No.");
                            ItemJnlPostLine.UndoValuePostingwithJob(
                              ItemApplicationEntry."Inbound Item Entry No.", ItemJnlLine."Item Shpt. Entry No.");
                        end;
                        UndoPostingMgt.ReapplyJobConsumption("Item Rcpt. Entry No.");
                    end;
                end;

                Exit(ItemJnlLine."Item Shpt. Entry No.");
            end;

            UndoPostingMgt.CollectItemLedgEntries(
              TempApplyToEntryList, DATABASE::"Purch. Rcpt. Line", "document No.", "Line No.", "Quantity (Base)", "Item Rcpt. Entry No.");

            if "Job No." <> '' then
                if TempApplyToEntryList.FindSet() then
                    repeat
                        UndoPostingMgt.ReapplyJobConsumption(TempApplyToEntryList."Entry No.");
                    until TempApplyToEntryList.Next() = 0;

            UndoPostingMgt.PostItemJnlLineAppliedToList(ItemJnlLine, TempApplyToEntryList,
              Quantity, "Quantity (Base)", TempGlobalItemLedgEntry, TempGlobalItemEntryRelation);

            Exit(0); // "Item Shpt. Entry No."
        end;

    end;

    local procedure InsertNewReceiptLine(OldPurchRcptLine: Record "Purch. Rcpt. Line"; ItemRcptEntryNo: Integer; docLineNo: Integer)
    var
        NewPurchRcptLine: Record "Purch. Rcpt. Line";
    begin

        with OldPurchRcptLine do begin
            NewPurchRcptLine.Init();
            NewPurchRcptLine.Copy(OldPurchRcptLine);
            NewPurchRcptLine."Line No." := docLineNo;
            if OldPurchRcptLine.Type = OldPurchRcptLine.Type::Item then begin
                NewPurchRcptLine."Appl.-to Item Entry" := "Item Rcpt. Entry No.";
                NewPurchRcptLine."Item Rcpt. Entry No." := ItemRcptEntryNo;
            end;
            NewPurchRcptLine.Quantity := -Quantity;
            NewPurchRcptLine."Quantity (Base)" := -"Quantity (Base)";
            NewPurchRcptLine."Quantity Invoiced" := NewPurchRcptLine.Quantity;
            NewPurchRcptLine."Qty. Invoiced (Base)" := NewPurchRcptLine."Quantity (Base)";
            NewPurchRcptLine."Qty. Rcd. not Invoiced" := 0;
            NewPurchRcptLine.Correction := true;
            NewPurchRcptLine."Dimension Set ID" := "Dimension Set ID";
            NewPurchRcptLine.Insert();

            InsertItemEntryRelation(TempGlobalItemEntryRelation, NewPurchRcptLine);
        end;
    end;

    local procedure UpdateOrderLine(PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        PurchLine: Record "Purchase Line";
    begin
        with PurchRcptLine do begin
            PurchLine.Get(PurchLine."document Type"::Order, "Order No.", "Order Line No.");
            UndoPostingMgt.UpdatePurchLine(PurchLine, Quantity, "Quantity (Base)", TempGlobalItemLedgEntry);
        end;
    end;

    local procedure UpdateBlanketOrder(PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        BlanketOrderLine: Record "Purchase Line";
    begin

        with PurchRcptLine do begin
            if BlanketOrderLine.Get(
                 BlanketOrderLine."document Type"::"Blanket Order", "Blanket Order No.", "Blanket Order Line No.")
            then begin
                BlanketOrderLine.TestField(Type, Type);
                BlanketOrderLine.TestField("No.", "No.");
                BlanketOrderLine.TestField("Buy-from Vendor No.", "Buy-from Vendor No.");

                if BlanketOrderLine."Qty. per Unit of Measure" = "Qty. per Unit of Measure" then
                    BlanketOrderLine."Quantity Received" := BlanketOrderLine."Quantity Received" - Quantity
                else
                    BlanketOrderLine."Quantity Received" :=
                      BlanketOrderLine."Quantity Received" -
                      ROUND("Qty. per Unit of Measure" / BlanketOrderLine."Qty. per Unit of Measure" * Quantity, 0.00001);

                BlanketOrderLine."Qty. Received (Base)" := BlanketOrderLine."Qty. Received (Base)" - "Quantity (Base)";
                BlanketOrderLine.InitOutstanding;
                BlanketOrderLine.Modify();
            end;
        end;
    end;

    local procedure InsertItemEntryRelation(var TempItemEntryRelation: Record "Item Entry Relation" temporary; NewPurchRcptLine: Record "Purch. Rcpt. Line")
    var
        ItemEntryRelation: Record "Item Entry Relation";
    begin
        if TempItemEntryRelation.Find('-') then
            repeat
                ItemEntryRelation := TempItemEntryRelation;
                ItemEntryRelation.TransferFieldsPurchRcptLine(NewPurchRcptLine);
                ItemEntryRelation.Insert();
            until TempItemEntryRelation.Next() = 0;
    end;

    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TempWhseJnlLine: Record "Warehouse Journal Line";
        TempGlobalItemLedgEntry: Record "Item Ledger Entry";
        TempGlobalItemEntryRelation: Record "Item Entry Relation";
        InvtSetup: Record "Inventory Setup";
        UndoPostingMgt: Codeunit "Undo Posting Management";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        WhseUndoQty: Codeunit "Whse. Undo Quantity";
        InvtAdjmt: Codeunit "Inventory Adjustment";
        HideDialog: Boolean;
        JobItem: Boolean;
        NextLineNo: Integer;
        
        Text000: Label 'Do you really want to undo the selected Receipt lines?', comment = 'ITA="Annullare le righe di carico selezionate?"';
        Text001: Label 'Undo quantity posting...', comment = 'ITA="Annullamento registrazione quantità..."';
        Text002: Label 'There is not enough space to insert correction lines.', comment = 'ITA="Spazio insufficiente per l''inserimento delle righe di correzione."';
        Text003: Label 'Checking lines...', comment = 'ITA="Controllo delle righe in corso..."';
        Text004: Label 'This receipt has already been invoiced. Undo Receipt can be applied only to posted, but not invoiced receipts.', comment = 'ITA="Il carico è già stato fatturato. È possibile applicare Annulla Carico solo a carichi registrati, ma non fatturati."';
        Text005: Label 'Undo G/L Account Receipt can be performed only for lines of type "G/L Account". Please select a line of the Item type and repeat the procedure.', comment = 'ITA="È possibile eseguire "Annulla carico su conto" solo per le righe di tipo Conto C/G. Selezionare una riga opportuna e ripetere la procedura."';
        Text006: Label 'Undo Receipt can be performed only for lines of type Item or G/L Account', comment = 'ITA="La procedura può essere utilizzata solo per righe di tipo Conto C/G o Articolo"';
        AllLinesCorrectedErr: Label 'All lines have been already corrected.', comment = 'ITA="Tutte le righe sono state già corrette."';
        AlreadyReversedErr: Label 'This receipt has already been reversed.', comment = 'ITA="Il carico è già stato stornato."';
}
*/