page 90226 "ATC_CP_Purchase Order"
{
    Caption = 'Requester Purchase Order',
        comment = 'ITA="Ordine di acquisto per richiedente"';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval',
        comment = 'ITA="Nuovo,Elabora,Report,Approva,Approvazione richieste"';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = CONST(Order),
                            "ATC_CP_Purchase Request" = CONST(true));
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;
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
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.',
                                comment = 'ITA="Specifica il numero del movimento o del record interessato, in base alla numerazione specificata."';
                    Visible = DocNoVisible;

                    trigger OnAssistEdit();
                    begin
                        if AssistEditPage(xRec) then
                            CurrPage.UPDATE();
                    end;
                }

                field("ATC_CP_Expense Type"; Rec."ATC_CP_Expense Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    QuickEntry = true;
                    ToolTip = 'Expense Type', Comment = 'ITA="Specifica tipologia di spesa"';
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
                    begin
                        if prType.Get(Rec."ATC_CP_Expense Type") and (prType."Enable Purchase Requests On" = prType."Enable Purchase Requests On"::Item) then
                            ShipToOptions := ShipToOptions::Location
                        else
                            ShipToOptions := ShipToOptions::"Default (Company Address)";

                        CurrPage.PurchLines.PAGE.PrInitLine();

                        CurrPage.Update();

                    end;
                }
                field("ATC_CP_Request Description"; Rec."ATC_CP_Request Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Request Description', Comment = 'ITA="Specifica descrizione richiesta "';
                }

                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Editable = false;
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
                    ToolTip = 'Exists Suggest Vendors', Comment = 'ITA="Controlla se esistono fornitori suggeriti"';
                }

                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    Caption = 'Requested Receipt Date', comment = 'ITA="Data di consegna desiderata"';
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Editable = false;
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
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.',
                                comment = 'ITA="Specifica il codice per il collegamento dimensione 1, uno dei due codici di dimensione globale definiti nella finestra Setup contabilità generale."';
                    ShowMandatory = Dim1Mandatory;
                    trigger OnValidate();
                    var
                        userSetup: Record "User Setup";
                        UserDimRules: Record "ATC_CP_Dimension User Role";
                        GenLedgSetup: Record "General Ledger Setup";
                        AssocFind: Boolean;
                        ErrorAssoc_Err: Label 'User is not associated to selected Driver Dimension', comment = 'ITA="Utente non associato alla dimensione driver scelta"';
                    begin
                        ShortcutDimension1CodeOnAfterV();
                        if Rec."Shortcut Dimension 1 Code" = '' then
                            exit;
                        userSetup.Get(UserId);
                        GenLedgSetup.Get();
                        clear(AssocFind);
                        if userSetup."ATC_CP_User Role" = userSetup."ATC_CP_User Role"::" " then begin
                            UserDimRules.Reset();
                            UserDimRules.SetRange("Dimension Code", GenLedgSetup."Global Dimension 1 Code");
                            UserDimRules.SetRange(Code, Rec."Shortcut Dimension 1 Code");
                            UserDimRules.SetRange(UserDimRules.Type, UserDimRules.Type::User);
                            UserDimRules.SetRange("User Id", UserId);
                            UserDimRules.SetFilter(Role, '<>%1', UserDimRules.Role::" ");
                            if UserDimRules.FindSet() then
                                AssocFind := true;

                            if userSetup."ATC_CP_User Group" <> '' then begin
                                UserDimRules.SetRange(UserDimRules.Type, UserDimRules.Type::UserGroup);
                                UserDimRules.SetRange("User Id", userSetup."ATC_CP_User Group");
                                UserDimRules.SetFilter(Role, '<>%1', UserDimRules.Role::" ");
                                if not UserDimRules.IsEmpty then
                                    AssocFind := true;
                            end;
                            if not AssocFind then
                                Error(ErrorAssoc_Err);
                        end;
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
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.',
                                comment = 'ITA="Specifica il codice per il collegamento dimensione 2, uno dei due codici di dimensione globale definiti nella finestra Setup contabilità generale."';
                    ShowMandatory = Dim2Mandatory;

                    trigger OnValidate();
                    var
                        userSetup: Record "User Setup";
                        UserDimRules: Record "ATC_CP_Dimension User Role";
                        GenLedgSetup: Record "General Ledger Setup";
                        AssocFind: Boolean;
                        ErrorAssoc_Err: Label 'User is not associated to selected Driver Dimension', comment = 'ITA="Utente non associato alla dimensione driver scelta"';
                    begin
                        ShortcutDimension2CodeOnAfterV();
                        if Rec."Shortcut Dimension 2 Code" = '' then
                            exit;
                        userSetup.Get(UserId);
                        GenLedgSetup.Get();
                        clear(AssocFind);
                        if userSetup."ATC_CP_User Role" = userSetup."ATC_CP_User Role"::" " then begin
                            UserDimRules.Reset();
                            UserDimRules.SetRange("Dimension Code", GenLedgSetup."Global Dimension 2 Code");
                            UserDimRules.SetRange(Code, Rec."Shortcut Dimension 2 Code");
                            UserDimRules.SetRange(UserDimRules.Type, UserDimRules.Type::User);
                            UserDimRules.SetRange("User Id", UserId);
                            UserDimRules.SetFilter(Role, '<>%1', UserDimRules.Role::" ");
                            if UserDimRules.FindSet() then
                                AssocFind := true;

                            if userSetup."ATC_CP_User Group" <> '' then begin
                                UserDimRules.SetRange(UserDimRules.Type, UserDimRules.Type::UserGroup);
                                UserDimRules.SetRange("User Id", userSetup."ATC_CP_User Group");
                                UserDimRules.SetFilter(Role, '<>%1', UserDimRules.Role::" ");
                                if not UserDimRules.IsEmpty then
                                    AssocFind := true;
                            end;
                            if not AssocFind then
                                Error(ErrorAssoc_Err);
                        end;
                        CurrPage.PurchLines.PAGE.PrInitLine();
                        CurrPage.Update();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        prSetup: Record "ATC_CP_General Setup";
                        TableDim: Record "Dimension Value";
                        userSetup: Record "User Setup";
                        UserDimRules: Record "ATC_CP_Dimension User Role";
                        lRecGeneralLedgerSetup: Record "General Ledger Setup";
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
                            lRecGeneralLedgerSetup.Get();
                            if userSetup."ATC_CP_User Role" = userSetup."ATC_CP_User Role"::" " then begin
                                UserDimRules.Reset();
                                UserDimRules.SetRange("Dimension Code", lRecGeneralLedgerSetup."Global Dimension 2 Code");
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
                    ToolTip = 'User Request', Comment = 'ITA="Specifica utente richiedente"';
                }
                field("ATC_CP_Request on Behalf of"; Rec."ATC_CP_Request on Behalf of")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Request on Behalf of', Comment = 'ITA="Richiesta per conto di"';
                }

                field(RequestAdditionalInfo; RequestAdditionalInfo)
                {
                    Caption = 'Additional Info', comment = 'ITA="Informazioni aggiuntive"';
                    ToolTip = 'Additional Info', comment = 'ITA="Informazioni aggiuntive"';
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        Rec.ATC_CP_SetRequestAdditionalInfo(RequestAdditionalInfo);
                    end;
                }

                field("ATC_CP_Create Order Vendor No."; Rec."ATC_CP_Create Order Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Create Order Vendor No.', Comment = 'ITA="Crea ordine su nr. fornitore"';
                    Editable = false;
                    ShowMandatory = true;
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
                    ToolTip = 'Request Template', Comment = 'ITA="Specifica template richiesta di acquisto"';
                }

                field("ATC_CP_Expence Category"; Rec."ATC_CP_Expence Category")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Expence Category', Comment = 'ITA="Specifica codice categoria di spesa"';

                    Visible = Show1stLivel;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field("ATC_CP_Expence SubCategory"; Rec."ATC_CP_Expence SubCategory")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Expence SubCategory', Comment = 'ITA="Specifica codice sottocategoria di spesa"';

                    Visible = Show2ndLivel;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field("ATC_CP_Expence Details"; Rec."ATC_CP_Expence Details")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Expence Details', Comment = 'ITA="Specifica codice dettaglio di spesa"';

                    Visible = Show3rdLivel;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field("ATC_CP_Request Priority"; Rec."ATC_CP_Request Priority")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Request Priority', Comment = 'ITA="Specifica priorità richiesta"';
                }

                field("ATC_CP_1st Vendor Rating"; Rec."ATC_CP_1st Vendor Rating")
                {
                    ApplicationArea = All;
                    Visible = Show1stRating;
                    ToolTip = '1st Vendor Rating', Comment = 'ITA="Specifica prima etichetta rating"';
                }
                field("ATC_CP_2nd Vendor Rating"; Rec."ATC_CP_2nd Vendor Rating")
                {
                    ApplicationArea = All;
                    Visible = Show2ndRating;
                    ToolTip = '2st Vendor Rating', Comment = 'ITA="Specifica seconda etichetta rating"';
                }
                field("ATC_CP_3rd Vendor Rating"; Rec."ATC_CP_3rd Vendor Rating")
                {
                    ApplicationArea = All;
                    Visible = Show3rdRating;
                    ToolTip = '3st Vendor Rating', Comment = 'ITA="Specifica terza etichetta rating"';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.',
                                comment = 'ITA="Specifica se il record è aperto, in attesa di approvazione, fatturato per il pagamento anticipato o rilasciato per la successiva fase di elaborazione."';
                }

                field(ATC_CP_PostRecepitStatus; Rec.ATC_CP_PostRecepitStatus)
                {
                    ApplicationArea = All;
                    Editable = true;
                    Visible = isReceiptVisible;
                    ToolTip = 'PostRecepitStatus', Comment = 'ITA="Specifica stato registrazione carico"';
                }
                field(ErrorDescritionPost; ErrorDescritionPost)
                {
                    ApplicationArea = All;
                    Caption = 'Post Error Description', comment = 'ITA="Descrizione registrazione carico"';
                    ToolTip = 'Post Error Description', comment = 'ITA="Descrizione registrazione carico"';
                    Visible = isReceiptVisible;
                    Editable = false;
                    MultiLine = true;
                }
            }
            part(PurchLines; "ATC_CP_Purch. Order Subform")
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
                            Editable = false;
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
                                    Editable = false;
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
        area(factboxes)
        {
            part(Control13; "Pending Approval FactBox")
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = "Table ID" = CONST(38),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Control5; "Purchase Line FactBox")
            {
                ApplicationArea = All;
                Editable = false;
                Provider = PurchLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
            }
            part(ApprovalFactBox; "Approval FactBox")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = All;
                Editable = false;
                ShowFilter = false;
                Visible = false;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Offe&rta")
            {
                Caption = 'Order',
                            comment = 'ITA="Ordine"';
                Image = Order;


                action(DocAttach)
                {
                    Caption = 'Document Attachments', comment = 'ITA="Allega documenti"';
                    ToolTip = 'Document Attachments', comment = 'ITA="Allega documenti"';
                    ApplicationArea = All;
                    Image = Attachments;
                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GETTABLE(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RUNMODAL();
                    end;

                }

                action(Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics',
                                comment = 'ITA="Statistiche"';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.',
                                comment = 'ITA="Visualizzare le informazioni statistiche del record, ad esempio il valore dei movimenti registrati."';

                    trigger OnAction();
                    begin
                        Rec.CalcInvDiscForHeader();
                        COMMIT();
                        PAGE.RUNMODAL(PAGE::"Purchase Statistics", Rec);
                        PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                action(Fornitore)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor',
                                comment = 'ITA="Fornitore"';
                    Enabled = Rec."Buy-from Vendor No." <> '"';
                    Image = Vendor;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = FIELD("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the vendor on the purchase document.',
                                comment = 'ITA="Visualizzare o modificare informazioni dettagliate sul fornitore sul documento di acquisto."';
                }
                action("Co&mmenti")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments',
                                comment = 'ITA="Co&mmenti"';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                    ToolTip = 'View or add comments for the record.',
                                comment = 'ITA="Visualizzare o aggiungere commenti per il record."';
                }

                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = All;
                    Caption = 'Approvals',
                                comment = 'ITA="Approvazioni"';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.',
                                comment = 'ITA="Visualizza un elenco di record in attesa di approvazione. È ad esempio possibile vedere chi ha richiesto l''approvazione del record, quando il record è stato inviato ed entro quando deve essere approvato."';

                    trigger OnAction();
                    var
                        //WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                        ApprovalEntry: Record "Approval Entry";
                    begin
                        //WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID, DATABASE::"Purchase Header", "Document Type", "No.");
                        ApprovalEntry.Reset();
                        ApprovalEntry.SetRange("Table ID", 38);
                        ApprovalEntry.SetRange("Document Type", Rec."Document Type");
                        ApprovalEntry.SetRange("Document No.", Rec."No.");
                        page.RunModal(658, ApprovalEntry);
                    end;
                }
            }
        }
        area(processing)
        {
            action(Post)
            {
                PromotedOnly = true;
                ApplicationArea = Suite;
                Caption = 'P&ost', comment = 'ITA="Registra carico"';
                AccessByPermission = Tabledata "G/L Entry" = R;
                Ellipsis = true;
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = codeunit "Purch.-Post (Yes/No)";
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.', comment = 'ITA="Finalizzare il documento o la registrazione registrando gli importi e le quantità nei relativi conti nei libri societari."';
            }
            group(Approvazione)
            {
                Caption = 'Approval',
                            comment = 'ITA="Approvazione"';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve',
                                comment = 'ITA="Approva"';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.',
                                comment = 'ITA="Approvare le modifiche richieste."';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject',
                                comment = 'ITA="Rifiuta"';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject to approve the incoming document. Note that this is not related to approval workflows.',
                                comment = 'ITA="Rifiutare l''approvazione del documento in entrata. Si noti che questa operazione non è correlata ai workflow di approvazione."';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Delegate)
                {
                    PromotedOnly = true;
                    ApplicationArea = All;
                    Caption = 'Delegate',
                                comment = 'ITA="Delega"';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Delegate the approval to a substitute approver.',
                                comment = 'ITA="Delegare l''approvazione a un responsabile sostituto."';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments',
                                comment = 'ITA="Commenti"';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View or add comments for the record.',
                                comment = 'ITA="Visualizzare o aggiungere commenti per il record."';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            action(Print)
            {
                ApplicationArea = All;
                Caption = '&Print',
                            comment = 'ITA="&Stampa"';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.',
                            comment = 'ITA="Preparare il documento alla stampa. Viene visualizzata una finestra di richiesta report per il documento nella quale è possibile specificare i dati da includere nella stampa."';

                trigger OnAction();
                begin
                    DocumentPrint.PrintPurchHeader(Rec);
                end;
            }
            group(Rilascio)
            {
                Caption = 'Release',
                            comment = 'ITA="Rilascio"';
                Image = ReleaseDoc;
                separator(Separator148)
                {
                }
                action(Release)
                {
                    ApplicationArea = All;
                    Caption = 'Re&lease',
                                comment = 'ITA="Ri&lascio"';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.',
                                comment = 'ITA="Rilasciare il documento per la fase di elaborazione successiva. Quando si rilascia un documento, questo viene incluso in tutti i calcoli di disponibilità a partire dalla data prevista per la ricezione degli articoli. È necessario riaprire il documento prima di poterlo modificare."';

                    trigger OnAction();
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        ReleasePurchDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = All;
                    Caption = 'Re&open',
                                comment = 'ITA="Ri&apri"';
                    Enabled = Rec.Status <> Rec.Status::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed',
                                comment = 'ITA="Aprire nuovamente il documento per modificarlo dopo l''approvazione. I documenti approvati hanno lo stato impostato su Rilasciato e devono essere aperti prima di poter essere modificati."';

                    trigger OnAction();
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("F&unzioni")
            {
                Caption = 'F&unctions',
                            comment = 'ITA="F&unzioni"';
                Image = "Action";
                /*
                action("Pa&gamenti")
                {
                    Caption = 'Pa&yments',
                                comment = 'ITA="Pa&gamenti"';
                    Image = Payment;
                    Visible = false;
                    ApplicationArea = all;
                    RunObject = Page "Payment Date Lines";
                    RunPageLink = "Sales/Purchase" = CONST(Purchase),
                                  Type = FIELD("Document Type"),
                                  Code = FIELD("No.");
                    ToolTip = 'View the related payments.',
                                comment = 'ITA="Visualizza i pagamenti correlati."';
                }
                */
                action(CalculateInvoiceDiscount)
                {
                    AccessByPermission = TableData "Vendor Invoice Disc." = R;
                    ApplicationArea = All;
                    Visible = false;
                    Caption = 'Calculate &Invoice Discount',
                                comment = 'ITA="Calcola sconto &fattura"';
                    Image = CalculateInvoiceDiscount;
                    ToolTip = 'Calculate the invoice discount for the purchase quote.',
                                comment = 'ITA="Calcolare lo sconto fattura per l''offerta di acquisto."';

                    trigger OnAction();
                    begin
                        ApproveCalcInvDisc();
                        PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                separator(Separator144)
                {
                }
                action("Prendi &codice std. acq. fornitore")
                {
                    ApplicationArea = All;
                    Caption = 'Get St&d. Vend. Purchase Codes',
                                comment = 'ITA="Prendi &codice std. acq. fornitore"';
                    Ellipsis = true;
                    Image = VendorCode;
                    Visible = false;
                    ToolTip = 'View a list of the standard purchase lines that have been assigned to the vendor to be used for recurring purchases.',
                                comment = 'ITA="Visualizzare una lista delle righe acquisto standard assegnate al fornitore corrente da utilizzare per gli acquisti ricorrenti."';

                    trigger OnAction();
                    var
                        StdVendPurchCode: Record "Standard Vendor Purchase Code";
                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }
                separator(Separator146)
                {
                }
                action(CopyDocument)
                {
                    ApplicationArea = All;
                    Caption = 'Copy Document',
                                comment = 'ITA="Copia documento"';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    Visible = false;
                    PromotedCategory = Process;
                    ToolTip = 'Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.',
                                comment = 'ITA="Copiare le righe del documento e le informazioni di testata da un altro documento di vendita nel documento corrente. È possibile copiare una fattura di vendita registrata in una nuova fattura di vendita per creare rapidamente un documento simile."';

                    trigger OnAction();
                    begin
                        CopyPurchaseDocument.SetPurchHeader(Rec);
                        CopyPurchaseDocument.RUNMODAL();
                        CLEAR(CopyPurchaseDocument);
                        if Rec.GET(Rec."Document Type", Rec."No.") then;
                    end;
                }
                action("Archive Document")
                {
                    ApplicationArea = All;
                    Caption = 'Archi&ve Document',
                                comment = 'ITA="Archi&via documento"';
                    Image = Archive;
                    ToolTip = 'Send the document to the archive, for example because it is too soon to delete it. Later, you delete or reprocess the archived document.',
                                comment = 'ITA="Inviare il documento all''archivio, ad esempio perché è troppo presto per eliminarlo. In un secondo momento, eliminare o rielaborare il documento archiviato."';

                    trigger OnAction();
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.UPDATE(false);
                    end;
                }
            }
            group(Documents)
            {
                Caption = 'Documents', Comment = 'ITA="Documenti"';
                Image = Documents;
                action(Receipts)
                {
                    PromotedOnly = true;
                    ApplicationArea = Suite;
                    Caption = 'Receipts', comment = 'ITA="Carichi registrati"';
                    ToolTip = 'Receipts', comment = 'ITA="Carichi registrati"';
                    Image = PostedReceipts;
                    Promoted = true;
                    RunObject = Page "Posted Purchase Receipts";
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");

                }
                action(Invoices)
                {
                    PromotedOnly = true;
                    ApplicationArea = Suite;
                    Caption = 'Invoices', comment = 'ITA="Fatture registrate"';
                    ToolTip = 'Invoices', comment = 'ITA="Fatture registrate"';
                    Image = Invoice;
                    Promoted = true;
                    PromotedIsBig = false;
                    RunObject = Page "Posted Purchase Invoices";
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                }
            }
            group("Approvazione richieste")
            {
                Caption = 'Request Approval',
                    comment = 'ITA="Approvazione richieste"';
                action(SendApprovalRequest)
                {
                    ApplicationArea = All;
                    Caption = 'Send A&pproval Request',
                                comment = 'ITA="Invia richiesta a&pprovazione"';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.',
                                comment = 'ITA="Richiedere l''approvazione del documento."';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    // prSetup: Record "ATC_CP_General Setup";
                    // prRequestType: record "ATC_CP_Expence Type";
                    begin
                        if ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) then
                            ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Approval Re&quest',
                                comment = 'ITA="Annulla ri&chiesta approvazione"';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.',
                                comment = 'ITA="Annullare la richiesta di approvazione."';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        SetControlAppearance();
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RECORDID);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);
        RequestAdditionalInfo := Rec.ATC_CP_GetWorkDescription();
        ErrorDescritionPost := Rec.ATC_CP_GetErrorDescription();
    end;

    trigger OnAfterGetRecord();
    begin
        //CalculateCurrentShippingAndPayToOption;
    end;

    trigger OnDeleteRecord(): Boolean;
    begin
        CurrPage.SAVERECORD();
        exit(Rec.ConfirmDeletion());
    end;


    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec."Responsibility Center" := UserSetupManagement.GetPurchasesFilter();

        if (not DocNoVisible) and (Rec."No." = '') then
            Rec.SetBuyFromVendorFromFilter();
        //CalculateCurrentShippingAndPayToOption;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        // userSetup: Record "User Setup";
        ErrorNext_Err: Label 'Function is not available on pre-filter list page', comment = 'ITA="Funzione non disponibile in una lista prefiltrata"';
    begin
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
        if UserSetupManagement.GetPurchasesFilter() <> '' then begin
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserSetupManagement.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        end;
        ActivateFields();
        SetDocNoVisible();
        Pr_ATCCPGeneralSetup.CalcPageVisibility(Show1stLivel, Show2ndLivel, Show3rdLivel, ShowNoField);
        Pr_ATCCPGeneralSetup.CalcRatingVisibility(Show1stRating, Show2ndRating, Show3rdRating);
        isReceiptVisible := Pr_ATCCPGeneralSetup.CalcReceiptVisib();

        Clear(Dim1Mandatory);
        Clear(Dim2Mandatory);
        if Pr_ATCCPGeneralSetup.isGlobalDim1() then
            Dim1Mandatory := true
        else
            Dim2Mandatory := true;
    end;




    local procedure ApproveCalcInvDisc();
    begin
        CurrPage.PurchLines.PAGE.ApproveCalcInvDisc();
    end;

    /*
    local procedure PurchaserCodeOnAfterValidate();
    begin
        CurrPage.PurchLines.PAGE.UpdateForm(true);
    end;
    */

    local procedure ShortcutDimension1CodeOnAfterV();
    begin
        CurrPage.UPDATE();
    end;

    local procedure ShortcutDimension2CodeOnAfterV();
    begin
        CurrPage.UPDATE();
    end;
    /*
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

    local procedure SetControlAppearance();
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
        //HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        //CreateIncomingDocumentEnabled := (not HasIncomingDocument) and (Rec."No." <> '')
    end;

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
    end;

    local procedure ActivateFields()
    begin
        //IsBuyFromCountyVisible := FormatAddress.UseCounty(Rec."Buy-from Country/Region Code");
        //IsPayToCountyVisible := FormatAddress.UseCounty(Rec."Pay-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
    end;

    procedure AssistEditPage(OldPurchaseHeader: Record "Purchase Header"): Boolean
    var
        pr_ATCCPGeneralSetup: Record "ATC_CP_General Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        pr_ATCCPGeneralSetup.get();
        Rec.TestNoSeries();
        if NoSeriesManagement.SelectSeries(pr_ATCCPGeneralSetup."Request Nos.", OldPurchaseHeader."No. Series", Rec."No. Series") then begin
            Rec.TestNoSeries();
            NoSeriesManagement.SetSeries(Rec."No.");
            exit(true);
        end;
    end;

    var
        // DummyApplicationAreaSetup: Record "Application Area Setup";
        CopyPurchaseDocument: Report "Copy Purchase Document";
        DocumentPrint: Codeunit "Document-Print";
        UserSetupManagement: Codeunit "User Setup Management";
        ArchiveManagement: Codeunit ArchiveManagement;
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        FormatAddress: Codeunit "Format Address";
        // ChangeExchangeRate: Page "Change Exchange Rate";
        ShipToOptions: Option "Default (Company Address)",Location,"Customer Address","Custom Address";
        //PayToOptions: Option "Default (Vendor)","Another Vendor";
        //HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;
        //CreateIncomingDocumentEnabled: Boolean;
        ShowShippingOptionsWithLocation: Boolean;
        IsShipToCountyVisible: Boolean;
        //IsPayToCountyVisible: Boolean;
        //IsBuyFromCountyVisible: Boolean;
        RequestAdditionalInfo: Text;
        isReceiptVisible: Boolean;
        Show1stLivel: Boolean;
        Show2ndLivel: Boolean;
        Show3rdLivel: Boolean;
        ShowNoField: Boolean;
        Dim1Mandatory: Boolean;
        Dim2Mandatory: Boolean;
        Show1stRating: Boolean;
        Show2ndRating: Boolean;
        Show3rdRating: Boolean;
        ErrorDescritionPost: Text;
}

