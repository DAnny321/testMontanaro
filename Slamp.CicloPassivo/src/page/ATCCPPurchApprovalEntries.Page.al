page 90229 "ATC_CP_Purch. Approval Entries"
{
    ApplicationArea = All;
    Caption = 'Purch. Approval Entries', Comment = 'ITA="Movimenti approvazione ciclo acquisti"';
    Editable = false;
    PageType = List;
    SourceTable = "Approval Entry";
    SourceTableView = SORTING("Table ID", "Document Type", "Document No.", "Date-Time Sent for Approval")
                      ORDER(Ascending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Overdue; Overdue)
                {
                    ApplicationArea = All;
                    OptionCaption = 'Yes," "', Comment = 'ITA="Si, "';
                    Caption = 'Overdue', Comment = 'ITA="Scaduto"';
                    Editable = false;
                    ToolTip = 'Specifies that the approval is overdue.', Comment = 'ITA="Specifica che il movimento è scaduto"';
                }
                field("Limit Type"; Rec."Limit Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Limit Type', Comment = 'ITA="SPecifica tipologia limite"';
                }
                field("Approval Type"; Rec."Approval Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Approval Type', Comment = 'ITA="Specifica tipologia approvazione"';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Document Type', Comment = 'ITA="Specifica tipo documento"';
                    Visible = true;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = '"Document No."', Comment = 'ITA="Specifica nr. documento"';
                    Visible = true;
                }
                field(RecordIDText; RecordIDText)
                {
                    ApplicationArea = All;
                    ToolTip = 'To Approve', Comment = 'ITA="Record da approvare"';
                    Caption = 'To Approve', Comment = 'ITA="Record da approvare"';
                }
                field(Details; Rec.RecordDetails())
                {
                    ApplicationArea = All;
                    ToolTip = 'Details', Comment = 'ITA="Dettagli"';
                    Caption = 'Details', Comment = 'ITA="Dettagli"';
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sequence No.', Comment = 'ITA="Specifica nr. sequenza"';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Status', Comment = 'ITA="Specifica stato"';
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sender ID', Comment = 'ITA="Specifica ID mittente"';

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation(Rec."Sender ID");
                    end;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line',
                    Comment = 'ITA="Specifica il codice relativo all''agente o all''addetto acquisti collegato alla vendita o all''acquisto specificato nella riga di registrazione"';
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Approver ID', Comment = 'ITA="Specifica ID approvatore"';

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation(Rec."Approver ID");
                    end;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Currency Code', Comment = 'ITA="Specifica codice valuta"';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount', Comment = 'ITA="Specifica l''importo"';
                }
                field("Available Credit Limit (LCY)"; Rec."Available Credit Limit (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remaining credit (in LCY)', Comment = 'ITA="Specifica il credito residuo, espresso nella valuta locale"';
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Date-Time Sent for Approval', Comment = 'ITA="Specifica Data-Ora invio per approvazione"';
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Last Date-Time Modified', Comment = 'ITA="Specifica l''ultima data e orario di modifica"';
                }
                field("Last Modified By User ID"; Rec."Last Modified By User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Last Modified By User ID', Comment = 'ITA="Specifica quale ID utente ha fatto l''ultima modifica"';

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation(Rec."Last Modified By User ID");
                    end;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the comment', Comment = 'ITA="Specifica il commento"';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies due Date', Comment = 'ITA="Specifica data di scadenza"';
                }
                field(ExpType; gRecPurchaseHeader."ATC_CP_Expense Type")
                {
                    Caption = 'Purch. Document Expence Type', comment = 'ITA="Tipologia di spesa documento acquisti"';
                    ApplicationArea = All;
                    ToolTip = 'Purch. Document Expence Type', comment = 'ITA="Tipologia di spesa documento acquisti"';
                }
                field(Priority; gRecPurchaseHeader."ATC_CP_Request Priority")
                {
                    Caption = 'Purch. Document Priority', comment = 'ITA="Priorità documento acquisti"';
                    ApplicationArea = All;
                    ToolTip = 'Purch. Document Priority', comment = 'ITA="Priorità documento acquisti"';
                }
                field(workdescription; gRecPurchaseHeader.ATC_CP_GetWorkDescription())
                {
                    Caption = 'Additional Description', comment = 'ITA="Informazioni aggiuntive"';
                    ApplicationArea = All;
                    ToolTip = 'Additional Description', comment = 'ITA="Informazioni aggiuntive"';
                }
                field(OriginalQuote; gRecPurchaseHeader."Quote No.")
                {
                    Caption = 'Create from Quote No.', comment = 'ITA="Creato da offerta nr."';
                    ApplicationArea = All;
                    ToolTip = 'Create from Quote No.', comment = 'ITA="Creato da offerta nr."';
                }
            }
        }
        area(factboxes)
        {
            part(Change; "Workflow Change List FactBox")
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                UpdatePropagation = SubPart;
                Visible = ShowChangeFactBox;
            }
            systempart(Control5; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control4; Notes)
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Show")
            {
                Caption = '&Show', Comment = 'ITA="Mostra"';
                Image = View;
                action("Record")
                {
                    ApplicationArea = All;
                    ToolTip = 'Record', Comment = 'ITA="Record"';
                    Caption = 'Record', Comment = 'ITA="Record"';
                    Enabled = ShowRecCommentsEnabled;
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.ShowRecord();
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = All;
                    ToolTip = 'Comments', Comment = 'ITA="Commenti"';
                    Caption = 'Comments', Comment = 'ITA="Commenti"';
                    Enabled = ShowRecCommentsEnabled;
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        RecRef: RecordRef;
                    begin
                        RecRef.Get(Rec."Record ID to Approve");
                        Clear(ApprovalsMgmt);
                        ApprovalsMgmt.GetApprovalCommentForWorkflowStepInstanceID(RecRef, Rec."Workflow Step Instance ID");
                    end;
                }
                action("O&verdue Entries")
                {
                    ApplicationArea = All;
                    ToolTip = 'O&verdue Entries', Comment = 'ITA="Movimenti scaduti"';
                    Caption = 'O&verdue Entries', Comment = 'ITA="Movimenti scaduti"';
                    Image = OverdueEntries;

                    trigger OnAction()
                    begin
                        Rec.SetFilter(Status, '%1|%2', Rec.Status::Created, Rec.Status::Open);
                        Rec.SetFilter("Due Date", '<%1', Today);
                    end;
                }
                action("All Entries")
                {
                    ApplicationArea = All;
                    ToolTip = 'All Entries', Comment = 'ITA="Tutti i movimenti"';
                    Caption = 'All Entries', Comment = 'ITA="Tutti i movimenti"';
                    Image = Entries;

                    trigger OnAction()
                    begin
                        Rec.SetRange(Status);
                        Rec.SetRange("Due Date");
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Delegate")
            {
                PromotedOnly = true;
                ApplicationArea = All;
                ToolTip = '&Delegate', Comment = 'ITA="Delegato"';
                Caption = '&Delegate', Comment = 'ITA="Delegato"';
                Enabled = DelegateEnable;
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    CurrPage.SetSelectionFilter(ApprovalEntry);
                    ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        lRecordRef: RecordRef;
    begin
        ShowChangeFactBox := CurrPage.Change.PAGE.SetFilterFromApprovalEntry(Rec);
        DelegateEnable := Rec.CanCurrentUserEdit();
        ShowRecCommentsEnabled := lRecordRef.Get(Rec."Record ID to Approve");
    end;

    trigger OnAfterGetRecord()
    begin
        Overdue := Overdue::" ";
        if FormatField(Rec) then
            Overdue := Overdue::Yes;

        RecordIDText := Format(Rec."Record ID to Approve", 0, 1);
        GetPurchTable();
    end;

    procedure GetPurchTable()
    begin
        if Rec."Table ID" <> 38 then
            exit;
        if not gRecPurchaseHeader.get(rec."Record ID to Approve") then
            gRecPurchaseHeader.init();
    end;

    trigger OnOpenPage()
    var
        lRecGeneralLedgerSetup: record "General Ledger Setup";
        // DimUserAss: record "ATC_CP_Dimension User Role";
        PurchaseHeader: record "Purchase Header";
        MovAppToFilter_ApprovalEntry: record "Approval Entry";
    // LastRecID: recordid;
    // isValid: Boolean;        
    // isGlobal1: Boolean;
    begin
        gRecPr_ATCCPGeneralSetup.isActiveError();
        lRecGeneralLedgerSetup.get();
        //isGlobal1 := prSetup.isGlobalDim1();
        userSetup.Get(UserId);
        Rec.RESET();
        Rec.FilterGroup(8);
        Rec.SetRange("Table ID", 38);
        if userSetup."ATC_CP_User Role" <> userSetup."ATC_CP_User Role"::" " then
            Rec.FilterGroup(0)
        else begin
            /*
            DimUserAss.Reset();
            if isGlobal1 then
                DimUserAss.SetRange("Dimension Code",GenSetup."Shortcut Dimension 1 Code")
            else
                DimUserAss.SetRange("Dimension Code",GenSetup."Shortcut Dimension 2 Code");
            DimUserAss.setrange(Role,DimUserAss.Role::Requester);
            DimUserAss.SetRange("User Id",UserId);
            */
            PurchaseHeader.Reset();
            PurchaseHeader.SetFilter("Document Type", '%1|%2', PurchaseHeader."Document Type"::Quote, PurchaseHeader."Document Type"::Order);
            PurchaseHeader.ATC_CP_setPurchaseRequestFilter();
            if PurchaseHeader.FindSet() then
                repeat
                    MovAppToFilter_ApprovalEntry.SetRange("Record ID to Approve", PurchaseHeader.RecordId);
                    if MovAppToFilter_ApprovalEntry.FindSet() then
                        repeat
                            Rec.Get(MovAppToFilter_ApprovalEntry."Entry No.");
                            Rec.Mark(true);
                        until MovAppToFilter_ApprovalEntry.Next() = 0;
                until PurchaseHeader.Next() = 0;
            Rec.MarkedOnly(true);
            Rec.FilterGroup(0);
        end;
    end;



    procedure Setfilters(TableId: Integer; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20])
    begin
        if TableId <> 0 then begin
            Rec.FilterGroup(2);
            Rec.SetCurrentKey("Table ID", "Document Type", "Document No.", "Date-Time Sent for Approval");
            Rec.SetRange("Table ID", TableId);
            Rec.SetRange("Document Type", DocumentType);
            if DocumentNo <> '' then
                Rec.SetRange("Document No.", DocumentNo);
            Rec.FilterGroup(0);
        end;
    end;

    local procedure FormatField(ApprovalEntry: Record "Approval Entry"): Boolean
    begin
        if Rec.Status in [Rec.Status::Created, Rec.Status::Open] then begin
            if ApprovalEntry."Due Date" < Today then
                exit(true);

            exit(false);
        end;
    end;
    /*
        local procedure checkIsValid(RecordIDtoApprove: RecordId; useGlobal1: Boolean): Boolean
        var
            lrecPurchaseHeader: record "Purchase Header";
            // lRecATCCPGeneralSetup: record "ATC_CP_General Setup";
            lRecATCCPDimensionUserRole: record "ATC_CP_Dimension User Role";
            dim2Check: Code[20];
        begin
            lrecPurchaseHeader.get(RecordIDtoApprove);
            if useGlobal1 then
                dim2Check := lrecPurchaseHeader."Shortcut Dimension 1 Code"
            else
                dim2Check := lrecPurchaseHeader."Shortcut Dimension 2 Code";
            lRecATCCPDimensionUserRole.Reset();
        end;
        */

    procedure CalledFrom()
    begin
        Overdue := Overdue::" ";
    end;

    var
        gRecPr_ATCCPGeneralSetup: record "ATC_CP_General Setup";
        userSetup: record "User Setup";
        // gRecApprovalEntry: record "Approval Entry";
        gRecPurchaseHeader: record "Purchase Header";
        Overdue: Option Yes," ";
        RecordIDText: Text;
        ShowChangeFactBox: Boolean;
        DelegateEnable: Boolean;
        ShowRecCommentsEnabled: Boolean;
    // IsVisible: Boolean;
}

