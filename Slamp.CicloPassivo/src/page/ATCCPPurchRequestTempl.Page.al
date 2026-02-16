page 90207 "ATC_CP_Purch. Request Templ."
{
    // version CP0

    Caption = 'Purchase Request Template',
        comment = 'ITA="Template richiesta di acquisto"';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval',
                                 comment = 'ITA="Nuovo,Elabora,Report,Approva,Approvazione richieste"';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = CONST(Quote),
                            "ATC_CP_Purchase Request" = CONST(true), "ATC_CP_Request Template" = const(true));


    layout
    {
        area(content)
        {
            group(Generale)
            {
                Caption = 'General',
                            comment = 'ITA="Generale"';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.',
                                comment = 'ITA="Specifica il numero del movimento o del record interessato, in base alla numerazione specificata."';

                    trigger OnAssistEdit();
                    begin
                        if AssistEditPage(xRec) then
                            CurrPage.UPDATE();
                    end;
                }

                field("ATC_CP_Expense Type"; Rec."ATC_CP_Expense Type")
                {
                    ApplicationArea = All;
                    QuickEntry = true;
                    ToolTip = 'Specifies the Expense Type', Comment = 'ITA="Specifica il tipo di spesa"';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        lRecord: Record "ATC_CP_Expence Type";
                        prType: Record "ATC_CP_Expence Type";
                        lPage: page "ATC_CP_Type List";
                    begin
                        clear(lPage);
                        clear(lRecord);
                        lPage.SetTableView(lRecord);
                        lPage.Editable(false);
                        lPage.LookupMode := true;
                        if (lPage.RUNMODAL() = ACTION::LookupOK) then begin
                            lPage.GETRECORD(lRecord);
                            Rec.validate("ATC_CP_Expense Type", lRecord.Code);
                            if prType.Get(Rec."ATC_CP_Expense Type") and (prType."Enable Purchase Requests On" = prType."Enable Purchase Requests On"::Item) then
                                ShipToOptions := ShipToOptions::Location
                            else
                                ShipToOptions := ShipToOptions::"Default (Company Address)";
                            CurrPage.PurchLines.PAGE.PrInitLine();

                            CurrPage.Update();
                        end;

                    end;

                    trigger OnValidate()
                    var
                        prType: Record "ATC_CP_Expence Type";
                        prSetup: Record "ATC_CP_General Setup";
                        ErrMess_Err: Label 'For use Expence Type "%1" with default value is mandatory have a Default Vendor in General Setup',
                            comment = 'ITA ="Per utilizzare la tipologia di spesa "%1" con un valore di default, è obbligatorio avere un Fornitore Fittizio impostato nel setup generale"';
                    begin
                        if prType.Get(Rec."ATC_CP_Expense Type") and (prType."Enable Purchase Requests On" = prType."Enable Purchase Requests On"::Item) then
                            ShipToOptions := ShipToOptions::Location
                        else
                            ShipToOptions := ShipToOptions::"Default (Company Address)";

                        prSetup.Get();
                        if (prType."Default Value" <> '') and (prSetup."Default Vendor" = '') then
                            Error(ErrMess_Err, Rec."ATC_CP_Expense Type");
                        CurrPage.PurchLines.PAGE.PrInitLine();

                        CurrPage.Update();

                    end;
                }
                field("ATC_CP_Request Description"; Rec."ATC_CP_Request Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Request Description', Comment = 'ITA="Specifica descrizione richiesta"';
                }

                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    AccessByPermission = tabledata Vendor = R;
                    Caption = 'Vendor No.',
                                comment = 'ITA="Nr. fornitore"';
                    Importance = Additional;
                    NotBlank = true;
                    ToolTip = 'Specifies the number of the vendor who delivers the products.',
                                comment = 'ITA="Specifica il numero del fornitore che invia i prodotti."';

                    trigger OnValidate();
                    begin
                        Rec.OnAfterValidateBuyFromVendorNo(Rec, xRec);
                        CurrPage.UPDATE();
                    end;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name',
                                comment = 'ITA="Nome fornitore"';
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the vendor who delivers the products.',
                                comment = 'ITA="Specifica il nome del fornitore che invia i prodotti."';

                    trigger OnValidate();
                    begin
                        Rec.OnAfterValidateBuyFromVendorNo(Rec, xRec);

                        CurrPage.UPDATE();
                    end;
                }
                field("ATC_CP_Exists Suggest Vendors"; Rec."ATC_CP_Exists Suggest Vendors")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Exists Suggest Vendors', Comment = 'ITA="Esistono fornitori suggeriti"';
                }

                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    Caption = 'Requested Receipt Date', comment = 'ITA="Data di consegna desiderata"';
                    ShowMandatory = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.',
                                comment = 'ITA="Specifica la data richiesta al fornitore per la consegna all''indirizzo di spedizione. Il valore di questo campo viene utilizzato per calcolare la data ultima in cui è possibile ordinare gli articoli effettuando la consegna entro la data di carico richiesta. Se non si consegna entro una data precisa, si può lasciare il campo vuoto."';

                    trigger OnValidate()
                    var
                        errMess_Err: Label '%1 is not valid', comment = 'ITA="%1 non può essere uguale o minore ad oggi"';
                    begin
                        if (Rec."Requested Receipt Date" <> 0D) and (Rec."Requested Receipt Date" <= WorkDate()) then
                            Error(errMess_Err, Rec.FieldCaption("Requested Receipt Date"));
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.',
                                comment = 'ITA="Specifica il codice per il collegamento dimensione 1, uno dei due codici di dimensione globale definiti nella finestra Setup contabilità generale."';
                    ShowMandatory = Dim1Mandatory;
                    trigger OnValidate();
                    var
                    // userSetup: Record "User Setup";
                    // UserDimRules: Record "ATC_CP_Dimension User Role";
                    // GenLedgSetup: Record "General Ledger Setup";
                    // AssocFind: Boolean;
                    //ErrorAssoc_Err: Label 'User is not associated to selected Driver Dimension', comment = 'ITA="Utente non associato alla dimensione driver scelta"';
                    begin
                        //ShortcutDimension1CodeOnAfterV;
                        //OnValidateGlobDim(true);
                        CurrPage.PurchLines.PAGE.PrInitLine();
                        CurrPage.Update();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        prSetup: Record "ATC_CP_General Setup";
                        TableDim: Record "Dimension Value";
                        userSetup: Record "User Setup";
                        UserDimRules: Record "ATC_CP_Dimension User Role";
                        GenLedgSetup: Record "General Ledger Setup";
                        PageDim: page "Dimension Value List";
                        AssocFind: Boolean;
                        ErrorAssoc_Err: Label 'User is not associated to a Driver Dimension', comment = 'ITA="Utente non associato a nessuna dimensione driver"';
                    begin
                        clear(AssocFind);
                        Clear(PageDim);
                        TableDim.ClearMarks();
                        TableDim.MarkedOnly(false);
                        Rec.FilterGroup(8);
                        TableDim.Reset();
                        TableDim.setrange("Global Dimension No.", 1);
                        TableDim.SetRange(Blocked, false);
                        if prSetup.isGlobalDim1() then begin
                            userSetup.Get(UserId);
                            GenLedgSetup.Get();
                            if userSetup."ATC_CP_User Role" = userSetup."ATC_CP_User Role"::" " then begin
                                UserDimRules.Reset();
                                UserDimRules.SetRange("Dimension Code", GenLedgSetup."Global Dimension 1 Code");
                                UserDimRules.SetRange(UserDimRules.Type, UserDimRules.Type::User);
                                UserDimRules.SetRange("User Id", UserId);
                                UserDimRules.SetFilter(Role, '<>%1', UserDimRules.Role::" ");
                                if UserDimRules.FindSet() then begin
                                    AssocFind := true;
                                    repeat
                                        TableDim.Get(UserDimRules."Dimension Code", UserDimRules.Code);
                                        TableDim.Mark(true);
                                    until UserDimRules.Next() = 0;
                                end;

                                if userSetup."ATC_CP_User Group" <> '' then begin
                                    UserDimRules.SetRange(UserDimRules.Type, UserDimRules.Type::UserGroup);
                                    UserDimRules.SetRange("User Id", userSetup."ATC_CP_User Group");
                                    UserDimRules.SetFilter(Role, '<>%1', UserDimRules.Role::" ");
                                    if UserDimRules.FindSet() then begin
                                        AssocFind := true;
                                        repeat
                                            TableDim.Get(UserDimRules."Dimension Code", UserDimRules.Code);
                                            TableDim.Mark(true);
                                        until UserDimRules.Next() = 0;
                                    end;
                                end;
                                if not AssocFind then
                                    Error(ErrorAssoc_Err);
                                TableDim.MarkedOnly(true);
                            end;
                        end;
                        PageDim.SETRECORD(TableDim);
                        PageDim.SETTABLEVIEW(TableDim);
                        PageDim.LOOKUPMODE(TRUE);
                        PageDim.Editable := false;
                        if (PageDim.RUNMODAL() = ACTION::LookupOK) then begin
                            PageDim.GETRECORD(TableDim);
                            Rec.validate("Shortcut Dimension 1 Code", TableDim.Code);
                        end;
                        CurrPage.PurchLines.PAGE.PrInitLine();
                        CurrPage.Update();
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.',
                                comment = 'ITA="Specifica il codice per il collegamento dimensione 2, uno dei due codici di dimensione globale definiti nella finestra Setup contabilità generale."';
                    ShowMandatory = Dim2Mandatory;

                    trigger OnValidate();
                    var
                    // userSetup: Record "User Setup";
                    // UserDimRules: Record "ATC_CP_Dimension User Role";
                    // GenLedgSetup: Record "General Ledger Setup";
                    // AssocFind: Boolean;
                    // ErrorAssoc_Err: Label 'User is not associated to selected Driver Dimension', comment = 'ITA="Utente non associato alla dimensione driver scelta"';
                    begin
                        //ShortcutDimension2CodeOnAfterV;
                        //OnValidateGlobDim(false);
                        CurrPage.PurchLines.PAGE.PrInitLine();
                        CurrPage.Update();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        prSetup: Record "ATC_CP_General Setup";
                        TableDim: Record "Dimension Value";
                        userSetup: Record "User Setup";
                        UserDimRules: Record "ATC_CP_Dimension User Role";
                        GenLedgSetup: Record "General Ledger Setup";
                        PageDim: page "Dimension Value List";
                        AssocFind: Boolean;
                        ErrorAssoc_Err: Label 'User is not associated to a Driver Dimension', comment = 'ITA="Utente non associato a nessuna dimensione driver"';
                    begin
                        clear(AssocFind);
                        Clear(PageDim);
                        TableDim.ClearMarks();
                        TableDim.MarkedOnly(false);
                        Rec.FilterGroup(8);
                        TableDim.Reset();
                        TableDim.setrange("Global Dimension No.", 2);
                        TableDim.SetRange(Blocked, false);
                        if not prSetup.isGlobalDim1() then begin
                            userSetup.Get(UserId);
                            GenLedgSetup.Get();
                            if userSetup."ATC_CP_User Role" = userSetup."ATC_CP_User Role"::" " then begin
                                UserDimRules.Reset();
                                UserDimRules.SetRange("Dimension Code", GenLedgSetup."Global Dimension 2 Code");
                                UserDimRules.SetRange(UserDimRules.Type, UserDimRules.Type::User);
                                UserDimRules.SetRange("User Id", UserId);
                                UserDimRules.SetFilter(Role, '<>%1', UserDimRules.Role::" ");
                                if UserDimRules.FindSet() then begin
                                    AssocFind := true;
                                    repeat
                                        TableDim.Get(UserDimRules."Dimension Code", UserDimRules.Code);
                                        TableDim.Mark(true);
                                    until UserDimRules.Next() = 0;
                                end;

                                if userSetup."ATC_CP_User Group" <> '' then begin
                                    UserDimRules.SetRange(UserDimRules.Type, UserDimRules.Type::UserGroup);
                                    UserDimRules.SetRange("User Id", userSetup."ATC_CP_User Group");
                                    UserDimRules.SetFilter(Role, '<>%1', UserDimRules.Role::" ");
                                    if UserDimRules.FindSet() then begin
                                        AssocFind := true;
                                        repeat
                                            TableDim.Get(UserDimRules."Dimension Code", UserDimRules.Code);
                                            TableDim.Mark(true);
                                        until UserDimRules.Next() = 0;
                                    end;
                                end;
                                if not AssocFind then
                                    Error(ErrorAssoc_Err);
                                TableDim.MarkedOnly(true);
                            end;
                        end;
                        PageDim.SETRECORD(TableDim);
                        PageDim.SETTABLEVIEW(TableDim);
                        PageDim.LOOKUPMODE(TRUE);
                        PageDim.Editable := false;
                        if (PageDim.RUNMODAL() = ACTION::LookupOK) then begin
                            PageDim.GETRECORD(TableDim);
                            Rec.validate("Shortcut Dimension 2 Code", TableDim.Code);
                        end;
                        CurrPage.PurchLines.PAGE.PrInitLine();
                        CurrPage.Update();
                    end;
                }
                field("ATC_CP_User Request"; Rec."ATC_CP_User Request")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies user Request"', Comment = 'ITA="Specifica utente richiedente"';
                }
                field("ATC_CP_Request on Behalf of"; Rec."ATC_CP_Request on Behalf of")
                {
                    ApplicationArea = All;
                    ToolTip = 'Request on Behalf of', Comment = 'ITA="Richiesta per conto di"';
                }

                field(RequestAdditionalInfo; RequestAdditionalInfo)
                {
                    Caption = 'Additional Info', comment = 'ITA="Informazioni aggiuntive"';
                    ToolTip = 'Additional Info', comment = 'ITA="Informazioni aggiuntive"';
                    ApplicationArea = All;
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        Rec.ATC_CP_SetRequestAdditionalInfo(RequestAdditionalInfo);
                    end;
                }

                field("ATC_CP_Create Order Vendor No."; Rec."ATC_CP_Create Order Vendor No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Create Order Vendor No.', Comment = 'ITA="Crea ordine su nr. fornitore"';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("ATC_CP_Create Order Vend. Name"; Rec."ATC_CP_Create Order Vend. Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Create Order Vend. Name', Comment = 'ITA="Crea ordine su nome fornitore"';
                }

                field("ATC_CP_Request Template"; Rec."ATC_CP_Request Template")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies request Template', Comment = 'ITA="Specifica template richiesta di acquisto"';
                }

                field("ATC_CP_Expence Category"; Rec."ATC_CP_Expence Category")
                {
                    ApplicationArea = All;
                    Editable = Show1stLivel;
                    Visible = Show1stLivel;
                    ToolTip = 'Specifies Expence Category Code', Comment = 'ITA="Specifica Codice Categoria di spesa"';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field("ATC_CP_Expence SubCategory"; Rec."ATC_CP_Expence SubCategory")
                {
                    ApplicationArea = All;
                    Editable = Show2ndLivel;
                    Visible = Show2ndLivel;
                    ToolTip = 'Specifies expence SubCategory', Comment = 'ITA="Specifica codice sottocategoria di spesa"';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field("ATC_CP_Expence Details"; Rec."ATC_CP_Expence Details")
                {
                    ApplicationArea = All;
                    Editable = Show3rdLivel;
                    Visible = Show3rdLivel;
                    ToolTip = 'Specifies expence Details', Comment = 'ITA="Specifica codice dettaglio spesa"';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field("ATC_CP_Request Priority"; Rec."ATC_CP_Request Priority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the request Priority', Comment = 'ITA="Specifica la priorità richiesta"';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.',
                                comment = 'ITA="Specifica se il record è aperto, in attesa di approvazione, fatturato per il pagamento anticipato o rilasciato per la successiva fase di elaborazione."';
                }
            }
            part(PurchLines; "ATC_CP_Purch. Request Subform")
            {
                ApplicationArea = All;
                Editable = Rec."Buy-from Vendor No." <> '"';
                Enabled = Rec."Buy-from Vendor No." <> '"';
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            group("Shipping and Payment")
            {
                Caption = 'Shipping', comment = 'ITA="Spedizione"';
                group(Control45)
                {
                    ShowCaption = false;
                    group(Control20)
                    {
                        ShowCaption = false;
                        field(ShippingOptionWithLocation; ShipToOptions)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ship-to', comment = 'ITA="Spedire-a"';
                            HideValue = NOT ShowShippingOptionsWithLocation AND (ShipToOptions = ShipToOptions::Location);
                            OptionCaption = 'Default (Company Address),Location,Customer Address,Custom Address', comment = 'ITA="Default,Ubicazione,Indirizzo cliente,Personalizzato"';
                            ToolTip = 'Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Location: One of the company''s location addresses. Customer Address: Used in connection with drop shipment. Custom Address: Any ship-to address that you specify in the fields below."';

                            trigger OnValidate()
                            begin
                                ValidateShippingOption();
                            end;
                        }
                        group(Control57)
                        {
                            ShowCaption = false;
                            group(Control55)
                            {
                                ShowCaption = false;
                                Visible = ShipToOptions = ShipToOptions::Location;
                                field("Location Code"; Rec."Location Code")
                                {
                                    ApplicationArea = Location;
                                    Importance = Promoted;
                                    ShowMandatory = true;
                                    ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received."';
                                }
                            }
                            field("Ship-to Name"; Rec."Ship-to Name")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Name', comment = 'ITA="Nome"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                ToolTip = 'Specifies the name of the customer that items on the purchase order were shipped to, as a drop shipment."';
                            }
                            field("Ship-to Address"; Rec."Ship-to Address")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Address', comment = 'ITA="Indirizzo"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the address that items on the purchase order were shipped to, as a drop shipment."';
                            }
                            field("Ship-to Address 2"; Rec."Ship-to Address 2")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Address 2', comment = 'ITA="Indirizzo 2"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies an additional part of the address that items on the purchase order were shipped to, as a drop shipment."';
                            }
                            group(Control90)
                            {
                                ShowCaption = false;
                                Visible = IsShipToCountyVisible;
                                field("Ship-to County"; Rec."Ship-to County")
                                {
                                    ApplicationArea = Basic, Suite;
                                    Caption = 'County', comment = 'ITA="Provincia"';
                                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                    Importance = Additional;
                                    QuickEntry = false;
                                    ToolTip = 'Specifies the county of the address that you want the items on the purchase document to be shipped to."';
                                }
                            }
                            field("Ship-to Post Code"; Rec."Ship-to Post Code")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Post Code', comment = 'ITA="CAP"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the post code that items on the purchase order were shipped to, as a drop shipment."';
                            }
                            field("Ship-to City"; Rec."Ship-to City")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'City', comment = 'ITA="Città"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the city that items on the purchase order were shipped to, as a drop shipment."';
                            }
                            field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Country/Region', comment = 'ITA="Cod. paese"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the country/region in the vendor''s address."';

                                trigger OnValidate()
                                begin
                                    IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
                                end;
                            }
                            field("Ship-to Contact"; Rec."Ship-to Contact")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Contact', comment = 'ITA="Contatto"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                ToolTip = 'Specifies the contact person at the customer that items on the purchase order were shipped to, as a drop shipment."';
                            }
                        }
                    }
                }

            }

        }

    }

    actions
    {
        area(processing)
        {
            action(CreateRDA)
            {
                PromotedOnly = true;
                ApplicationArea = All;
                Caption = 'Create Purchase Request',
                    comment = 'ITA="Crea RDA"';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create Purchase Request',
                    comment = 'ITA="Crea RDA"';
                trigger OnAction();
                begin
                    Rec.ATC_CP_CreateRDA();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        //SetControlAppearance();
        RequestAdditionalInfo := Rec.ATC_CP_GetWorkDescription();
    end;

    trigger OnAfterGetRecord();
    begin
    end;

    trigger OnDeleteRecord(): Boolean;
    begin
        CurrPage.SAVERECORD();
        exit(Rec.ConfirmDeletion());
    end;


    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec."Responsibility Center" := gCuUserSetupManagement.GetPurchasesFilter();

        if (not DocNoVisible) and (Rec."No." = '') then
            Rec.SetBuyFromVendorFromFilter();

        //CalculateCurrentShippingAndPayToOption;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        userSetup: Record "User Setup";
        ErrorNext_Err: Label 'Function is not available', comment = 'ITA="Funzione non disponibile"';
    begin
        userSetup.Get(UserId);
        if userSetup."ATC_CP_User Role" = userSetup."ATC_CP_User Role"::" " then
            Error(ErrorNext_Err);
    end;

    /*
    trigger OnFindRecord(Which: Text): Boolean
    var
        ErrorNext: Label 'Function is not available', comment = 'ITA="Funzione non disponibile"';
        userSetup: Record "User Setup";
    begin
        userSetup.Get(UserId);
        if userSetup."ATC_CP_User Role" = userSetup."ATC_CP_User Role"::" " then
            Error(ErrorNext);
    end;
    */

    trigger OnOpenPage();
    var
        Pr_ATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin
        if gCuUserSetupManagement.GetPurchasesFilter() <> '' then begin
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", gCuUserSetupManagement.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        end;
        ActivateFields();
        SetDocNoVisible();
        Pr_ATCCPGeneralSetup.CalcPageVisibility(Show1stLivel, Show2ndLivel, Show3rdLivel, ShowNoField);

        Clear(Dim1Mandatory);
        Clear(Dim2Mandatory);
        if Pr_ATCCPGeneralSetup.isGlobalDim1() then
            Dim1Mandatory := true
        else
            Dim2Mandatory := true;
    end;

    var
        // DummyApplicationAreaSetup: Record "Application Area Setup";
        // CopyPurchDoc: Report "Copy Purchase Document";
        // DocumentPrint: Codeunit "Document-Print";
        gCuUserSetupManagement: Codeunit "User Setup Management";
        FormatAddress: Codeunit "Format Address";
        // ArchiveManagement: Codeunit ArchiveManagement;
        // PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        // ChangeExchangeRate: Page "Change Exchange Rate";
        ShipToOptions: Option "Default (Company Address)",Location,"Customer Address","Custom Address";
        //PayToOptions: Option "Default (Vendor)","Another Vendor";

        //HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        //OpenApprovalEntriesExistForCurrUser: Boolean;
        //OpenApprovalEntriesExist: Boolean;
        //ShowWorkflowStatus: Boolean;
        //CanCancelApprovalForRecord: Boolean;
        //CreateIncomingDocumentEnabled: Boolean;
        ShowShippingOptionsWithLocation: Boolean;

        IsShipToCountyVisible: Boolean;
        //IsPayToCountyVisible: Boolean;
        //IsBuyFromCountyVisible: Boolean;
        RequestAdditionalInfo: Text;
    /*
        local procedure ApproveCalcInvDisc();
        begin
            CurrPage.PurchLines.PAGE.ApproveCalcInvDisc();
        end;

    local procedure PurchaserCodeOnAfterValidate();
    begin
        CurrPage.PurchLines.PAGE.UpdateForm(true);
    end;

    local procedure ShortcutDimension1CodeOnAfterV();
    begin
        CurrPage.UPDATE();
    end;

    local procedure ShortcutDimension2CodeOnAfterV();
    begin
        CurrPage.UPDATE();
    end;

    local procedure PricesIncludingVATOnAfterValid();
    begin
        CurrPage.UPDATE();
    end;
    */

    local procedure SetDocNoVisible();
    var
    // DocumentNoVisibility: Codeunit DocumentNoVisibility;
    // DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := true;
    end;
    /*
        local procedure SetControlAppearance();
        var
        //ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        begin
            //OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
            //OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
            //CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
            //HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
            //CreateIncomingDocumentEnabled := (not HasIncomingDocument) and (Rec."No." <> '')
        end;
        */

    local procedure ValidateShippingOption();
    begin
        case ShipToOptions of
            ShipToOptions::"Default (Company Address)",
          ShipToOptions::"Custom Address":
                Rec.VALIDATE("Location Code", '');
            ShipToOptions::Location:
                Rec.VALIDATE("Location Code");
        end;
    end;
    /*
        local procedure CalculateCurrentShippingAndPayToOption();
        begin
            if Rec."Location Code" <> '' then
                ShipToOptions := ShipToOptions::Location
            else
                if Rec.ShipToAddressEqualsCompanyShipToAddress() then
                    ShipToOptions := ShipToOptions::"Default (Company Address)"
                else
                    ShipToOptions := ShipToOptions::"Custom Address";

            if Rec."Pay-to Vendor No." = Rec."Buy-from Vendor No." then
                PayToOptions := PayToOptions::"Default (Vendor)"
            else
                PayToOptions := PayToOptions::"Another Vendor";
        end;
        */

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."ATC_CP_Purchase Request" := true;
        Rec."ATC_CP_Request Template" := true;
    end;

    local procedure ActivateFields()
    begin
        //IsBuyFromCountyVisible := FormatAddress.UseCounty(Rec."Buy-from Country/Region Code");
        //IsPayToCountyVisible := FormatAddress.UseCounty(Rec."Pay-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
    end;

    procedure AssistEditPage(OldPurchaseHeader: Record "Purchase Header"): Boolean
    var
        Pr_ATCCPGeneralSetup: Record "ATC_CP_General Setup";
        lCuNoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        Pr_ATCCPGeneralSetup.get();
        Rec.TestNoSeries();
        if lCuNoSeriesManagement.SelectSeries(Pr_ATCCPGeneralSetup."Request Nos.", OldPurchaseHeader."No. Series", Rec."No. Series") then begin
            Rec.TestNoSeries();
            lCuNoSeriesManagement.SetSeries(Rec."No.");
            exit(true);
        end;
    end;

    var
        Show1stLivel: Boolean;
        Show2ndLivel: Boolean;
        Show3rdLivel: Boolean;
        ShowNoField: Boolean;
        Dim1Mandatory: Boolean;
        Dim2Mandatory: Boolean;
}

