page 90214 "ATC_CP_Suggest Vendors"
{
    PageType = List;
    SourceTable = "ATC_CP_Suggest Vendor";
    Caption = 'Suggest Vendors', comment = 'ITA="Fornitori suggeriti"';
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Purchase Request No."; Rec."Purchase Request No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Purchase Request No.', Comment = 'ITA="Specifica nr. richiesta di acquisto"';
                }
                field("Sugget Purchase Vendor No."; Rec."Sugget Purchase Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sugget Purchase Vendor No.', Comment = 'ITA="Specifica nr. fornitore suggerito"';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Sugget Purchase Vendor Name"; Rec."Sugget Purchase Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies suggest Purchase Vendor Name', Comment = 'ITA="Specifica nome fornitore suggerito"';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the entry, depending on what you chose in the Type field.',
                                comment = 'ITA="Specifica una descrizione del movimento, in base alla scelta nel campo Tipo."';
                }

                field("Request Estimate Amount"; Rec."Request Estimate Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies request Estimate Amount', Comment = 'ITA="Specifica importo preventivo fornitore"';
                }
                field("Request Estimate Date"; Rec."Request Estimate Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies request Estimate Date', Comment = 'ITA="Specifica data preventivo fornitore"';
                }
            }
        }
    }
}
