page 90220 "ATC_CP_Purch Recepit Line List"
{

    PageType = List;
    SourceTable = "Purch. Rcpt. Line";
    Caption = 'Purchase Receipt Line List', comment = 'ITA="Dettaglio righe carichi registrati"';
    ApplicationArea = All;
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.',
                                comment = 'ITA="Specifica il numero del movimento o del record interessato, in base alla numerazione specificata."';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Posting Date', Comment = 'ITA="Specifica data di registrazione"';
                }

                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the vendor who delivered the items', Comment = 'ITA="Specifica il nome del fornitore che ha consegnato gli articoli"';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'SpecifiesOrder No.', Comment = 'ITA="Specifica nr. ordine"';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies order Date', Comment = 'ITA="Specifica data ordine"';
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specified order Line No.', Comment = 'ITA="Specifica nr. riga ordine"';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Line No.', Comment = 'ITA="Specifica nr. riga"';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.',
                                comment = 'ITA="Specifica il costo di un''unità della risorsa o dell''articolo selezionato."';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies type', Comment = 'ITA="Specifica tipo"';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.',
                                comment = 'ITA="Specifica il numero del movimento o del record interessato, in base alla numerazione specificata."';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of units of the item that will be specified on the line.',
                                comment = 'ITA="Specifica il numero di unità dell''articolo che sarà indicato nella riga."';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the entry, depending on what you chose in the Type field.',
                                comment = 'ITA="Specifica una descrizione del movimento, in base alla scelta nel campo Tipo."';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies description 2', Comment = 'ITA="Specifica la descriozione 2"';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount percentage to use to calculate the sales line discount',
                    Comment = 'ITA="Specifica la percentuale di sconto da utilizzare per calcolare lo sconto riga vendita"';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the location where the items on the line will be located.',
                                comment = 'ITA="Specifica il codice dell''ubicazione in cui saranno sistemati gli articoli indicati nella riga."';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Bin Code', Comment = 'ITA="Specifica la collocazione degli articoli"';
                }
                //field("Cross-Reference No."; Rec."Cross-Reference No.") old code
                field("Cross-Reference No."; Rec."Item Reference No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.',
                    Comment = 'ITA="Specifica il numero di articolo di riferimento incrociato. Se si immette un riferimento incrociato tra il numero di articolo dell''utente e quello del cliente o del fornitore, questo numero sovrascrive il numero di articolo standard quando si immette il numero di riferimento incrociato in un documento di vendita o acquisto."';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup',
                    Comment = 'ITA="Specifica il tipo di commercio del cliente o del fornitore per collegare le transazioni eseguite per questo partner commerciale al conto C/G appropriato in base al setup registrazioni COGE"';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup',
                    Comment = 'ITA="Specifica il tipo di articolo per collegare le transazioni correlate eseguite al conto C/G appropriato in base al setup registrazioni COGE"';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the VAT business posting group that will be used when you post the entry on the journal line',
                     Comment = 'ITA="Specifica il codice della categoria di registrazione business IVA che verrà utilizzato quando si registra il movimento nella riga di registrazione"';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record',
                    Comment = 'ITA="Specifica la categoria di registrazione articoli/servizi IVA. Collega le transazioni commerciali effettuate per l''articolo, la risorsa o il conto C/G alla contabilità generale per contabilizzare gli importi IVA risultanti dal commercio del record"';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure', Comment = 'ITA="Specifica l''unità di misura"';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost', Comment = 'ITA="Specifica il costo unitario"';
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost', Comment = 'ITA="Specifica il costo unitario"';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1', Comment = 'ITA="Specifica il codice per il collegamento dimensione 1"';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2', Comment = 'ITA="Specifica il codice per il collegamento dimensione 2"';
                }
                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units of the item on the line have been received and not yet invoiced', Comment = 'ITA="Specifica quante unità dell''articolo indicato nella riga sono state caricate ma non ancora fatturate"';
                }
                field("Qty. Invoiced (Base)"; Rec."Qty. Invoiced (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity that has been invoiced', Comment = 'ITA="Specifica la quantità che è stata fatturata"';
                }
                field("ATC_CP_1st Vendor Rating"; Rec."ATC_CP_1st Vendor Rating")
                {
                    ApplicationArea = All;
                    ToolTip = '1st Vendor Rating', Comment = 'ITA="Primo rating fornitori"';
                }
                field("ATC_CP_2nd Vendor Rating"; Rec."ATC_CP_2nd Vendor Rating")
                {
                    ApplicationArea = All;
                    ToolTip = '2st Vendor Rating', Comment = 'ITA="Secondo rating fornitori"';
                }
                field("ATC_CP_3rd Vendor Rating"; Rec."ATC_CP_3rd Vendor Rating")
                {
                    ApplicationArea = All;
                    ToolTip = '3st Vendor Rating', Comment = 'ITA="Terzo rating fornitori"';
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Expected Receipt Date', Comment = 'ITA="Specifica data carico prevista"';
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 3', Comment = 'ITA="Specifica il codice per il collegamento dimensione 3"';
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible3;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 4', Comment = 'ITA="Specifica il codice per il collegamento dimensione 4"';
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible4;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 5', Comment = 'ITA="Specifica il codice per il collegamento dimensione 5"';
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible5;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 6', Comment = 'ITA="Specifica il codice per il collegamento dimensione 6"';
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible6;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 7', Comment = 'ITA="Specifica il codice per il collegamento dimensione 7"';
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible7;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 8', Comment = 'ITA="Specifica il codice per il collegamento dimensione 8"';
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible8;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'Functions', comment = 'ITA="Funzioni"';
                Image = "Action";
                action(OrderTracking)
                {
                    ApplicationArea = All;

                    Caption = 'Order Tracking', comment = 'ITA="Tracciamento ordine"';
                    Image = OrderTracking;
                    ToolTip = 'Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order."';

                    trigger OnAction()
                    begin
                        ShowTracking();
                    end;
                }

                action("&Undo Item Receipt")
                {
                    ApplicationArea = All;
                    Caption = 'Undo Item Receipt', comment = 'ITA="Annulla carico"';
                    Image = Undo;
                    ToolTip = 'Cancel the quantity posting on the selected posted receipt line. A corrective line is inserted under the selected receipt line. If the quantity was received in a warehouse receipt, then a corrective line is inserted in the posted warehouse receipt. The Quantity Received and Qty. Rcd. Not Invoiced fields on the related purchase order are set to zero."';

                    trigger OnAction()
                    begin
                        UndoReceiptLineItem();
                    end;
                }
                /*
                action("&Undo G/L Account Receipt")
                {
                    ApplicationArea = All; ToolTip = '', Comment='ITA=" "';
                    Caption = 'Undo G/L Account Receipt', comment = 'ITA="Annulla carico su conto"';
                    Image = Undo;
                    ToolTip = 'Cancel the quantity posting on the selected posted receipt line. A corrective line is inserted under the selected receipt line. If the quantity was received in a warehouse receipt, then a corrective line is inserted in the posted warehouse receipt. The Quantity Received and Qty. Rcd. Not Invoiced fields on the related purchase order are set to zero."';

                    trigger OnAction()
                    begin
                        UndoReceiptLine;
                    end;
                }
                */
                action("ATC_CloseQtyNotInvoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Close Qty not invoiced', comment = 'ITA="Annulla quantità ricevuta non fatturata"';
                    Image = UndoShipment;
                    //Caption = 'Close Qty not invoiced', comment = 'ITA="Annulla quantità ricevuta non fatturata"';
                    Caption = 'Close Qty not invoiced', comment = 'ITA="Annulla quantità ricevuta non fatturata"';
                    trigger OnAction()
                    var
                        PurchRequestMngt: Codeunit ATC_CP_PurchRequestMngt;
                        Mess_Msg: Label 'Operation Completed', comment = 'ITA="Operazione completata"';
                    begin
                        if PurchRequestMngt.CloseQtyNotInvoiced(Rec) then
                            Message(Mess_Msg);
                    end;
                }
            }
            group(Line)
            {
                Caption = 'Line', comment = 'ITA="Riga"';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = All;
                    Caption = 'Dimensions', comment = 'ITA="Dimemsioni"';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history."';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = All;
                    Caption = 'Comments', comment = 'ITA="Commenti"';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record."';

                    trigger OnAction()
                    begin
                        Rec.ShowLineComments();
                    end;
                }
                action(ItemTrackingEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Item Tracking Entries', comment = 'ITA="Movimenti tracciabilità articolo"';
                    Image = ItemTrackingLedger;
                    ToolTip = 'View serial or lot numbers that are assigned to items."';

                    trigger OnAction()
                    begin
                        Rec.ShowItemTrackingLines();
                    end;
                }
                action(ItemInvoiceLines)
                {
                    ApplicationArea = All;
                    Caption = 'Item Invoice Lines', comment = 'ITA="Righe fatture articolo"';
                    Image = ItemInvoice;
                    ToolTip = 'View posted sales invoice lines for the item. "';

                    trigger OnAction()
                    begin
                        PageShowItemPurchInvLines();
                    end;
                }
                action(DocumentLineTracking)
                {
                    ApplicationArea = All;
                    Caption = 'Document Line Tracking', comment = 'ITA="Tracciabilità riga documento"';
                    Image = Navigate;
                    ToolTip = 'View related open, posted, or archived documents or document lines."';

                    trigger OnAction()
                    begin
                        ShowDocumentLineTracking();
                    end;
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    begin
        SetDimensionsVisibility();
    end;

    local procedure UndoReceiptLineItem()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(PurchRcptLine);
        CODEUNIT.Run(CODEUNIT::"Undo Purchase Receipt Line", PurchRcptLine);
    end;

    //Gestita da standard: non più utile per le nuove versioni. per le vecchie abilitare la funzione
    /*
    local procedure UndoReceiptLine()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(PurchRcptLine);
        CODEUNIT.Run(CODEUNIT::ATC_CP_CopUndPurRcptLine, PurchRcptLine);
    end;
    */

    local procedure PageShowItemPurchInvLines()
    begin
        Rec.TestField(Type, Rec.Type::Item);
        Rec.ShowItemPurchInvLines();
    end;

    procedure ShowDocumentLineTracking()
    var
        lPageDocumentLineTracking: Page "Document Line Tracking";
    begin
        Clear(lPageDocumentLineTracking);
        lPageDocumentLineTracking.SetDoc(
          5, Rec."Document No.", Rec."Line No.", Rec."Blanket Order No.", Rec."Blanket Order Line No.", Rec."Order No.", Rec."Order Line No.");
        lPageDocumentLineTracking.RUNMODAL();
    end;

    local procedure SetDimensionsVisibility()
    var
        lCuDimensionManagement: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        lCuDimensionManagement.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(lCuDimensionManagement);
    end;

    local procedure ShowTracking()
    var
        lRecItemLedgerEntry: Record "Item Ledger Entry";
        Temp_lRecItemLedgerEntry: Record "Item Ledger Entry" temporary;
        lPageOrderTracking: Page "Order Tracking";
    begin
        Rec.TestField(Type, Rec.Type::Item);
        if Rec."Item Rcpt. Entry No." <> 0 then begin
            lRecItemLedgerEntry.Get(Rec."Item Rcpt. Entry No.");
            lPageOrderTracking.SetItemLedgEntry(lRecItemLedgerEntry);
        end else
            lPageOrderTracking.SetMultipleItemLedgEntries(Temp_lRecItemLedgerEntry,
              DATABASE::"Purch. Rcpt. Line", 0, Rec."Document No.", '', 0, Rec."Line No.");
        lPageOrderTracking.RUNMODAL();
    end;

    var
        ShortcutDimCode: array[8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
}
