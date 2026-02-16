tableextension 90206 "ATC_CP_PurchReceiptLineExt" extends "Purch. Rcpt. Line"
{
    fields
    {
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

    var
        gRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
}