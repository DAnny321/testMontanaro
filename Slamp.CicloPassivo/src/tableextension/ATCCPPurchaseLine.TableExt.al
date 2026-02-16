tableextension 90201 "ATC_CP_Purchase Line" extends "Purchase Line"
{

    fields
    {

        field(90200; "ATC_CP_Purchase Request"; Boolean)
        {
            Caption = 'Purchase Request', comment = 'ITA="Richiesta di acquisto"';
            DataClassification = CustomerContent;
        }
        field(90201; "ATC_CP_New Line Type"; Enum "ATC_CP_Line Type")
        {
            Caption = 'New Line Type',
                        comment = 'ITA="Nuovo tipo riga"';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TESTFIELD(Type);
                TESTFIELD("No.");
                //testfield("ATC_CP_Purchase Request");
                TestStatusOpen();
            end;
        }
        field(90202; "ATC_CP_New Line No."; Code[20])
        {
            Caption = 'New No.',
                        comment = 'ITA="Nuovo Nr."';
            DataClassification = CustomerContent;

            TableRelation = IF ("ATC_CP_New Line Type" = CONST(" ")) "Standard Text"
            ELSE
            IF ("ATC_CP_New Line Type" = CONST("G/L Account"),
                                     "System-Created Entry" = CONST(false)) "G/L Account" WHERE("Direct Posting" = CONST(true),
                                                                                               "Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE
            IF ("ATC_CP_New Line Type" = CONST("G/L Account"),
                                                                                                        "System-Created Entry" = CONST(true)) "G/L Account"
            ELSE
            IF ("ATC_CP_New Line Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("ATC_CP_New Line Type" = CONST("Charge (Item)")) "Item Charge"
            ELSE
            IF ("ATC_CP_New Line Type" = CONST(Item)) Item where(Blocked = const(false), "Purchasing Blocked" = const(false));
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                // Temp_lRecPurchaseLine: Record "Purchase Line" temporary;
                // FindRecordMgt: Codeunit "Find Record Management";
                MessConfirm_Msg: Label 'Do you want to replace Type and No?', comment = 'ITA="Procedere con la sostituzione di Tipo e Nr?"';
                Mess_Msg: Label 'Operation Canceled', comment = 'ITA="Operazione annullata"';
                mess2_Msg: Label 'Line Type is not valid for replacement', comment = 'ITA="Tipo riga non valida per la sostituzione"';
            begin
                TestStatusOpen();
                if "ATC_CP_New Line No." = '' then
                    exit;
                TESTFIELD(Type);
                TESTFIELD("No.");
                TestField("ATC_CP_New Line Type");
                //testfield("ATC_CP_Purchase Request");

                if "ATC_CP_New Line Type" in ["ATC_CP_New Line Type"::" ", "ATC_CP_New Line Type"::"Charge (Item)"] then
                    Message(Mess_Msg)
                else
                    if Confirm(MessConfirm_Msg) then
                        ReplaceOrigValue()
                    else
                        Message(mess2_Msg);
            end;
        }
        field(90203; "ATC_CP_Request Additional Info"; Text[100])
        {
            Caption = 'PR Request Additional Info', comment = 'ITA="Informazioni aggiuntive"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }

        field(90204; "ATC_CP_Expence Category"; Code[20])
        {
            TableRelation = "ATC_CP_Expence Category".Code;
            DataClassification = CustomerContent;
            Caption = 'Expence Category Code', comment = 'ITA="Codice categoria di spesa"';

            trigger OnLookup()
            var
                lpage: Page "ATC_CP_Expence Category";
                lRecord: Record "ATC_CP_Expence Category";
                Assoc: Record "ATC_CP_Driver Category Assoc.";
                PurchHdr: Record "Purchase Header";
                FilterAssoc: Text;
            begin
                clear(lPage);
                clear(lRecord);
                lPage.SETTABLEVIEW(lRecord);
                prSetup.get;
                if PrSetup."Active Driver-Hierarchy Assoc." then begin
                    PurchHdr.get(Rec."Document Type", Rec."Document No.");
                    lRecord.FILTERGROUP(8);
                    Assoc.Reset();
                    Assoc.SetRange("Dimension Code", PrSetup."Driver Dimension Code");
                    if PrSetup.isGlobalDim1() then begin
                        PurchHdr.testfield("Shortcut Dimension 1 Code");
                        Assoc.SetRange(Code, PurchHdr."Shortcut Dimension 1 Code");
                    end else begin
                        PurchHdr.testfield("Shortcut Dimension 2 Code");
                        Assoc.SetRange(Code, PurchHdr."Shortcut Dimension 2 Code");
                    end;
                    if Assoc.FindSet() then
                        repeat
                            if FilterAssoc = '' then
                                FilterAssoc := Assoc."Expence Category Code"
                            else
                                FilterAssoc += '|' + Assoc."Expence Category Code";
                        until Assoc.Next() = 0;
                    if FilterAssoc <> '' then
                        lRecord.setfilter(Code, FilterAssoc);
                    lRecord.FILTERGROUP(0);
                end;
                lPage.SETTABLEVIEW(lRecord);
                lPage.Editable := false;
                lPage.LOOKUPMODE := TRUE;
                if (lPage.RUNMODAL = ACTION::LookupOK) then begin
                    lPage.GETRECORD(lRecord);
                    validate("ATC_CP_Expence Category", lRecord.Code);
                end;
            end;


            trigger OnValidate()
            var
                PurchHdr: Record "Purchase Header";
                Assoc: Record "ATC_CP_Driver Category Assoc.";
            begin
                TestStatusOpen();
                if ("ATC_CP_Expence Category" <> '') then begin
                    prSetup.get;
                    if PrSetup."Active Driver-Hierarchy Assoc." then begin
                        PurchHdr.get(Rec."Document Type", Rec."Document No.");
                        if PrSetup.isGlobalDim1() then
                            Assoc.Get(PrSetup."Driver Dimension Code", PurchHdr."Shortcut Dimension 1 Code", "ATC_CP_Expence Category")
                        else
                            Assoc.Get(PrSetup."Driver Dimension Code", PurchHdr."Shortcut Dimension 2 Code", "ATC_CP_Expence Category");
                    end;
                end;

                if ("ATC_CP_Expence Category" <> xRec."ATC_CP_Expence Category") then
                    Validate("ATC_CP_Expence SubCategory", '');
            end;
        }
        field(90205; "ATC_CP_Expence SubCategory"; Code[20])
        {
            TableRelation = "ATC_CP_Expence SubCategory".Code where("Category Code" = field("ATC_CP_Expence Category"));
            Caption = 'Expence SubCategory', comment = 'ITA="Codice sottocategoria di spesa"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestStatusOpen();
                if "ATC_CP_Expence SubCategory" <> '' then
                    TestField("ATC_CP_Expence Category");

                if ("ATC_CP_Expence SubCategory" <> xRec."ATC_CP_Expence SubCategory") then
                    Validate("ATC_CP_Expence Details", '');

            end;
        }
        field(90206; "ATC_CP_Expence Details"; Code[20])
        {
            TableRelation = "ATC_CP_Expence Details".Code where("Category Code" = field("ATC_CP_Expence Category"), "SubCategory Code" = field("ATC_CP_Expence SubCategory"));
            Caption = 'Expence Details', comment = 'ITA="Codice dettaglio di spesa"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestStatusOpen();
                if "ATC_CP_Expence Details" <> '' then
                    TestField("ATC_CP_Expence SubCategory");
                if ("ATC_CP_Expence Details" <> xRec."ATC_CP_Expence Details") then
                    Validate("No.", '');
            end;
        }


        field(90220; "ATC_CP_1st Vendor Rating"; Enum "ATC_CP_Vendor Rating")
        {
            CaptionClass = gRecATCCPGeneralSetup.getRatingCaption(1);
            DataClassification = CustomerContent;
        }

        field(90221; "ATC_CP_2nd Vendor Rating"; Enum "ATC_CP_Vendor Rating")
        {
            CaptionClass = gRecATCCPGeneralSetup.getRatingCaption(2);
            DataClassification = CustomerContent;
        }

        field(90222; "ATC_CP_3rd Vendor Rating"; Enum "ATC_CP_Vendor Rating")
        {
            CaptionClass = gRecATCCPGeneralSetup.getRatingCaption(3);
            DataClassification = CustomerContent;
        }
        field(90223; "ATC_CP_Lost Outstanding Qty"; Boolean)
        {
            Caption = 'Lost Outstanding Qty', comment = 'ITA="Quantità inevasa persa"';
            DataClassification = CustomerContent;
        }

    }

    local procedure ReplaceOrigValue();
    var
        TempPurchaseLine: Record "Purchase Line" temporary;
    begin
        TempPurchaseLine := Rec;
        if rec.Delete(true) then begin
            Init();
            "Document Type" := TempPurchaseLine."Document Type";
            "Document No." := TempPurchaseLine."Document No.";
            "Line No." := TempPurchaseLine."Line No." + 10;
            Insert(true);
            VALIDATE(Type, TempPurchaseLine."ATC_CP_New Line Type");
            VALIDATE("No.", TempPurchaseLine."ATC_CP_New Line No.");
            ATC_CP_InitHeaderDefaultsCustom();
            Description := TempPurchaseLine.Description;
            "Description 2" := TempPurchaseLine."Description 2";
            "ATC_CP_Request Additional Info" := TempPurchaseLine."ATC_CP_Request Additional Info";
            //Validate("VAT Prod. Posting Group", TempPurchaseLine."VAT Prod. Posting Group");
            //Validate("Gen. Prod. Posting Group", TempPurchaseLine."Gen. Prod. Posting Group");
            VALIDATE(Quantity, TempPurchaseLine.Quantity);
            Validate("Location Code", TempPurchaseLine."Location Code");
            VALIDATE("Direct Unit Cost", TempPurchaseLine."Direct Unit Cost");
            VALIDATE("Line Discount %", TempPurchaseLine."Line Discount %");
            VALIDATE("Shortcut Dimension 1 Code", TempPurchaseLine."Shortcut Dimension 1 Code");
            VALIDATE("Shortcut Dimension 2 Code", TempPurchaseLine."Shortcut Dimension 2 Code");
            VALIDATE("Dimension Set ID", TempPurchaseLine."Dimension Set ID");
            modify();
        end;
    end;

    procedure ATC_CP_InitHeaderDefaultsCustom()
    var
        lRecPurchaseHeader: Record "Purchase Header";
    begin
        lRecPurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
        lRecPurchaseHeader.TESTFIELD("Buy-from Vendor No.");

        "Buy-from Vendor No." := lRecPurchaseHeader."Buy-from Vendor No.";
        "Currency Code" := lRecPurchaseHeader."Currency Code";
        "Expected Receipt Date" := lRecPurchaseHeader."Expected Receipt Date";
        "Shortcut Dimension 1 Code" := lRecPurchaseHeader."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := lRecPurchaseHeader."Shortcut Dimension 2 Code";
        IF NOT IsNonInventoriableItem() THEN
            "Location Code" := lRecPurchaseHeader."Location Code";
        "Transaction Type" := lRecPurchaseHeader."Transaction Type";
        "Transport Method" := lRecPurchaseHeader."Transport Method";
        "Pay-to Vendor No." := lRecPurchaseHeader."Pay-to Vendor No.";
        "Gen. Bus. Posting Group" := lRecPurchaseHeader."Gen. Bus. Posting Group";
        "VAT Bus. Posting Group" := lRecPurchaseHeader."VAT Bus. Posting Group";
        "Entry Point" := lRecPurchaseHeader."Entry Point";
        //"Refers to Period" := lRecPurchaseHeader."Refers to Period";
        Area := lRecPurchaseHeader.Area;
        "Transaction Specification" := lRecPurchaseHeader."Transaction Specification";
        "Tax Area Code" := lRecPurchaseHeader."Tax Area Code";
        "Tax Liable" := lRecPurchaseHeader."Tax Liable";
        "Prepayment Tax Area Code" := lRecPurchaseHeader."Tax Area Code";
        "Prepayment Tax Liable" := lRecPurchaseHeader."Tax Liable";
        "Responsibility Center" := lRecPurchaseHeader."Responsibility Center";
        "Requested Receipt Date" := lRecPurchaseHeader."Requested Receipt Date";
        "Promised Receipt Date" := lRecPurchaseHeader."Promised Receipt Date";
        "Inbound Whse. Handling Time" := lRecPurchaseHeader."Inbound Whse. Handling Time";
        "Order Date" := lRecPurchaseHeader."Order Date";
    end;

    var
        gRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
        PrSetup: Record "ATC_CP_General Setup";
}

