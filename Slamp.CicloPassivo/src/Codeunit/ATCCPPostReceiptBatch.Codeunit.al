codeunit 90203 "ATC_CP_PostReceiptBatch"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
        LabelNameLbl: Label 'Parameter not valid', comment = 'ITA="Parametro non valido"';
    begin
        lRecATCCPGeneralSetup.get();
        case Rec."Parameter String" of
            lRecATCCPGeneralSetup.BatchPostReceiptParameter:
                PostReceiptBatch();
            lRecATCCPGeneralSetup.BatchUpdateOrderParameter:
                UpdatePurchaseOrder(false);
            lRecATCCPGeneralSetup.BatchPostUpdateParameter:
                begin
                    UpdatePurchaseOrder(false);
                    PostReceiptBatch();
                    UpdatePurchaseOrder(true);
                end;
            else
                error(LabelNameLbl);
        end;
    end;

    procedure UpdatePurchaseOrder(WithSleep: Boolean)
    var
        lRecPurchaseHeader: Record "Purchase Header";
        lRecUpd_PurchaseHeader: Record "Purchase Header";
        JobQueueEntry: Record "Job Queue Entry";
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin

        if not lRecATCCPGeneralSetup.Get() or not lRecATCCPGeneralSetup."Active Purchase Request" or not lRecATCCPGeneralSetup."Aut. Purch. Rcpt. Batch. Post" then
            exit;

        if WithSleep then
            Sleep((lRecATCCPGeneralSetup.DelayBatchUpdateOrder + glbCounter) * 1000);

        lRecPurchaseHeader.Reset();
        lRecPurchaseHeader.SetCurrentKey("ATC_CP_Purchase Request", ATC_CP_PostRecepitStatus);
        lRecPurchaseHeader.SetRange("ATC_CP_Purchase Request", true);
        lRecPurchaseHeader.SetRange(ATC_CP_PostRecepitStatus, lRecPurchaseHeader.ATC_CP_PostRecepitStatus::Processable);
        lRecPurchaseHeader.SetRange("Document Type", lRecPurchaseHeader."Document Type"::Order);
        lRecPurchaseHeader.SetRange(Status, lRecPurchaseHeader.Status::Released);
        lRecPurchaseHeader.SetFilter("Job Queue Status", '%1|%2', lRecPurchaseHeader."Job Queue Status"::Error, lRecPurchaseHeader."Job Queue Status"::" ");
        lRecPurchaseHeader.SetFilter("Job Queue Entry ID", '<>%1', '00000000-0000-0000-0000-000000000000');
        if lRecPurchaseHeader.FindSet() then
            repeat
                lRecUpd_PurchaseHeader.get(lRecPurchaseHeader.RecordId);
                lRecUpd_PurchaseHeader.LockTable();

                case lRecUpd_PurchaseHeader."Job Queue Status" of
                    lRecUpd_PurchaseHeader."Job Queue Status"::Error:

                        if JobQueueEntry.get(lRecUpd_PurchaseHeader."Job Queue Entry ID") then begin
                            lRecUpd_PurchaseHeader.ATC_CP_SetReceiptError(JobQueueEntry."Error Message");
                            JobQueueEntry.Delete(true);
                            lRecUpd_PurchaseHeader.ATC_CP_PostRecepitStatus := lRecUpd_PurchaseHeader.ATC_CP_PostRecepitStatus::PostingError;
                        end;

                    lRecUpd_PurchaseHeader."Job Queue Status"::" ":
                        begin
                            lRecUpd_PurchaseHeader.ATC_CP_SetReceiptError(Format(lRecUpd_PurchaseHeader.ATC_CP_PostRecepitStatus::ReceiptPosted));
                            lRecUpd_PurchaseHeader.ATC_CP_PostRecepitStatus := lRecUpd_PurchaseHeader.ATC_CP_PostRecepitStatus::ReceiptPosted;
                            lRecUpd_PurchaseHeader."Job Queue Entry ID" := '00000000-0000-0000-0000-000000000000';
                        end;
                end;
                lRecUpd_PurchaseHeader.Modify();
                Commit();
            until lRecPurchaseHeader.Next() = 0;
    end;

    procedure PostReceiptBatch()
    var
        lRecPurchaseHeader: Record "Purchase Header";
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
        lCuPurchasePostviaJobQueue: Codeunit "Purchase Post via Job Queue";
    begin
        if not lRecATCCPGeneralSetup.Get() or not lRecATCCPGeneralSetup."Active Purchase Request" or not lRecATCCPGeneralSetup."Aut. Purch. Rcpt. Batch. Post" then
            exit;

        glbCounter := 0;
        lRecPurchaseHeader.Reset();
        lRecPurchaseHeader.SetCurrentKey("ATC_CP_Purchase Request", ATC_CP_PostRecepitStatus);
        lRecPurchaseHeader.SetRange("ATC_CP_Purchase Request", true);
        lRecPurchaseHeader.SetRange(ATC_CP_PostRecepitStatus, lRecPurchaseHeader.ATC_CP_PostRecepitStatus::Processable);
        lRecPurchaseHeader.SetRange("Document Type", lRecPurchaseHeader."Document Type"::Order);
        lRecPurchaseHeader.SetRange(Status, lRecPurchaseHeader.Status::Released);
        lRecPurchaseHeader.Setfilter("Job Queue Status", '<>%1', lRecPurchaseHeader."Job Queue Status"::"Scheduled for Posting");
        if lRecPurchaseHeader.FindSet() then
            repeat
                lRecPurchaseHeader.Receive := true;
                lRecPurchaseHeader.Modify();
                lCuPurchasePostviaJobQueue.EnqueuePurchDoc(lRecPurchaseHeader);
                Commit();
                glbCounter += 1;
            until lRecPurchaseHeader.Next() = 0;
    end;

    var
        glbCounter: Integer;
}
