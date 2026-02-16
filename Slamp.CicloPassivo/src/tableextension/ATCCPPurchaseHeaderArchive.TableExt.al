tableextension 90209 "ATC_CP_Purchase Header Archive" extends "Purchase Header Archive"
{

    fields
    {

        field(90200; "ATC_CP_Purchase Request"; Boolean)
        {
            Caption = 'Purchase Request', comment = 'ITA="Richiesta di acquisto"';
            DataClassification = CustomerContent;
        }
        field(90201; "ATC_CP_User Request"; Code[50])
        {
            Caption = 'PR User Request', comment = 'ITA="Richiedente"';
            TableRelation = "User Setup"."User ID";
            DataClassification = CustomerContent;
        }
        field(90202; "ATC_CP_Request on Behalf of"; Text[100])
        {
            Caption = 'PR Request on Behalf of', comment = 'ITA="Richiesta per conto di"';
            DataClassification = CustomerContent;
        }
        field(90203; "ATC_CP_Request Description"; Text[100])
        {
            Caption = 'Request Description', comment = 'ITA="Descrizione richiesta"';
            DataClassification = CustomerContent;

        }
        field(90204; "ATC_CP_Creation Date"; Date)
        {
            Caption = 'PR Creation Date', comment = 'ITA="Data creazione"';
            DataClassification = CustomerContent;
        }
        field(90205; "ATC_CP_Creation Time"; Time)
        {
            Caption = 'PR Creation Time', comment = 'ITA="Ora creazione"';
            DataClassification = CustomerContent;

        }
        field(90206; "ATC_CP_Create Order Vendor No."; Code[20])
        {
            Caption = 'PR Create Order on Vendor No.', comment = 'ITA="Crea ordine su nr. fornitore"';
            TableRelation = Vendor."No.";
            DataClassification = CustomerContent;
        }
        field(90207; "ATC_CP_Create Order Vend. Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("ATC_CP_Create Order Vendor No.")));
            Caption = 'PR Create Order on Vendor Name', comment = 'ITA="Crea ordine su nome fornitore"';

        }
        field(90208; "ATC_CP_Request Additional Info"; Media)
        {
            Caption = 'PR Request Additional Info', comment = 'ITA="Informazioni aggiuntive richiesta"';
            DataClassification = CustomerContent;

        }
        field(90209; "ATC_CP_Expense Type"; Code[20])
        {
            Caption = 'Expense Type', comment = 'ITA="Tipo di spesa"';
            TableRelation = "ATC_CP_Expence Type".Code;
            DataClassification = CustomerContent;
        }
        field(90210; "ATC_CP_Request Template"; Boolean)
        {
            Caption = 'Request Template', comment = 'ITA="Template richiesta di acquisto"';
            DataClassification = CustomerContent;
        }
        field(90211; "ATC_CP_Exists Suggest Vendors"; Boolean)
        {
            Caption = 'Exist Suggest Vendors', comment = 'ITA="Esistono fornitori suggeriti"';
            FieldClass = FlowField;
            CalcFormula = exist("ATC_CP_Suggest Vendor" where("Purchase Request No." = field("No.")));
        }

        field(90212; "ATC_CP_Expence Category"; Code[20])
        {
            TableRelation = "ATC_CP_Expence Category".Code;
            Caption = 'Expence Category Code', comment = 'ITA="Codice categoria di spesa"';
            DataClassification = CustomerContent;
        }
        field(90213; "ATC_CP_Expence SubCategory"; Code[20])
        {
            TableRelation = "ATC_CP_Expence SubCategory".Code where("Category Code" = field("ATC_CP_Expence Category"));
            Caption = 'Expence SubCategory', comment = 'ITA="Codice sottocategoria di spesa"';
            DataClassification = CustomerContent;
        }
        field(90214; "ATC_CP_Expence Details"; Code[20])
        {
            TableRelation = "ATC_CP_Expence Details".Code where("Category Code" = field("ATC_CP_Expence Category"), "SubCategory Code" = field("ATC_CP_Expence SubCategory"));
            Caption = 'Expence Details', comment = 'ITA="Codice dettaglio di spesa"';
            DataClassification = CustomerContent;
        }

        field(90215; "ATC_CP_Glob. Dim. 1"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(90216; "ATC_CP_Glob. Dim. 2"; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(90217; "ATC_CP_Request Priority"; Enum ATC_CP_Priority)
        {
            Caption = 'Request Priority', comment = 'ITA="Priorità richiesta"';
            DataClassification = CustomerContent;
        }

        field(90218; "ATC_CP_Last Modifier User"; Code[50])
        {
            Caption = 'Last Modifier User', comment = 'ITA="Utente ultima modifica"';
            TableRelation = "User Setup"."User ID";
            DataClassification = CustomerContent;
        }
        field(90219; "ATC_CP_Last Modifier DateTime"; DateTime)
        {
            Caption = 'Last Modifier DateTime', comment = 'ITA="Data-ora ultima modifica"';
            TableRelation = "User Setup"."User ID";
            DataClassification = CustomerContent;
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

    }

    keys
    {
        key(PR_RequestUser; "ATC_CP_User Request")
        {
        }

        key(PR_PurchaseRequest; "ATC_CP_Purchase Request")
        {
        }

        key(PR_Dim1; "ATC_CP_Glob. Dim. 1", "ATC_CP_User Request")
        {

        }
        key(PR_Dim2; "ATC_CP_Glob. Dim. 2", "ATC_CP_User Request")
        {

        }
    }

    procedure ATC_CP_setPurchaseRequestFilter()
    var
        lRecUserSetup: Record "User Setup";
        //lRecATCCPDimensionUserRole: Record "ATC_CP_Dimension User Role";
        lRecPr_ATCCPGeneralSetup: Record "ATC_CP_General Setup";
        lLogin_Err: Label 'User is not configured for access to purchase order/request.', comment = 'ITA="Utente non configurato per accesso alle richieste e ordini di acquisto"';
    begin
        if not lRecPr_ATCCPGeneralSetup.isActiveCheck() then
            exit;
        lRecUserSetup.Get(UserId);
        if (lRecUserSetup."ATC_CP_User Role" = lRecUserSetup."ATC_CP_User Role"::Administration) or (lRecUserSetup."ATC_CP_User Role" = lRecUserSetup."ATC_CP_User Role"::"Purchase Office") then
            exit;
        Temp_gRecAccountUseBuffer.DeleteAll();
        Clear(isGlobalDim1);
        isGlobalDim1 := lRecPr_ATCCPGeneralSetup.isGlobalDim1();
        isValidUser := false;
        ATC_CP_CreatePurchaseFilter(lRecUserSetup."ATC_CP_User Group");
        if not isValidUser then
            Error(lLogin_Err);
    end;


    protected procedure ATC_CP_CreatePurchaseFilter(groupID: Code[50])
    begin
        FilterGroup(8);
        ATC_CP_FilterByUser();
        ATC_CP_FilterByGroup(groupID);
        ATC_CP_ResetFilter();
        MarkedOnly(true);
        FilterGroup(0);
        SetCurrentKey("No.");

    end;

    protected procedure ATC_CP_MarkHeader()
    begin
        if FindSet() then
            repeat
                Mark(true);
            until Next() = 0;
    end;

    protected procedure ATC_CP_FilterByUser()
    begin
        ATC_CP_SetFilterDimUserRole4User();
        if gRecATCCPDimensionUserRole.FindSet() then begin
            isValidUser := true;
            repeat
                if ATC_CP_processDim() then begin
                    if gRecATCCPDimensionUserRole.Role = gRecATCCPDimensionUserRole.Role::Requester then
                        ATC_CP_filterDimension(true)
                    else
                        ATC_CP_filterDimension(false);
                    ATC_CP_MarkHeader();
                end;
            until gRecATCCPDimensionUserRole.Next() = 0;

        end;
    end;

    protected procedure ATC_CP_processDim(): Boolean
    begin
        if not Temp_gRecAccountUseBuffer.Get(gRecATCCPDimensionUserRole.Code) then begin
            Temp_gRecAccountUseBuffer."Account No." := gRecATCCPDimensionUserRole.Code;
            Temp_gRecAccountUseBuffer.Insert();
            exit(true);
        end else
            exit(false);
    end;

    protected procedure ATC_CP_SetFilterDimUserRole4User()
    begin
        //with DimUserRole do begin
        gRecATCCPDimensionUserRole.SetCurrentKey(Type, "User Id");
        gRecATCCPDimensionUserRole.SetRange(Type, gRecATCCPDimensionUserRole.Type::User);
        gRecATCCPDimensionUserRole.SetFilter("User Id", UserId);
        //end;
    end;

    protected procedure ATC_CP_SetFilterDimUserRole4Group(groupID: Code[50])
    begin
        //with DimUserRole do begin
        gRecATCCPDimensionUserRole.SetCurrentKey(Type, "User Id");
        gRecATCCPDimensionUserRole.SetRange(Type, gRecATCCPDimensionUserRole.Type::UserGroup);
        gRecATCCPDimensionUserRole.SetFilter("User Id", groupID);
        //end;
    end;

    protected procedure ATC_CP_filterByGroup(groupID: Code[50])
    begin
        ATC_CP_SetFilterDimUserRole4Group(groupID);
        if gRecATCCPDimensionUserRole.FindSet() then begin
            isValidUser := true;
            repeat
                if ATC_CP_processDim() then
                    if gRecATCCPDimensionUserRole.Role = gRecATCCPDimensionUserRole.Role::Requester then
                        ATC_CP_filterDimension(true)
                    else
                        ATC_CP_filterDimension(false);
            until gRecATCCPDimensionUserRole.Next() = 0;
            ATC_CP_MarkHeader();
        end;
    end;

    protected procedure ATC_CP_filterDimension(isRequester: Boolean)
    begin

        if isGlobalDim1 then begin
            SetCurrentKey("ATC_CP_Glob. Dim. 1", "ATC_CP_User Request");
            if isRequester then begin
                SetFilter("ATC_CP_Glob. Dim. 1", '%1|%2', gRecATCCPDimensionUserRole.Code, '');
                SetRange("ATC_CP_User Request", UserId);
            end else
                setrange("ATC_CP_Glob. Dim. 1", gRecATCCPDimensionUserRole.Code);
        end else begin
            SetCurrentKey("ATC_CP_Glob. Dim. 2", "ATC_CP_User Request");
            if isRequester then begin
                SetFilter("ATC_CP_Glob. Dim. 2", '%1|%2', gRecATCCPDimensionUserRole.Code, '');
                SetRange("ATC_CP_User Request", UserId);
            end else
                setrange("ATC_CP_Glob. Dim. 2", gRecATCCPDimensionUserRole.Code)
        end;
    end;

    protected procedure ATC_CP_ResetFilter()
    begin
        SetRange("ATC_CP_Glob. Dim. 1");
        SetRange("ATC_CP_Glob. Dim. 2");
        SetRange("ATC_CP_User Request");
    end;

    var
        gRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
        gRecATCCPDimensionUserRole: Record "ATC_CP_Dimension User Role";
        Temp_gRecAccountUseBuffer: Record "Account Use Buffer" temporary;
        isGlobalDim1: Boolean;
        isValidUser: Boolean;
}

