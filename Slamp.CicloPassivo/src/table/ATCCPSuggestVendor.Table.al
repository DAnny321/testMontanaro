table 90201 "ATC_CP_Suggest Vendor"
{


    LookupPageId = "ATC_CP_Suggest Vendors";
    DrillDownPageId = "ATC_CP_Suggest Vendors";
    Caption = 'Suggest Vendor', Comment = 'ITA="Fornitori suggeriti"';
    fields
    {
        field(10; "Purchase Request No."; Code[20])
        {
            Caption = 'Purchase Request No.', comment = 'ITA="Nr. richiesta di acquisto"';
            DataClassification = CustomerContent;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Quote), "ATC_CP_Purchase Request" = const(true));
        }
        field(20; "Sugget Purchase Vendor No."; Code[20])
        {
            Caption = 'Sugget Purchase Vendor No.', comment = 'ITA="Nr. fornitore suggerito"';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(30; "Sugget Purchase Vendor Name"; Text[100])
        {
            Caption = 'Sugget Purchase Vendor Name', comment = 'ITA="Nome fornitore suggerito"';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Sugget Purchase Vendor No.")));
        }
        field(40; Description; Text[250])
        {
            Caption = 'Description', comment = 'ITA="Descrizione"';
            DataClassification = CustomerContent;
        }

        field(50; "Request Estimate Amount"; Decimal)
        {
            Caption = 'Request Vendor Estimate', comment = 'ITA="Importo preventivo fornitore"';
            DataClassification = CustomerContent;
        }
        field(60; "Request Estimate Date"; Date)
        {
            Caption = 'Request Estimate Date', comment = 'ITA="Data preventivo fornitore"';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "Purchase Request No.", "Sugget Purchase Vendor No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

