table 90200 "ATC_CP_General Setup"
{
    Caption = 'Purchasing Cycle General Setup', Comment = 'ITA="Setup generale ciclo passivo"';
    LookupPageId = "ATC_CP_General Setup";
    DrillDownPageId = "ATC_CP_General Setup";
    Permissions = tabledata 121 = rm;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key', comment = 'ITA="Chiave primaria"';
            DataClassification = CustomerContent;
        }
        field(10; "Active Purchase Request"; Boolean)
        {
            Caption = 'Active Purchase Module', comment = 'ITA="Attiva modulo"';
            DataClassification = CustomerContent;
        }

        field(20; "Default Expence Type"; Code[20])
        {
            Caption = 'Default Request Type',
                        comment = 'ITA="Tipo richiesta di default"';
            DataClassification = CustomerContent;
            TableRelation = "ATC_CP_Expence Type".Code;
            trigger OnValidate()
            begin
                if "Default Expence Type" <> '' then
                    testfield("Default Vendor");
            end;
        }

        field(40; "Driver Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code Driver', comment = 'ITA="Codice dimensione driver"';
            DataClassification = CustomerContent;
            TableRelation = Dimension.Code;
            trigger OnValidate()
            var
                DimUserRole: Record "ATC_CP_Dimension User Role";
                DriverCategoryAssoc: Record "ATC_CP_Driver Category Assoc.";
                GenLedgSetup: Record "General Ledger Setup";
                ErrorDim_Err: Label 'It is possibile select driver dimension between Global Dimensions!', comment = 'ITA="E'' possibile scegliere la dimensione driver solo tra le dimensioni globali!"';
            begin
                if "Driver Dimension Code" <> '' then begin
                    GenLedgSetup.Get();
                    if ("Driver Dimension Code" <> GenLedgSetup."Global Dimension 1 Code") and ("Driver Dimension Code" <> GenLedgSetup."Global Dimension 2 Code") then
                        Error(ErrorDim_Err);
                end;

                if ("Driver Dimension Code" <> xRec."Driver Dimension Code") and (xRec."Driver Dimension Code" = '') then begin
                    DimUserRole.Reset();
                    DimUserRole.DeleteAll();
                    DriverCategoryAssoc.Reset();
                    DriverCategoryAssoc.DeleteAll();
                end;
            end;
        }
        field(50; "Default Vendor"; Code[20])
        {
            Caption = 'Default Vendor', comment = 'ITA="Fornitore di default"';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            begin
                if ("Default Vendor" = '') then
                    TestField("Default Expence Type", '');
            end;
        }


        field(70; "Active VDS Selection Hierarchy"; Boolean)
        {
            Caption = 'Active VDS Selection Hierarchy',
                        comment = 'ITA="Attiva selezione gerarchia per voce di spesa"';

            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Active VDS Selection Hierarchy" then
                    "Hierarchy Selection Level" := "Hierarchy Selection Level"::Level1
                else begin
                    "Hierarchy Selection Level" := "Hierarchy Selection Level"::" ";
                    "Active Driver-Hierarchy Assoc." := false;
                end;
            end;
        }
        field(72; "Active Driver-Hierarchy Assoc."; Boolean)
        {
            Caption = 'Active Driver-Hierarchy Association', comment = 'ITA="Attiva associazione Driver-Gerarchia"';
            trigger OnValidate()
            var
                ExpenceType: Record "ATC_CP_Expence Type";
                labelError: Label 'Cannot proceed: it is not possible to activate the association between Driver and Category if there are Expence Types with  Default Value.', Comment = 'ITA="Impossibile procedere: non è possibile attivare l''associazione tra Driver e Categoria se sono presenti a sistema delle Tipologie di spesa con Valore di Default associato."';
            begin
                if "Active Driver-Hierarchy Assoc." then begin
                    ExpenceType.Reset();
                    ExpenceType.SetRange("Default Value", '<>''');
                    if not ExpenceType.IsEmpty then
                        Error(labelError);
                end;
            end;
        }
        field(80; "Hierarchy Selection Level"; enum "ATC_CP_Selection Level")
        {
            Caption = 'Hierarchy Selection Level', comment = 'ITA="Livello selezione gerarchia"';
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                if "Hierarchy Selection Level" <> "Hierarchy Selection Level"::" " then
                    TESTFIELD("Active VDS Selection Hierarchy")
                else
                    TestField("Active VDS Selection Hierarchy", false);
            end;
        }

        field(85; "Mandatory Hierarchy"; Boolean)
        {
            Caption = 'Mandatory Hierarchy', comment = 'ITA="Gerarchia obbligatoria"';
            DataClassification = CustomerContent;
        }

        field(90; "Hidden Field No. from List"; Boolean)
        {
            Caption = 'Hidden Field No. from Lines', comment = 'ITA="Nascondi campo Nr. su righe"';
            DataClassification = CustomerContent;
        }

        field(100; "Request Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
            Caption = 'Request Nos.', comment = 'ITA="Nr. serie richieste di acquisto"';
            DataClassification = CustomerContent;
        }

        field(110; "Template Request Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
            Caption = 'Template Request Nos.', comment = 'ITA="Nr. serie template richieste"';
            DataClassification = CustomerContent;
        }

        field(120; "Reset Default Price/Discount"; Boolean)
        {
            Caption = 'Reset Default Price/Discount', comment = 'ITA="Azzera prezzi/sconti default"';
            DataClassification = CustomerContent;
        }

        field(130; "Request Only Quantities"; Boolean)
        {
            Caption = 'Request only quantities', comment = 'ITA="Richiedi solo quantità"';
            DataClassification = CustomerContent;
        }
        field(132; "Line Amount Check"; Boolean)
        {
            Caption = 'Line Amount Check', comment = 'ITA="Verifica importo riga"';
            DataClassification = CustomerContent;
        }
        field(134; "Same Driver Check"; Boolean)
        {
            Caption = 'Lines Same Driver Check', comment = 'ITA="Verifica stessa dimensione driver su righe"';
            DataClassification = CustomerContent;
        }
        field(135; "Skip Alert Vendor Ass. Dim."; Boolean)
        {
            Caption = 'Skip Alert Vendor Associated Dimension', comment = 'ITA="Non notificare dimensione associata su fornitore"';
        }
        field(140; "Default Request Priority"; Enum ATC_CP_Priority)
        {
            Caption = 'Request Priority', comment = 'ITA="Priorità richiesta"';
            DataClassification = CustomerContent;
        }

        field(150; "Enable Vendor Rating"; Boolean)
        {
            Caption = 'Enable Vendor Rating', comment = 'ITA="Attiva rating fornitori"';
            DataClassification = CustomerContent;
        }

        field(153; "First Vendor Rating"; Code[20])
        {
            Caption = 'First Vendor Rating', comment = 'ITA="Primo rating fornitori"';
            TableRelation = "ATC_CP_Vendor Rating"."Rating Code";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (xRec."First Vendor Rating" <> '') and (Rec."First Vendor Rating" <> xRec."First Vendor Rating") then
                    CheckRatingModify(1);
            end;
        }
        field(154; "Second Vendor Rating"; Code[20])
        {
            Caption = 'Second Vendor Rating', comment = 'ITA="Secondo rating fornitori"';
            DataClassification = CustomerContent;
            TableRelation = "ATC_CP_Vendor Rating"."Rating Code";
            trigger OnValidate()
            begin
                if (xRec."Second Vendor Rating" <> '') and (Rec."Second Vendor Rating" <> xRec."Second Vendor Rating") then
                    CheckRatingModify(2);
            end;
        }
        field(155; "Third Vendor Rating"; Code[20])
        {
            Caption = 'Third Vendor Rating', comment = 'ITA="Terzo rating fornitori"';
            DataClassification = CustomerContent;
            TableRelation = "ATC_CP_Vendor Rating"."Rating Code";
            trigger OnValidate()
            begin
                if (xRec."Third Vendor Rating" <> '') and (Rec."Third Vendor Rating" <> xRec."Third Vendor Rating") then
                    CheckRatingModify(3);
            end;
        }
        field(156; "Mandatory Rating"; Boolean)
        {
            Caption = 'Mandatory Rating', comment = 'ITA="Rating obbligatorio"';
            DataClassification = CustomerContent;
        }
        field(200; "Administration E-Mail"; text[80])
        {
            Caption = 'Administration E-Mail', comment = 'ITA="E-Mail amministrazione"';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        }
        field(210; "Purchase Office E-Mail"; text[80])
        {
            Caption = 'Purchase Office E-Mail', comment = 'ITA="E-Mail ufficio acquisti"';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        }

        field(220; "Aut. Purch. Rcpt. Batch. Post"; Boolean)
        {
            Caption = 'Active Automatic Purch. Rcpt. Batch Post', comment = 'ITA="Abilita registrazione automatica carichi"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Aut. Purch. Rcpt. Batch. Post" then
                    DelayBatchUpdateOrder := 1;
            end;
        }
        field(221; BatchPostReceiptParameter; Text[50])
        {
            Caption = 'Batch Receipt Post Parameter', comment = 'ITA="Stringa registrazione carico"';
            DataClassification = CustomerContent;
        }
        field(222; BatchUpdateOrderParameter; Text[50])
        {
            Caption = 'Batch Update Order Parameter', comment = 'ITA="Stringa aggiornamento ordine"';
            DataClassification = CustomerContent;
        }
        field(223; BatchPostUpdateParameter; Text[50])
        {
            Caption = 'Batch Post and Update Parameter', comment = 'ITA="Stringa registra e aggiorna ordine"';
            DataClassification = CustomerContent;
        }
        field(224; DelayBatchUpdateOrder; Integer)
        {
            Caption = 'Second Delay Batch Update Order', comment = 'ITA="Ritardo (in secondi) procedura batch agg. ordine"';
            DataClassification = CustomerContent;
            MinValue = 0;
        }

        field(225; "Send Email Scenario"; Enum "Email Scenario")
        {
            Caption = 'Send Email Scenario', Comment = 'ITA="Scenario di default notifiche mail"';
        }
    }


    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure HierarchyVisibility(Livel: Integer) Show: Boolean;
    begin
        get();
        if not "Active VDS Selection Hierarchy" then
            exit(false);

        case Livel of
            1:
                exit("Hierarchy Selection Level" <> "Hierarchy Selection Level"::" ");
            2:
                exit("Hierarchy Selection Level" in ["Hierarchy Selection Level"::Level2, "Hierarchy Selection Level"::Level3]);
            3:
                exit("Hierarchy Selection Level" = "Hierarchy Selection Level"::Level3);
            else
                ERROR('Parameter not valid');
        end;
    end;

    procedure CalcPageVisibility(var Bln1st: Boolean; var Bln2nd: Boolean; var Bln3rd: Boolean; var BlnNoField: Boolean)
    begin
        if not Get() then
            exit;
        Bln1st := "Active VDS Selection Hierarchy" and ("Hierarchy Selection Level" <> "Hierarchy Selection Level"::" ");
        Bln2nd := "Active VDS Selection Hierarchy" and ("Hierarchy Selection Level" in ["Hierarchy Selection Level"::Level2, "Hierarchy Selection Level"::Level3]);
        Bln3rd := "Active VDS Selection Hierarchy" and ("Hierarchy Selection Level" = "Hierarchy Selection Level"::Level3);
        BlnNoField := not "Hidden Field No. from List";
    end;

    procedure CalcPageLinesVisibility(var Bln1st: Boolean; var Bln2nd: Boolean; var Bln3rd: Boolean; var BlnNoField: Boolean; var BlnPriceDisc: Boolean)
    begin
        Get();
        Bln1st := "Active VDS Selection Hierarchy" and ("Hierarchy Selection Level" <> "Hierarchy Selection Level"::" ");
        Bln2nd := "Active VDS Selection Hierarchy" and ("Hierarchy Selection Level" in ["Hierarchy Selection Level"::Level2, "Hierarchy Selection Level"::Level3]);
        Bln3rd := "Active VDS Selection Hierarchy" and ("Hierarchy Selection Level" = "Hierarchy Selection Level"::Level3);
        BlnNoField := not "Hidden Field No. from List";
        BlnPriceDisc := not "Request Only Quantities";
    end;

    procedure isActiveError()
    begin
        Get();
        TestField("Active Purchase Request");
    end;

    procedure isActiveCheck(): Boolean
    begin
        if Get() then
            exit("Active Purchase Request")
        else
            exit(false);
    end;

    procedure isVisible(): Boolean
    begin
        if Get() then
            exit("Active Purchase Request")
        else
            exit(false);
    end;

    procedure isActiveHierarchy(): Boolean
    begin
        Get();
        exit("Active VDS Selection Hierarchy");
    end;

    procedure AmountMngt(var resetPrice: Boolean; var priceDefault: Boolean)
    begin
        Get();
        resetPrice := "Reset Default Price/Discount";
        priceDefault := "Request Only Quantities" and "Reset Default Price/Discount";
    end;

    procedure isGlobalDim1(): Boolean
    var
        lRecGeneralLedgerSetup: Record "General Ledger Setup";
        ErrorDim_Err: Label 'Driver dimension must be a Global Dimensions!', comment = 'ITA="Dimensione driver deve essere una dimensione globale!"';
    begin
        Get();
        TestField("Driver Dimension Code");
        lRecGeneralLedgerSetup.Get();
        if lRecGeneralLedgerSetup."Global Dimension 1 Code" = "Driver Dimension Code" then
            exit(true);
        if lRecGeneralLedgerSetup."Global Dimension 2 Code" = "Driver Dimension Code" then
            exit(false);
        Error(ErrorDim_Err);
    end;

    procedure getRatingCaption(fieldId: Integer): Text[80]
    var
        lRecATCCPVendorRating: Record "ATC_CP_Vendor Rating";
    begin
        if not get() then begin
            Init();
            Insert();
        end;
        case fieldId of
            1:
                if lRecATCCPVendorRating.Get("First Vendor Rating") then
                    exit(lRecATCCPVendorRating.RatingLabel)
                else
                    exit('Vendor Rating 1');
            2:
                if lRecATCCPVendorRating.Get("Second Vendor Rating") then
                    exit(lRecATCCPVendorRating.RatingLabel)
                else
                    exit('Vendor Rating 2');
            3:
                if lRecATCCPVendorRating.Get("Third Vendor Rating") then
                    exit(lRecATCCPVendorRating.RatingLabel)
                else
                    exit('Vendor Rating 3');
        end;
    end;

    procedure CalcRatingVisibility(var Bln1st: Boolean; var Bln2nd: Boolean; var Bln3rd: Boolean)
    begin
        Get();
        Bln1st := "Enable Vendor Rating" and ("First Vendor Rating" <> '');
        Bln2nd := "Enable Vendor Rating" and ("Second Vendor Rating" <> '');
        Bln3rd := "Enable Vendor Rating" and ("Third Vendor Rating" <> '');
    end;

    procedure CheckRatingModify(RatingNo: Integer)
    var
        lRecPurchaseLine: Record "Purchase Line";
        lRecPurchRcptLine: Record "Purch. Rcpt. Line";
        Conf_Msg: Label 'By changing the setup or labels the previous associations (if present) could be no longer valid. How do you want to proceed?', comment = 'ITA="Cambiando il setup o etichette le precedenti associazioni (se presenti) potrebbero essere non più valide. Come si vuole procedere?"';
        ConfMenu_Msg: Label 'Proceed without updating, Delete previous rating, Cancel operation', comment = 'ITA="Procedi senza aggiornare le righe,Elimina rating precedente,Annulla operazione"';
        Selection: integer;
        Mess_Err: Label 'Operation canceled', comment = 'ITA="Operazione annullata"';
    begin

        Selection := StrMenu(ConfMenu_Msg, 1, Conf_Msg);
        case Selection of
            1:
                exit;
            0, 3:
                //begin
                Error(Mess_Err);
        //exit;
        //end;
        end;

        lRecPurchaseLine.Reset();
        lRecPurchRcptLine.Reset();
        case RatingNo of
            1:
                begin
                    lRecPurchaseLine.Setfilter("ATC_CP_1st Vendor Rating", '<>%1', lRecPurchaseLine."ATC_CP_1st Vendor Rating"::" ");
                    lRecPurchaseLine.ModifyAll("ATC_CP_1st Vendor Rating", lRecPurchaseLine."ATC_CP_1st Vendor Rating"::" ");
                    lRecPurchRcptLine.Setfilter("ATC_CP_1st Vendor Rating", '<>%1', lRecPurchRcptLine."ATC_CP_1st Vendor Rating"::" ");
                    lRecPurchRcptLine.ModifyAll("ATC_CP_1st Vendor Rating", lRecPurchRcptLine."ATC_CP_1st Vendor Rating"::" ");
                end;
            2:
                begin
                    lRecPurchaseLine.Setfilter("ATC_CP_2nd Vendor Rating", '<>%1', lRecPurchaseLine."ATC_CP_2nd Vendor Rating"::" ");
                    lRecPurchaseLine.ModifyAll("ATC_CP_2nd Vendor Rating", lRecPurchaseLine."ATC_CP_2nd Vendor Rating"::" ");
                    lRecPurchRcptLine.Setfilter("ATC_CP_2nd Vendor Rating", '<>%1', lRecPurchRcptLine."ATC_CP_2nd Vendor Rating"::" ");
                    lRecPurchRcptLine.ModifyAll("ATC_CP_2nd Vendor Rating", lRecPurchRcptLine."ATC_CP_2nd Vendor Rating"::" ");
                end;
            3:
                begin
                    lRecPurchaseLine.Setfilter("ATC_CP_3rd Vendor Rating", '<>%1', lRecPurchaseLine."ATC_CP_3rd Vendor Rating"::" ");
                    lRecPurchaseLine.ModifyAll("ATC_CP_3rd Vendor Rating", lRecPurchaseLine."ATC_CP_3rd Vendor Rating"::" ");
                    lRecPurchRcptLine.Setfilter("ATC_CP_3rd Vendor Rating", '<>%1', lRecPurchRcptLine."ATC_CP_3rd Vendor Rating"::" ");
                    lRecPurchRcptLine.ModifyAll("ATC_CP_3rd Vendor Rating", lRecPurchRcptLine."ATC_CP_3rd Vendor Rating"::" ");
                end;
        end;
    end;

    procedure VerifyLocationOnApproval(VarPurchaseHeader: Record "Purchase Header")
    var
        // lRecPurchaseLine: Record "Purchase Line";
        lRecATCCPExpenceType: Record "ATC_CP_Expence Type";
        lRecInventorySetup: Record "Inventory Setup";
    begin
        Get();
        if not lRecATCCPExpenceType.Get(VarPurchaseHeader."ATC_CP_Expense Type") then
            exit;
        if lRecATCCPExpenceType."Enable Purchase Requests On" = lRecATCCPExpenceType."Enable Purchase Requests On"::Item then begin
            lRecInventorySetup.Get();
            if lRecInventorySetup."Location Mandatory" then
                VarPurchaseHeader.TestField("Location Code");
        end;
    end;

    procedure VerifyAmountOnApproval(PARPurchaseHeader: Record "Purchase Header")
    var
        lRecPurchaseLine: Record "Purchase Line";
        Amount_Err: Label 'Amount is mandatory on every lines', comment = 'ITA="Specificare importo e quantità su tutte le righe"';
    begin
        lRecPurchaseLine.Reset();
        lRecPurchaseLine.setrange("Document Type", PARPurchaseHeader."Document Type");
        lRecPurchaseLine.SetRange("Document No.", PARPurchaseHeader."No.");
        lRecPurchaseLine.SetRange("Line Amount", 0);
        if not lRecPurchaseLine.IsEmpty() then
            Error(Amount_Err);
    end;

    procedure VerifySameDim(PurchaseHeader_Par: Record "Purchase Header")
    var
        lRecATCCPGeneralSetup: record "ATC_CP_General Setup";
        lRecPurchaseLine: Record "Purchase Line";
        Dim_Err: Label 'Dimension %1 is mandatory on every lines', comment = 'ITA="La dimemsione %1 deve essere valorizzata su tutte le righe!"';
        CheckDim1: Boolean;
        Value2Check: Code[20];
    begin
        if lRecATCCPGeneralSetup.isGlobalDim1() then begin
            CheckDim1 := true;
            if PurchaseHeader_Par."Shortcut Dimension 1 Code" = '' then
                exit
            else
                Value2Check := PurchaseHeader_Par."Shortcut Dimension 1 Code";
        end else begin
            CheckDim1 := false;
            if PurchaseHeader_Par."Shortcut Dimension 2 Code" = '' then
                exit
            else
                Value2Check := PurchaseHeader_Par."Shortcut Dimension 2 Code";
        end;

        lRecPurchaseLine.Reset();
        lRecPurchaseLine.setrange("Document Type", PurchaseHeader_Par."Document Type");
        lRecPurchaseLine.SetRange("Document No.", PurchaseHeader_Par."No.");
        if CheckDim1 then
            lRecPurchaseLine.SetFilter("Shortcut Dimension 1 Code", '<>%1&<>%2', Value2Check, '')
        else
            lRecPurchaseLine.SetFilter("Shortcut Dimension 2 Code", '<>%1&<>%2', Value2Check, '');
        if not lRecPurchaseLine.IsEmpty() then
            Error(Dim_Err, Value2Check);
    end;

    procedure VerifyNoOnApproval(PurchaseHeader_Par: Record "Purchase Header")
    var
        lRecPurchaseLine: Record "Purchase Line";
        No_Err: Label 'Field No. is mandatory on every lines', comment = 'ITA="Specificare il campo Nr. su tutte le righe"';
    begin
        lRecPurchaseLine.Reset();
        lRecPurchaseLine.SetRange("Document Type", PurchaseHeader_Par."Document Type");
        lRecPurchaseLine.SetRange("Document No.", PurchaseHeader_Par."No.");
        lRecPurchaseLine.SetFilter(Quantity, '<>%1', 0);
        lRecPurchaseLine.SetRange("No.", '');
        if not lRecPurchaseLine.IsEmpty() then
            Error(No_Err);
    end;

    procedure CalcReceiptVisib(): Boolean
    begin
        Get();
        exit("Aut. Purch. Rcpt. Batch. Post");
    end;
}

