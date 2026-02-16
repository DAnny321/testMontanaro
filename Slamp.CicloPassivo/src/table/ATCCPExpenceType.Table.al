table 90204 "ATC_CP_Expence Type"
{



    Caption = 'Purchase Request Type',
                comment = 'ITA="Tipologie richieste di acquisto"';
    LookupPageID = "ATC_CP_Type List";
    DrillDownPageId = "ATC_CP_Type List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code',
                        comment = 'ITA="Codice"';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description',
                        comment = 'ITA="Descrizione"';
            DataClassification = CustomerContent;
        }
        field(20; "Enable Purchase Requests On"; Enum "ATC_CP_Type Selection")
        {
            Caption = 'Enable Purchase Requests On', comment = 'ITA="Abilita richieste di acquisto su"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckPR();
            end;
        }
        field(30; "Default Value"; Code[20])
        {
            Caption = 'Default Value', comment = 'ITA="Valore di default"';
            DataClassification = CustomerContent;
            TableRelation = if ("Enable Purchase Requests On" = const("G/L Account")) "G/L Account" WHERE("Direct Posting" = CONST(true),
                                                                                               "Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false), "ATC_CP_Enable Purchase Request" = const(true))
            ELSE
            IF ("Enable Purchase Requests On" = CONST(Item)) Item where(Blocked = const(false), "Purchasing Blocked" = const(false), "ATC_CP_Enable Purchase Request" = const(true));

            trigger OnValidate()
            var
                GeneralSetup: Record "ATC_CP_General Setup";
            begin
                if "Default Value" = '' then
                    "Default Value Modifiable" := false
                else begin
                    GeneralSetup.Get();
                    GeneralSetup.TestField("Active Driver-Hierarchy Assoc.", false);
                end;
                CheckPR();

            end;
        }
        field(40; "Default Value Modifiable"; Boolean)
        {
            Caption = 'Default Value Modifiable', comment = 'ITA="Valore di default modificabile"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("Default Value");
                CheckPR();
            end;

        }

        field(60; "Active Mandatory Dim. Checks"; Boolean)
        {
            Caption = 'Active Mandatory Dim. Checks Lines on Send to Approval',
                        comment = 'ITA="Attiva controlli obbligatori dimensioni su righe all'' invio in approvazione"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                MandatoryDim: Record "ATC_CP_Mandatory Dimensions";
            begin
                if "Active Mandatory Dim. Checks" then
                    exit;

                MandatoryDim.Reset();
                MandatoryDim.SetRange("Expence Type", Rec.Code);
                MandatoryDim.DeleteAll();
            end;
        }
        field(61; "Exists Dim. Mandatory Setup"; Boolean)
        {
            Caption = 'Exists Dimension Mandatory Setup',
                        comment = 'ITA="Esistono setup per obbligatorietà dimensioni"';

            FieldClass = FlowField;
            CalcFormula = exist("ATC_CP_Mandatory Dimensions" where("Expence Type" = field(Code)));
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(FG1; Code, Description)
        { }
    }

    trigger OnDelete()
    begin
        CheckPR();
    end;

    procedure CheckPR()
    var
        lRecPurchaseHeader: record "Purchase Header";
        IsnotEmpty_Err: Label 'It is not possible modify record: there are purchase request with this type. Delete or transform it on order before applyng modifies.', comment = 'ITA="Impossibile procedere: ci sono richieste di acquisto con questa tipologia. Cancellarle o trasformarle in ordine prima di applicare la modifica."';
    begin
        lRecPurchaseHeader.Reset();
        lRecPurchaseHeader.SetRange("Document Type", lRecPurchaseHeader."Document Type"::Quote);
        lRecPurchaseHeader.SetRange("ATC_CP_Expense Type", Rec.Code);
        if not lRecPurchaseHeader.IsEmpty then
            Error(IsnotEmpty_Err);
    end;


    procedure VerifyDimOnApproval(PurchaseHeader: Record "Purchase Header")
    var
        lRecPr_ATCCPGeneralSetup: Record "ATC_CP_General Setup";
        lRecPurchaseLine: Record "Purchase Line";
        lRecATCCPMandatoryDimensions: Record "ATC_CP_Mandatory Dimensions";
        lRecDimensionSetEntry: Record "Dimension Set Entry";
        DimError_Msg: Label 'Dimension Code %1 is mandatory for approval request on record: %2', comment = 'ITA="Dimesione %1 è obbligatoria per l''invio in approvazione in riga %2"';
    begin
        if not lRecPr_ATCCPGeneralSetup.isActiveCheck() then
            exit;
        if not Get(PurchaseHeader."ATC_CP_Expense Type") then
            exit;
        if not "Active Mandatory Dim. Checks" then
            exit;

        CalcFields("Exists Dim. Mandatory Setup");
        if not "Exists Dim. Mandatory Setup" then
            exit;

        lRecPurchaseLine.Reset();
        lRecPurchaseLine.setrange("Document Type", PurchaseHeader."Document Type");
        lRecPurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if lRecPurchaseLine.FindSet() then
            repeat
                lRecATCCPMandatoryDimensions.Reset();
                lRecATCCPMandatoryDimensions.SetRange("Expence Type", Rec.Code);
                if lRecATCCPMandatoryDimensions.FindSet() then
                    repeat
                        lRecDimensionSetEntry.Reset();
                        lRecDimensionSetEntry.SetRange("Dimension Set ID", lRecPurchaseLine."Dimension Set ID");
                        lRecDimensionSetEntry.SetRange("Dimension Code", lRecATCCPMandatoryDimensions."Dimension Code");
                        if lRecDimensionSetEntry.IsEmpty then
                            Error(DimError_Msg, lRecATCCPMandatoryDimensions."Dimension Code", lRecPurchaseLine.RecordId);
                    until lRecATCCPMandatoryDimensions.Next() = 0;
            until lRecPurchaseLine.Next() = 0;
    end;


    var
    //gRecExtendedTextHeader: Record "Extended Text Header";
}

