page 90206 "ATC_CP_Purch. Requests Templ."
{

    Caption = 'Purchase Request Template',
                comment = 'ITA="Template richieste di acquisto"';

    CardPageID = "ATC_CP_Purch. Request Templ.";
    DataCaptionFields = "Buy-from Vendor No.";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Request Approval',
                                 comment = 'ITA="Nuovo,Elabora,Report,Approvazione richieste"';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = CONST(Quote),
                            "ATC_CP_Purchase Request" = CONST(true), "ATC_CP_Request Template" = const(true));

    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {


                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.',
                                comment = 'ITA="Specifica il numero del movimento o del record interessato, in base alla numerazione specificata."';
                }

                field("ATC_CP_Expense Type"; Rec."ATC_CP_Expense Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the Expense Type', Comment = 'ITA="Specifica il tipo di spesa"';
                }
                field("ATC_CP_Request Description"; Rec."ATC_CP_Request Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Request Description', Comment = 'ITA="Specifica descrizione richiesta"';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the name of the vendor who delivered the items.',
                                comment = 'ITA="Specifica il nome del fornitore che ha consegnato gli articoli."';
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the name of the vendor who delivered the items.',
                                comment = 'ITA="Specifica il nome del fornitore che ha consegnato gli articoli."';
                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.',
                                comment = 'ITA="Specifica il codice per il collegamento dimensione 1, uno dei due codici di dimensione globale definiti nella finestra Setup contabilità generale."';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.',
                                comment = 'ITA="Specifica il codice per il collegamento dimensione 2, uno dei due codici di dimensione globale definiti nella finestra Setup contabilità generale."';
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the amount', Comment = 'ITA="Specifica l''importo"';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the amount Including VAT', Comment = 'ITA="Specifica l''importo iva inclusa"';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.',
                                comment = 'ITA="Specifica se il record è aperto, in attesa di approvazione, fatturato per il pagamento anticipato o rilasciato per la successiva fase di elaborazione."';
                }
                field("Buy-from Post Code"; Rec."Buy-from Post Code")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the post code of the vendor who delivered the items.',
                                comment = 'ITA="Specifica il codice postale del fornitore che ha consegnato gli articoli."';
                    Visible = false;
                }
                field("Buy-from Country/Region Code"; Rec."Buy-from Country/Region Code")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the city of the vendor who delivered the items.',
                                comment = 'ITA="Specifica la città del fornitore che ha consegnato gli articoli."';
                    Visible = false;
                }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.',
                                comment = 'ITA="Specifica il codice dell''ubicazione in cui verranno collocati al loro arrivo gli articoli ordinati."';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the date when the related document was created.',
                                comment = 'ITA="Specifica la data in cui è stato creato il documento correlato."';
                    Visible = false;
                }
                field("ATC_CP_User Request"; Rec."ATC_CP_User Request")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the user Request', Comment = 'ITA="Specifica utente richiedente"';
                }

                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies Requested Receipt Date', Comment = 'ITA="Specifica data carico richiesta"';
                }
                field("ATC_CP_Request Priority"; Rec."ATC_CP_Request Priority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the request Priority', Comment = 'ITA="Specifica la priorità richiesta"';
                }

            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = All;
                ShowFilter = false;
                Visible = false;
            }
            part(Control1901138007; "Vendor Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Buy-from Vendor No."),
                              "Date Filter" = FIELD("Date Filter");
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = all;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Offe&rta")
            {
                Caption = 'Request',
                            comment = 'ITA="Richiesta"';
                Image = Quote;


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
                    end;
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
                        Rec.ShowDocDim();
                    end;
                }
            }
        }
        area(processing)
        {

            action(CreateRDA)
            {
                ApplicationArea = All;
                ToolTip = 'Use to create a request purchase', Comment = 'ITA="Usa per creare una richiesta di acquisto"';
                Caption = 'Create Purchase Request',
                                comment = 'ITA="Crea richiesta di acquisto"';
                Image = CreateDocument;
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
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.ATC_CP_SetStyle();
    end;

    trigger OnOpenPage();
    var
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";

    begin
        lRecATCCPGeneralSetup.isActiveError();
        //SetSecurityFilterOnRespCenter;
        Rec.ATC_CP_setPurchaseRequestFilter();
        Rec.CopyBuyFromVendorFilter();
    end;

    var
    //gCuDocumentPrint: Codeunit "Document-Print";
    //OpenApprovalEntriesExist: Boolean;
    //CanCancelApprovalForRecord: Boolean;
    /*
        local procedure SetControlAppearance();
        var
            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        begin
            //OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);

            //CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
        end;
        */


    var
        StyleTxt: Text;
}

