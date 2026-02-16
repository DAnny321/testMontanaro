page 90203 "ATC_CP_Purch. Request Subform"
{
    // version CP0

    AutoSplitKey = true;
    Caption = 'Lines',
        comment = 'ITA="Righe"';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = FILTER(Quote));
    //,"ATC_CP_Purchase Request" = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {

                field("ATC_CP_Expence Category"; Rec."ATC_CP_Expence Category")
                {
                    ApplicationArea = All;
                    Visible = Show1stLivel;
                    Editable = Show1stLivel;
                    ToolTip = 'Specifies Expence Category Code', Comment = 'ITA="Specifica Codice Categoria di spesa"';

                }

                field("ATC_CP_Expence SubCategory"; Rec."ATC_CP_Expence SubCategory")
                {
                    ApplicationArea = All;
                    Visible = Show2ndLivel;
                    Editable = Show2ndLivel;
                    ToolTip = 'Specifies expence SubCategory', Comment = 'ITA="Specifica codice sottocategoria di spesa"';
                }

                field("ATC_CP_Expence Details"; Rec."ATC_CP_Expence Details")
                {
                    ApplicationArea = All;
                    Visible = Show3rdLivel;
                    Editable = Show3rdLivel;
                    ToolTip = 'Specifies expence Details', Comment = 'ITA="Specifica codice dettaglio spesa"';
                }

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Visible = ShowNoField or NoEditable;
                    Editable = ShowNoField and NoEditable;
                    HideValue = not ShowNoField;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.',
                                comment = 'ITA="Specifica il numero del movimento o del record interessato, in base alla numerazione specificata."';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        //ATCCPGeneralSetup: Record "ATC_CP_General Setup";
                        PrTypeSetup: Record "ATC_CP_Expence Type";
                        PurchHeader: Record "Purchase Header";
                        ItemRecord: Record Item;
                        AccountRecord: Record "G/L Account";
                        ItemPage: page "ATC_CP_Item List";
                        AccountPage: page "ATC_CP_G/L Account List";
                    begin
                        PurchHeader.Get(0, Rec."Document No.");
                        PrTypeSetup.get(PurchHeader."ATC_CP_Expense Type");
                        if (PrTypeSetup."Default Value" <> '') and not PrTypeSetup."Default Value Modifiable" then begin
                            Message(MessFieldNo_Msg, Rec.FieldCaption("No."));
                            exit;
                        end;
                        if PrTypeSetup."Enable Purchase Requests On" = PrTypeSetup."Enable Purchase Requests On"::"G/L Account" then begin
                            CLEAR(AccountPage);
                            CLEAR(AccountRecord);
                            AccountPage.SETTABLEVIEW(AccountRecord);
                            AccountRecord.FILTERGROUP(8);
                            AccountRecord.SETRANGE(AccountRecord."ATC_CP_Enable Purchase Request", true);
                            if Rec."ATC_CP_Expence Category" <> '' then
                                AccountRecord.SETRANGE(AccountRecord."ATC_CP_Expence Category", Rec."ATC_CP_Expence Category");
                            if Rec."ATC_CP_Expence SubCategory" <> '' then
                                AccountRecord.SETRANGE(AccountRecord."ATC_CP_Expence SubCategory", Rec."ATC_CP_Expence SubCategory");
                            if Rec."ATC_CP_Expence Details" <> '' then
                                AccountRecord.SETRANGE(AccountRecord."ATC_CP_Expence Details", Rec."ATC_CP_Expence Details");
                            AccountRecord.FILTERGROUP(2);
                            AccountPage.SETTABLEVIEW(AccountRecord);
                            AccountPage.LOOKUPMODE := TRUE;
                            if (AccountPage.RUNMODAL() = ACTION::LookupOK) then begin
                                AccountPage.GETRECORD(AccountRecord);
                                Rec.Validate("No.", AccountRecord."No.");
                            end;
                        end else begin
                            CLEAR(ItemPage);
                            CLEAR(ItemRecord);
                            ItemPage.SETTABLEVIEW(ItemRecord);
                            ItemRecord.FILTERGROUP(8);
                            ItemRecord.SETRANGE(ItemRecord."ATC_CP_Enable Purchase Request", true);
                            if Rec."ATC_CP_Expence Category" <> '' then
                                ItemRecord.SETRANGE(ItemRecord."ATC_CP_Expence Category", Rec."ATC_CP_Expence Category");
                            if Rec."ATC_CP_Expence SubCategory" <> '' then
                                ItemRecord.SETRANGE(ItemRecord."ATC_CP_Expence SubCategory", Rec."ATC_CP_Expence SubCategory");
                            if Rec."ATC_CP_Expence Details" <> '' then
                                ItemRecord.SETRANGE(ItemRecord."ATC_CP_Expence Details", Rec."ATC_CP_Expence Details");
                            ItemRecord.FILTERGROUP(2);
                            ItemPage.SETTABLEVIEW(ItemRecord);
                            ItemPage.LOOKUPMODE := TRUE;
                            if (ItemPage.RUNMODAL() = ACTION::LookupOK) then begin
                                ItemPage.GETRECORD(ItemRecord);
                                Rec.Validate("No.", ItemRecord."No.");
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        PrTypeSetup: Record "ATC_CP_Expence Type";
                    begin
                        gRecPurchaseHeader.Get(0, Rec."Document No.");
                        PrTypeSetup.get(gRecPurchaseHeader."ATC_CP_Expense Type");
                        if (PrTypeSetup."Default Value" <> '') and not PrTypeSetup."Default Value Modifiable" then
                            Error(MessFieldNo_Msg, Rec.FieldCaption("No."));

                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate();
                        //UpdateTypeText;
                        //DeltaUpdateTotals;                      
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the entry, depending on what you chose in the Type field.',
                                comment = 'ITA="Specifica una descrizione del movimento, in base alla scelta nel campo Tipo."';

                    trigger OnValidate();
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate();

                        if xRec."No." <> '' then
                            RedistributeTotalsOnAfterValidate();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        MessOnLookup_Msg: Label 'It is not available', comment = 'ITA="Non disponibile"';
                    begin
                        Message(MessOnLookup_Msg);
                    end;
                }

                field("ATC_CP_Request Additional Info"; Rec."ATC_CP_Request Additional Info")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies request Additional Info', Comment = 'ITA="Specifica informazioni aggiuntive"';
                }


                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the location where the items on the line will be located.',
                                comment = 'ITA="Specifica il codice dell''ubicazione in cui saranno sistemati gli articoli indicati nella riga."';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    ShowMandatory = TypeChosen AND (Rec."No." <> '');
                    ToolTip = 'Specifies the number of units of the item that will be specified on the line.',
                                comment = 'ITA="Specifica il numero di unità dell''articolo che sarà indicato nella riga."';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate();
                        if (xRec.Quantity = 0) and (Rec.Quantity <> 0) then
                            if rec.Insert() then;
                    end;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Editable = UnitofMeasureCodeIsChangeable;
                    Enabled = UnitofMeasureCodeIsChangeable;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.',
                                comment = 'ITA="Specifica in che modo ogni unità dell''articolo o della risorsa viene misurata, ad esempio in pezzi od ore. Per default, viene inserito il valore del campo Unità di misura base della scheda articolo o risorsa."';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate();
                    end;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.',
                                comment = 'ITA="Specifica il nome dell''unità di misura dell''articolo o della risorsa, ad esempio ora o pezzo."';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate();
                    end;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    Visible = ShowPriceDiscount;
                    Editable = ShowPriceDiscount;
                    BlankZero = true;
                    ShowMandatory = TypeChosen AND (Rec."No." <> '');
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.',
                                comment = 'ITA="Specifica il costo di un''unità della risorsa o dell''articolo selezionato."';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate();
                    end;
                }

                /*field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip ='Specifies the cost, in LCY, of one unit of the item or resource on the line.',
                                comment = 'ITA="Specifica il costo, in VL, di un''unità dell''articolo o della risorsa nella riga."';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate();
                    end;
                }*/

                /*field("Unit Price (LCY)"; "Unit Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip ='Specifies the price, in LCY, of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.',
                                comment = 'ITA="Specifica il prezzo unitario, in VL, dell''articolo o della risorsa. È possibile immettere il prezzo manualmente o automaticamente in base al campo Calcola prezzo/profitto nella scheda correlata."';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate();
                    end;
                }*/
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    Visible = ShowPriceDiscount;
                    Editable = ShowPriceDiscount;
                    BlankZero = true;
                    ToolTip = 'Specifies the discount percentage that is granted for the item on the line.',
                                comment = 'ITA="Specifica la percentuale di sconto concessa per l''articolo nella riga."';



                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate();
                    end;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Visible = ShowPriceDiscount;
                    Editable = ShowPriceDiscount;
                    BlankZero = true;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.',
                                comment = 'ITA="Specifica l''importo netto, escluso l''importo sconto fattura, che si deve pagare per i prodotti nella riga."';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate();
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.',
                                comment = 'ITA="Specifica il codice per il collegamento dimensione 1, uno dei due codici di dimensione globale definiti nella finestra Setup contabilità generale."';

                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.',
                                comment = 'ITA="Specifica il codice per il collegamento dimensione 2, uno dei due codici di dimensione globale definiti nella finestra Setup contabilità generale."';

                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    ToolTip = 'Specifies the code for Shortcut Dimension 3', Comment = 'ITA="Specifica il codice per il collegamento dimensione 3"';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateSaveShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    ToolTip = 'Specifies the code for Shortcut Dimension 4', Comment = 'ITA="Specifica il codice per il collegamento dimensione 4"';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateSaveShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    ToolTip = 'Specifies the code for Shortcut Dimension 5', Comment = 'ITA="Specifica il codice per il collegamento dimensione 5"';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateSaveShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    ToolTip = 'Specifies the code for Shortcut Dimension 6', Comment = 'ITA="Specifica il codice per il collegamento dimensione 6"';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateSaveShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    ToolTip = 'Specifies the code for Shortcut Dimension 7', Comment = 'ITA="Specifica il codice per il collegamento dimensione 7"';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateSaveShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    ToolTip = 'Specifies the code for Shortcut Dimension 8', Comment = 'ITA="Specifica il codice per il collegamento dimensione 8"';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateSaveShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
            }

            field(Importo; NetAmnt)
            {
                ApplicationArea = all;
                Editable = false;
                Enabled = False;
                ToolTip = 'Total Amount Excl. VAT', comment = 'ITA="Importo tot. escluso IVA"';
                Caption = 'Total Amount Excl. VAT', comment = 'ITA="Importo tot. escluso IVA"';
            }
            field(VATAmount; VatAmnt)
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = false;
                ToolTip = 'VAT Amount', comment = 'ITA="Importo IVA"';
                Caption = 'VAT Amount', comment = 'ITA="Importo IVA"';
            }
            field(ImportoInclusoIva; TotAmnt)
            {
                ApplicationArea = all;
                Editable = false;
                Enabled = false;
                ToolTip = 'Total Amount Incl. VAT', comment = 'ITA="Importo tot. incluso IVA"';
                Caption = 'Total Amount Incl. VAT', comment = 'ITA="Importo tot. incluso IVA"';
            }

        }
    }

    actions
    {
        area(processing)
        {

            group("Ri&ga")
            {
                Caption = '&Line',
                            comment = 'ITA="Ri&ga"';
                Image = Line;

                action(Dimensioni)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions',
                                comment = 'ITA="Dimensioni"';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.',
                                comment = 'ITA="Visualizza o modifica le dimensioni, ad esempio l''area, il progetto o il reparto, che si possono assegnare ai documenti di acquisto e vendita per distribuire i costi e analizzare lo storico delle transazioni."';

                    trigger OnAction();
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                action("Co&mmenti")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments',
                                comment = 'ITA="Co&mmenti"';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.',
                                comment = 'ITA="Visualizzare o aggiungere commenti per il record."';

                    trigger OnAction();
                    begin
                        Rec.ShowLineComments();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        TypeChosen := Rec.HasTypeToFillMandatoryFields();
        UpdateEditableOnRow();
        if gRecPurchaseHeader.GET(Rec."Document Type", Rec."Document No.") then;

        DocumentTotals.PurchaseUpdateTotalsControls(Rec, TotalPurchaseHeader, TotalPurchaseLine, RefreshMessageEnabled,
          TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, VATAmount);

        UpdateCurrency();
        CalcAmountHeader();
        //RequestAdditionalInfo := GetWorkDescription();
    end;

    trigger OnAfterGetRecord();
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        CLEAR(DocumentTotals);
    end;

    trigger OnDeleteRecord(): Boolean;
    var
        lRecPurchLineReserve: Codeunit "Purch. Line-Reserve";
    begin
        if (Rec.Quantity <> 0) and Rec.ItemExists(Rec."No.") then begin
            COMMIT();
            if not lRecPurchLineReserve.DeleteLineConfirm(Rec) then
                exit(false);
            lRecPurchLineReserve.DeleteLine(Rec);
        end;
    end;

    trigger OnInit();
    begin
        Currency.InitRoundingPrecision();
        Rec."ATC_CP_Purchase Request" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);

    begin
        Rec."ATC_CP_Purchase Request" := true;
        CLEAR(ShortcutDimCode);
        PrInitLine();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."ATC_CP_Purchase Request" := true;
    end;

    [Scope('Cloud')]
    procedure ApproveCalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)", Rec);
    end;
    /*
        local procedure ExplodeBOM();
        begin
            CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM", Rec);
        end;
        */

    local procedure InsertExtendedText(Unconditionally: Boolean);
    begin
        if TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SAVERECORD();
            TransferExtendedText.InsertPurchExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate() then
            UpdateForm(true);
    end;
    /*
        local procedure ItemChargeAssgnt();
        begin
            Rec.ShowItemChargeAssgnt();
        end;

        local procedure OpenItemTrackingLines();
        begin
            Rec.OpenItemTrackingLines();
        end;
        */

    [Scope('Cloud')]
    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    local procedure NoOnAfterValidate();
    begin
        UpdateEditableOnRow();
        InsertExtendedText(false);
        if (Rec.Type = Rec.Type::"Charge (Item)") and (Rec."No." <> xRec."No.") and
           (xRec."No." <> '')
        then
            CurrPage.SAVERECORD();
    end;
    /*
        local procedure CrossReferenceNoOnAfterValidat();
        begin
            InsertExtendedText(false);
        end;
        */

    local procedure RedistributeTotalsOnAfterValidate();
    begin
        CurrPage.SAVERECORD();

        gRecPurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
        if DocumentTotals.PurchaseCheckNumberOfLinesLimit(gRecPurchaseHeader) then
            DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
        CurrPage.UPDATE();
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        Rec.ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        CurrPage.SAVERECORD();
    end;

    local procedure UpdateEditableOnRow();
    begin
        UnitofMeasureCodeIsChangeable := Rec.CanEditUnitOfMeasureCode();
    end;

    local procedure UpdateCurrency();
    begin
        if Currency.Code <> TotalPurchaseHeader."Currency Code" then
            if not Currency.GET(TotalPurchaseHeader."Currency Code") then begin
                CLEAR(Currency);
                Currency.InitRoundingPrecision();
            end
    end;

    trigger OnOpenPage();
    var
        lRecPR_ATCCPGeneralSetup: Record "ATC_CP_General Setup";
        lRecPr_ATCCPExpenceType: Record "ATC_CP_Expence Type";
        lRecPurchaseHeader: Record "Purchase Header";
    begin
        lRecPR_ATCCPGeneralSetup.CalcPageLinesVisibility(Show1stLivel, Show2ndLivel, Show3rdLivel, ShowNoField, ShowPriceDiscount);
        NoEditable := true;
        if lRecPurchaseHeader.Get(0, Rec."Document No.") then
            if lRecPr_ATCCPExpenceType.get(lRecPurchaseHeader."ATC_CP_Expense Type") and (lRecPr_ATCCPExpenceType."Default Value" <> '') then
                NoEditable := lRecPr_ATCCPExpenceType."Default Value Modifiable";
    end;

    procedure PrInitLine()
    var
        lRecPr_ATCCPExpenceType: Record "ATC_CP_Expence Type";
        //lCuATCCPPurchRequestMngt: Codeunit ATC_CP_PurchRequestMngt;
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
        locItem: Record Item;
        lRecGLAccount: Record "G/L Account";
        ErrMess_Err: Label 'For use Expence Type "%1" with default value is mandatory have a Default Vendor in General Setup',
            comment = 'ITA="Per utilizzare la tipologia di spesa "%1" con un valore di default, è obbligatorio avere un Fornitore Fittizio impostato nel setup generale"';
    begin
        if not gRecPurchaseHeader.Get(0, Rec."Document No.") then
            exit;
        //else
        //    PurchHeader.Modify();
        //non serve il controllo sulla tipologia se esiste; se si è su questa pagina è obbligatoria
        if lRecPr_ATCCPExpenceType.Get(gRecPurchaseHeader."ATC_CP_Expense Type") then;
        if lRecPr_ATCCPExpenceType."Enable Purchase Requests On" = lRecPr_ATCCPExpenceType."Enable Purchase Requests On"::"G/L Account" then
            Rec.Type := Rec.Type::"G/L Account"
        else
            Rec.Type := Rec.Type::Item;

        if (lRecPr_ATCCPExpenceType."Default Value" <> '') then begin
            lRecATCCPGeneralSetup.Get();
            if (lRecATCCPGeneralSetup."Default Vendor" = '') then
                Error(ErrMess_Err, lRecPr_ATCCPExpenceType.Code);
            Rec.Validate("No.", lRecPr_ATCCPExpenceType."Default Value");
            Rec.validate(Quantity, 0);
            Rec.validate("Direct Unit Cost", 0);
            Rec.Validate("Shortcut Dimension 1 Code", gRecPurchaseHeader."Shortcut Dimension 1 Code");
            Rec.Validate("Shortcut Dimension 2 Code", gRecPurchaseHeader."Shortcut Dimension 2 Code");
            Rec.Validate("Dimension Set ID", gRecPurchaseHeader."Dimension Set ID");
            if Rec.Type = Rec.Type::Item then begin
                locItem.Get(lRecPr_ATCCPExpenceType."Default Value");
                Rec."ATC_CP_Expence Category" := locItem."ATC_CP_Expence Category";
                Rec."ATC_CP_Expence SubCategory" := locItem."ATC_CP_Expence SubCategory";
                Rec."ATC_CP_Expence Details" := locItem."ATC_CP_Expence Details";
            end else begin
                lRecGLAccount.Get(lRecPr_ATCCPExpenceType."Default Value");
                Rec."ATC_CP_Expence Category" := lRecGLAccount."ATC_CP_Expence Category";
                Rec."ATC_CP_Expence SubCategory" := lRecGLAccount."ATC_CP_Expence SubCategory";
                Rec."ATC_CP_Expence Details" := lRecGLAccount."ATC_CP_Expence Details";
            end;
        end else begin
            Rec.Validate("No.", '');
            Rec.Validate("Shortcut Dimension 1 Code", gRecPurchaseHeader."Shortcut Dimension 1 Code");
            Rec.Validate("Shortcut Dimension 2 Code", gRecPurchaseHeader."Shortcut Dimension 2 Code");
            Rec.Validate("Dimension Set ID", gRecPurchaseHeader."Dimension Set ID");
            if gRecPurchaseHeader."ATC_CP_Expence Category" <> '' then
                Rec."ATC_CP_Expence Category" := gRecPurchaseHeader."ATC_CP_Expence Category";
            if gRecPurchaseHeader."ATC_CP_Expence SubCategory" <> '' then
                Rec."ATC_CP_Expence SubCategory" := gRecPurchaseHeader."ATC_CP_Expence SubCategory";
            if gRecPurchaseHeader."ATC_CP_Expence Details" <> '' then
                Rec."ATC_CP_Expence Details" := gRecPurchaseHeader."ATC_CP_Expence Details";
        end;
    end;

    procedure CalcAmountHeader()
    var
        lRecHdrTotal_PurchaseHeader: Record "Purchase Header";
    begin
        Clear(NetAmnt);
        Clear(VatAmnt);
        Clear(TotAmnt);
        if lRecHdrTotal_PurchaseHeader.get(Rec."Document Type", Rec."Document No.") then begin
            lRecHdrTotal_PurchaseHeader.CalcFields(Amount, "Amount Including VAT");
            NetAmnt := lRecHdrTotal_PurchaseHeader.Amount;
            VatAmnt := lRecHdrTotal_PurchaseHeader."Amount Including VAT" - lRecHdrTotal_PurchaseHeader.Amount;
            TotAmnt := lRecHdrTotal_PurchaseHeader."Amount Including VAT";
        end;
    end;

    var
        TotalPurchaseHeader: Record "Purchase Header";
        TotalPurchaseLine: Record "Purchase Line";
        gRecPurchaseHeader: Record "Purchase Header";
        Currency: Record Currency;
        //PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        DocumentTotals: Codeunit "Document Totals";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        //gCuItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
        ShortcutDimCode: array[8] of Code[20];
        VATAmount: Decimal;
        InvDiscAmountEditable: Boolean;
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;
        UnitofMeasureCodeIsChangeable: Boolean;
        TypeChosen: Boolean;
        Show1stLivel: Boolean;
        Show2ndLivel: Boolean;
        Show3rdLivel: Boolean;
        ShowNoField: Boolean;
        NoEditable: Boolean;
        ShowPriceDiscount: Boolean;
        NetAmnt: Decimal;
        VatAmnt: Decimal;
        TotAmnt: Decimal;
        MessFieldNo_Msg: Label 'Field %1 not modifiable', comment = 'ITA="Campo %1 non modificabile manualmente"';
    //RequestAdditionalInfo: Text;
}

