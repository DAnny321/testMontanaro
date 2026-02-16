tableextension 90210 "ATC_CP_Purchase Line Archive" extends "Purchase Line Archive"
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


        }
        field(90203; "ATC_CP_Request Additional Info"; Text[100])
        {
            Caption = 'PR Request Additional Info', comment = 'ITA="Informazioni aggiuntive"';
            DataClassification = CustomerContent;
        }

        field(90204; "ATC_CP_Expence Category"; Code[20])
        {
            TableRelation = "ATC_CP_Expence Category".Code;
            Caption = 'Expence Category Code', comment = 'ITA="Codice categoria di spesa"';
            DataClassification = CustomerContent;

        }
        field(90205; "ATC_CP_Expence SubCategory"; Code[20])
        {
            TableRelation = "ATC_CP_Expence SubCategory".Code where("Category Code" = field("ATC_CP_Expence Category"));
            Caption = 'Expence SubCategory', comment = 'ITA="Codice sottocategoria di spesa"';
            DataClassification = CustomerContent;

        }
        field(90206; "ATC_CP_Expence Details"; Code[20])
        {
            TableRelation = "ATC_CP_Expence Details".Code where("Category Code" = field("ATC_CP_Expence Category"), "SubCategory Code" = field("ATC_CP_Expence SubCategory"));
            Caption = 'Expence Details', comment = 'ITA="Codice dettaglio di spesa"';
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



    var
        gRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
}

