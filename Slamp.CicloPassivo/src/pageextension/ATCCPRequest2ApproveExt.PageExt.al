pageextension 90212 "ATC_CP_Request2ApproveExt" extends "Requests to Approve"
{
    layout
    {
        addlast(Control1)
        {
            field(ATC_CP_CalcExpType; gRecPurchaseHeader."ATC_CP_Expense Type")
            {
                Caption = 'Purch. Document Expence Type', comment = 'ITA="Tipologia di spesa documento acquisti"';
                ApplicationArea = All;
                ToolTip = 'Purch. Document Expence Type', comment = 'ITA="Tipologia di spesa documento acquisti"';
                Visible = isVisible;
            }
            field(ATC_CP_CalcPriority; gRecPurchaseHeader."ATC_CP_Request Priority")
            {
                Caption = 'Purch. Document Priority', comment = 'ITA="Priorità documento acquisti"';
                ApplicationArea = All;
                ToolTip = 'Purch. Document Priority', comment = 'ITA="Priorità documento acquisti"';
                Visible = isVisible;
            }
            field(ATC_CP_workdescription; gRecPurchaseHeader.ATC_CP_GetWorkDescription())
            {
                Caption = 'Additional Description', comment = 'ITA="Informazioni aggiuntive"';
                ApplicationArea = All;
                ToolTip = 'Additional Description', comment = 'ITA="Informazioni aggiuntive"';
            }
            field(ATC_CP_OriginalQuote; gRecPurchaseHeader."Quote No.")
            {
                Caption = 'Create from Quote No.', comment = 'ITA="Creato da offerta nr."';
                ApplicationArea = All;
                ToolTip = 'Create from Quote No.', comment = 'ITA="Creato da offerta nr."';
            }
        }
    }

    trigger OnOpenPage()
    begin
        isVisible := gRecATCCPGeneralSetup.isActiveCheck();
    end;

    trigger OnAfterGetRecord()
    begin
        ATC_CP_GetPurchTable();
    end;

    procedure ATC_CP_GetPurchTable()
    begin
        if Rec."Table ID" <> 38 then
            exit;
        if not gRecPurchaseHeader.get(rec."Record ID to Approve") then
            gRecPurchaseHeader.init();
    end;

    var
        gRecPurchaseHeader: record "Purchase Header";
        gRecATCCPGeneralSetup: record "ATC_CP_General Setup";
        isVisible: Boolean;
}