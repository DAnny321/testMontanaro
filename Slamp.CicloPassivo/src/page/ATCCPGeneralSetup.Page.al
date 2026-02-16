page 90200 "ATC_CP_General Setup"
{

    PageType = Card;
    SourceTable = "ATC_CP_General Setup";
    Caption = 'Purchase Request & General Setup', comment = 'ITA="Setup ciclo passivo"';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', comment = 'ITA="Generale"';
                field("Active Purchase Request"; Rec."Active Purchase Request")
                {
                    ApplicationArea = All;
                    ToolTip = 'Active Purchase Request', Comment = 'ITA="Attiva modulo"';
                }

                field("Default Expence Type"; Rec."Default Expence Type")
                {
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                    ToolTip = 'Select Default Expence Type', Comment = 'ITA="Selezione Tipo richiesta di default"';
                }

                field("Default Vendor"; Rec."Default Vendor")
                {
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                    ToolTip = 'Enter Default Vendor', Comment = 'ITA="Inserisci Fornitore di default"';
                }
            }

            group(Numeration)
            {
                Caption = 'Number Series', comment = 'ITA="Numeri serie"';
                field("Request Nos."; Rec."Request Nos.")
                {
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                    ToolTip = 'Enter Request Nos.', Comment = 'ITA="Inserisci Nr. serie richieste di acquisto"';
                }
                field("Template Request Nos."; Rec."Template Request Nos.")
                {
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                    ToolTip = 'Enter Template Request Nos.', Comment = 'ITA="Inserisci Nr. serie template richieste"';
                }
            }

            group(LinesVisibility)
            {
                Caption = 'Lines Management', comment = 'ITA="Gestione righe"';

                group(Hierarchy)
                {
                    Caption = 'Hierarchy', comment = 'ITA="Gerarchia"';
                    field("Active VDS Selection Hierarchy"; Rec."Active VDS Selection Hierarchy")
                    {
                        ApplicationArea = All;
                        Editable = Rec."Active Purchase Request";
                        ToolTip = 'Active VDS Selection Hierarchy', Comment = 'ITA="Active VDS Selection Hierarchy"';
                    }
                    field("Hierarchy Selection Level"; Rec."Hierarchy Selection Level")
                    {
                        ApplicationArea = All;
                        Editable = Rec."Active Purchase Request";
                        ToolTip = 'Enter Hierarchy Selection Level', Comment = 'ITA="Inserisci Livello selezione gerarchia"';
                    }
                    field("Mandatory Hierarchy"; Rec."Mandatory Hierarchy")
                    {
                        ApplicationArea = All;
                        Editable = Rec."Active Purchase Request";
                        ToolTip = 'Mandatory Hierarchy', Comment = 'ITA="Gerarchia obbligatoria"';
                    }
                    field("Active Driver-Hierarchy Assoc."; Rec."Active Driver-Hierarchy Assoc.")
                    {
                        ApplicationArea = All;
                        Editable = Rec."Active Purchase Request" and Rec."Active VDS Selection Hierarchy";
                    }
                }
                field("Hidden Field No. from List"; Rec."Hidden Field No. from List")
                {
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                    ToolTip = 'Hidden Field No. from List', Comment = 'ITA="Nascondi campo Nr. su righe"';
                }

                field("Reset Default Price/Discount"; Rec."Reset Default Price/Discount")
                {
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                    ToolTip = 'Reset Default Price/Discount', Comment = 'ITA="Azzera prezzi/sconti default"';
                }

                field("Request Only Quantities"; Rec."Request Only Quantities")
                {
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                    ToolTip = 'Request Only Quantities', Comment = 'ITA="Richiedi solo quantità"';
                }
                field("Line Amount Check"; Rec."Line Amount Check")
                {
                    ToolTip = 'Activate this setup if you want the system to check at the approval request if all the lines have an amount, otherwise it will return a blocking error.', comment = 'ITA="Attivare questo setup se si desidera che il sistema controlli in fase di invio approvazione se tutte le righe hanno un importo, in caso contrario restituirà un errore bloccante."';
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                }

            }

            group(Dimensions)
            {
                Caption = 'Dimensions', comment = 'ITA="Dimensioni"';
                field("Driver Dimension Code"; Rec."Driver Dimension Code")
                {
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                    ToolTip = 'Driver Dimension Code', Comment = 'ITA="Codice dimensione driver"';
                }
                field("Same Driver Check"; Rec."Same Driver Check")
                {
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                    ToolTip = 'Activate this setup if you want the system to check at the approval request if driver dimension if it is the same as the header on all lines, otherwise it will return a blocking error.',
                        comment = 'ITA="Attivare questo setup se si desidera che il sistema controlli in fase di invio approvazione se tutte le righe hanno la stessa dimensione driver della testata, in caso contrario restituirà un errore bloccante."';
                }
                field("Skip Alert Vendor Ass. Dim."; Rec."Skip Alert Vendor Ass. Dim.")
                {
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                    ToolTip = 'Activate this setup if you do not wish to receive notification of the dimensions associated with the vendor when creating the order from the offer.',
                        comment = 'ITA="Attivare questo setup se non desidera ricevere la notifica sulle dimensioni associate al fornitore in fase di creazione ordine da offerta."';
                }

            }



            group(VendorRating)
            {
                Caption = 'Vendor Rating', comment = 'ITA="Rating fornitori"';

                field("Enable Vendor Rating"; Rec."Enable Vendor Rating")
                {
                    ToolTip = 'Enable Vendor Rating', Comment = 'ITA="Attiva rating fornitori"';
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("First Vendor Rating"; Rec."First Vendor Rating")
                {
                    ToolTip = 'First Vendor Rating', Comment = 'ITA="Primo rating fornitori"';
                    ApplicationArea = All;
                    Editable = Rec."Enable Vendor Rating";
                }
                field("Second Vendor Rating"; Rec."Second Vendor Rating")
                {
                    ApplicationArea = All;
                    Editable = Rec."Enable Vendor Rating";
                    ToolTip = 'Second Vendor Rating', Comment = 'ITA="Secondo rating fornitori"';
                }
                field("Third Vendor Rating"; Rec."Third Vendor Rating")
                {
                    ApplicationArea = All;
                    Editable = Rec."Enable Vendor Rating";
                    ToolTip = 'Third Vendor Rating', Comment = 'ITA="Terzo rating fornitori"';
                }
                field("Mandatory Rating"; Rec."Mandatory Rating")
                {
                    ToolTip = 'Mandatory Rating', Comment = 'ITA="Rating obbligatorio"';
                    ApplicationArea = All;
                    Editable = Rec."Enable Vendor Rating";
                }
            }

            group(SetupMail)
            {
                Caption = 'Mail Setup', comment = 'ITA="Setup E-Mail"';
                field("Administration E-Mail"; Rec."Administration E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Administration E-Mail', Comment = 'ITA="Inserisci E-Mail amministrazione"';
                }
                field("Purchase Office E-Mail"; Rec."Purchase Office E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Purchase Office E-Mail', Comment = 'ITA="Inserisci E-Mail ufficio acquisti"';
                }
                field("Send Email Scenario"; Rec."Send Email Scenario")
                {
                    ApplicationArea = All;
                    ToolTip = 'Send Email Scenario', Comment = 'ITA="Seleziona scenario per invio mail"';
                }
            }

            group(AutomaticReceiptPost)
            {
                Caption = 'Automatic Receipt Post', comment = 'ITA="Registrazione automatica carico"';
                field("Aut. Purch. Rcpt. Batch. Post"; Rec."Aut. Purch. Rcpt. Batch. Post")
                {
                    ApplicationArea = All;
                    Editable = Rec."Active Purchase Request";
                    ToolTip = 'Aut. Purch. Rcpt. Batch. Post', Comment = 'ITA="Abilita registrazione automatica carichi"';
                }
                field(BatchPostReceiptParameter; Rec.BatchPostReceiptParameter)
                {
                    ApplicationArea = All;
                    Enabled = Rec."Active Purchase Request" and Rec."Aut. Purch. Rcpt. Batch. Post";
                    ToolTip = 'BatchPostReceiptParameter', Comment = 'ITA="Stringa registrazione carico"';
                }
                field(BatchUpdateOrderParameter; Rec.BatchUpdateOrderParameter)
                {
                    ApplicationArea = All;
                    Enabled = Rec."Active Purchase Request" and Rec."Aut. Purch. Rcpt. Batch. Post";
                    ToolTip = 'BatchUpdateOrderParameter', Comment = 'ITA="Stringa registra e aggiorna ordine"';
                }
                field(BatchPostUpdateParameter; Rec.BatchPostUpdateParameter)
                {
                    ApplicationArea = All;
                    Enabled = Rec."Active Purchase Request" and Rec."Aut. Purch. Rcpt. Batch. Post";
                    ToolTip = 'BatchPostUpdateParameter', Comment = 'ITA="Stringa registra e aggiorna ordine"';
                }
                field(DelayBatchUpdateOrder; Rec.DelayBatchUpdateOrder)
                {
                    ApplicationArea = All;
                    Enabled = Rec."Active Purchase Request" and Rec."Aut. Purch. Rcpt. Batch. Post";
                    ToolTip = 'DelayBatchUpdateOrder', Comment = 'ITA="Ritardo (in secondi) procedura batch agg. ordine"';
                }
            }


        }
    }

    actions
    {
        area(Processing)
        {
            action(ExpenceType)
            {
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'ExpenceType', Comment = 'ITA="Tipologie di spesa"';
                Image = AccountingPeriods;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Expence Type', comment = 'ITA="Tipologie di spesa"';
                RunObject = page "ATC_CP_Type List";
            }
            action(VendorsRating)
            {
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'VendorsRating', Comment = 'ITA="Rating fornitori"';
                Image = VendorContact;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Vendor Rating', comment = 'ITA="Rating fornitori"';
                RunObject = page "ATC_CP_Vendor Rating";
            }

            /*
            action(Testfunzione)
            {
                ApplicationArea = all;
                Image = AccountingPeriods;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'test funzione', comment = 'ITA="Test funzione"';
                trigger OnAction()
                var
                    //cuTest: Codeunit ATC_CP_PostReceiptBatch;
                    setdel: Record "ATC_CP_Email Notific. Setup";
                begin
                    /*cuTest.UpdatePurchaseOrder(false);
                    cuTest.PostReceiptBatch();
                    cuTest.UpdatePurchaseOrder(true);
                end;
            }
            */

            action(UserDimensionSetup)
            {
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'UserDimensionSetup', Comment = 'ITA="Setup utente per driver"';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'User Setup by Driver', comment = 'ITA="Setup utente per driver"';
                Visible = Rec."Active Purchase Request";
                RunObject = page "ATC_CP_Dimension Values";
                trigger OnAction()
                var
                    pageDimValue: page "ATC_CP_Dimension Values";
                begin
                    pageDimValue.SetVisibile(true, false);
                    pageDimValue.Run();
                end;
            }
            action(DimensionHierarchySetup)
            {
                ApplicationArea = all;
                Image = Hierarchy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Driver-Hierarchy Setup', comment = 'ITA="Associazione Driver-Gerarchia"';
                Visible = rec."Active Purchase Request" and rec."Active Driver-Hierarchy Assoc.";
                RunObject = page "ATC_CP_Dimension Values";
                trigger OnAction()
                var
                    pageDimValue: page "ATC_CP_Dimension Values";
                begin
                    pageDimValue.SetVisibile(false, true);
                    pageDimValue.Run();
                end;
            }

            action(HierarchySetup)
            {
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'HierarchySetup', Comment = 'ITA="Setup gerarchia di spesa"';
                Image = Hierarchy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Expense Hierarchy Setup', comment = 'ITA="Setup gerarchia di spesa"';
                Visible = Rec."Active Purchase Request" and Rec."Active VDS Selection Hierarchy";
                RunObject = page "ATC_CP_Expence Category";
            }

            action(MailSetup)
            {
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'MailSetup', Comment = 'ITA="Setup notifiche mail"';
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Mail Notification Setup', comment = 'ITA="Setup notifiche mail"';
                RunObject = page "ATC_CP_Email Notif. Setup List";
            }


            group(UserConfiguration)
            {
                Caption = 'Users Configuration', comment = 'ITA="Configurazione utenti"';

                action(AdvancedUserSetup)
                {
                    PromotedOnly = true;
                    ApplicationArea = all;
                    ToolTip = 'AdvancedUserSetup', Comment = 'ITA="Setup avanzato utenti"';
                    Image = UserSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Caption = 'Advanced User Setup', comment = 'ITA="Setup avanzato utenti"';
                    trigger OnAction()
                    var
                        userSetup: Page "Approval User Setup";
                    begin
                        userSetup.ATC_CP_setVisibility();
                        userSetup.Run();
                    end;
                }

                action(AccessUserSetup)
                {
                    PromotedOnly = true;
                    ApplicationArea = all;
                    ToolTip = 'AccessUserSetup', Comment = 'ITA="Configurazione accesso a page"';
                    Image = Permission;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Caption = 'Page Access Configuration', comment = 'ITA="Configurazione accesso a page"';
                    RunObject = page "ATC_CP_Page Access Config.";
                }


            }
        }
    }

    trigger OnOpenPage()
    var
        cuCheckApp: Codeunit ATC_CAV_RunCheckApp; //ID_AppCheckControl_
    begin
        if not Rec.Get() then begin
            Rec.init();
            Rec.Insert();
        end;

        //ID_AppCheckControl_begin
        clear(cuCheckApp);
        cuCheckApp.RunCheck(Enum::ATC_SC_ExtensionAgic::CicloPassivo, '');
        //ID_AppCheckControl_end
    end;

}
