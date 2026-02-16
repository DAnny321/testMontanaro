tableextension 90211 "ATC_CP_Whse Receipt Hdr" extends "Warehouse Receipt Header"
{
    fields
    {
        field(90220; "ATC_CP_1st Vendor Rating"; Enum "ATC_CP_Vendor Rating")
        {
            CaptionClass = gRecATCCPGeneralSetup.getRatingCaption(1);
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                WarehouseReceiptLine: Record "Warehouse Receipt Line";
                lConfirm_Msg: Label 'Do you want to update lines with header value?', comment = 'ITA="Aggiornare le righe con il valore di testata?"';
            begin
                WarehouseReceiptLine.Reset();
                WarehouseReceiptLine.SetRange("No.", Rec."No.");
                WarehouseReceiptLine.SetFilter(WarehouseReceiptLine."Qty. to Receive", '<>%1', 0);
                if WarehouseReceiptLine.FindSet() then
                    if Confirm(lConfirm_Msg) then
                        repeat
                            WarehouseReceiptLine.Validate("ATC_CP_1st Vendor Rating", Rec."ATC_CP_1st Vendor Rating");
                            WarehouseReceiptLine.Modify();
                        until WarehouseReceiptLine.Next() = 0;
            end;
        }

        field(90221; "ATC_CP_2nd Vendor Rating"; Enum "ATC_CP_Vendor Rating")
        {
            CaptionClass = gRecATCCPGeneralSetup.getRatingCaption(2);
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                WarehouseReceiptLine: Record "Warehouse Receipt Line";
                lConfirm_Msg: Label 'Do you want to update lines with header value?', comment = 'ITA="Aggiornare le righe con il valore di testata?"';
            begin
                WarehouseReceiptLine.Reset();
                WarehouseReceiptLine.SetRange("No.", Rec."No.");
                WarehouseReceiptLine.SetFilter(WarehouseReceiptLine."Qty. to Receive", '<>%1', 0);
                if WarehouseReceiptLine.FindSet() then
                    if Confirm(lConfirm_Msg) then
                        repeat
                            WarehouseReceiptLine.Validate("ATC_CP_2nd Vendor Rating", Rec."ATC_CP_2nd Vendor Rating");
                            WarehouseReceiptLine.Modify();
                        until WarehouseReceiptLine.Next() = 0;
            end;
        }

        field(90222; "ATC_CP_3rd Vendor Rating"; Enum "ATC_CP_Vendor Rating")
        {
            CaptionClass = gRecATCCPGeneralSetup.getRatingCaption(3);
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                WarehouseReceiptLine: Record "Warehouse Receipt Line";
                Confirm_Msg: Label 'Do you want to update lines with header value?', comment = 'ITA="Aggiornare le righe con il valore di testata?"';
            begin
                WarehouseReceiptLine.Reset();
                WarehouseReceiptLine.SetRange("No.", Rec."No.");
                WarehouseReceiptLine.SetFilter(WarehouseReceiptLine."Qty. to Receive", '<>%1', 0);
                if WarehouseReceiptLine.FindSet() then
                    if Confirm(Confirm_Msg) then
                        repeat
                            WarehouseReceiptLine.Validate("ATC_CP_3rd Vendor Rating", Rec."ATC_CP_3rd Vendor Rating");
                            WarehouseReceiptLine.Modify();
                        until WarehouseReceiptLine.Next() = 0;
            end;
        }
    }

    var
        gRecATCCPGeneralSetup: Record "ATC_CP_General Setup";

}