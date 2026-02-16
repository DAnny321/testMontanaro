page 90222 "ATC_CP_Email Notif. Setup Card"
{

    PageType = Card;
    SourceTable = "ATC_CP_Email Notific. Setup";
    Caption = 'Email Notification Setup Card', comment = 'ITA="Scheda setup notifche mail"';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ITA="Generale"';
                field("Purchase Events"; Rec."Purchase Events")
                {
                    ApplicationArea = All;
                    Editable = EditField;
                    ToolTip = 'Enter Purchase Events', Comment = 'ITA="Inserisci Evento acquisto"';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = EditField;
                    ToolTip = 'Specifies Description', Comment = 'ITA="Specifica Descrizione"';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Active', Comment = 'ITA="Inserisci Attivo"';
                    trigger OnValidate()
                    begin
                        EditField := not Rec.Active;
                    end;
                }

                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter Table No.', Comment = 'ITA="Inserisci Nr. tabella"';
                }
                field("Table Caption"; Rec."Table Caption")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter Table Caption', Comment = 'ITA="Inserisci Didascalia tabella"';
                }
                field("No. of Fields Selected to Send"; Rec."No. of Fields Selected to Send")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter No. of Fields Selected to Send', Comment = 'ITA="Inserisci Nr. di campi selezionati per invio"';
                }
                field(ObjetcText; ObjetcText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Object Mail', comment = 'ITA="Inserisci Oggetto mail"';
                    Caption = 'Object Mail', comment = 'ITA="Oggetto mail"';
                    MultiLine = true;
                    Editable = EditField;
                    trigger OnValidate()
                    begin
                        Rec.SetObjectMail(ObjetcText);
                    end;
                }

                field(ExistBody; ExistBody)
                {
                    ApplicationArea = all;
                    Editable = false;
                    MultiLine = true;
                    Caption = 'Exists Body Mail', comment = 'ITA="Corpo mail caricato"';
                    ToolTip = 'Enter Exists Body Mail', comment = 'ITA="Inserisci Corpo mail caricato"';
                }


                field("Send Mail As"; Rec."Send Mail As")
                {
                    ApplicationArea = All;
                    Editable = EditField;
                    ToolTip = 'Enter Send Mail As', Comment = 'ITA="Inserisci Invia mail come"';
                }

                field("Request Confirm Message"; Rec."Request Confirm Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Request Confirm Message', Comment = 'ITA="Richiedi messaggio di conferma"';
                }
                group(Link)
                {
                    Caption = 'Mail Link', comment = 'ITA="Link mail"';
                    field("Create Link"; Rec."Create Link")
                    {
                        ApplicationArea = All;
                        Editable = EditField;
                        ToolTip = 'Create Link', Comment = 'ITA="Crea Link"';
                    }
                    field("Link Target Page"; Rec."Link Target Page")
                    {
                        ApplicationArea = All;
                        Editable = EditField;
                        ToolTip = 'Enter Link Target Page', Comment = 'ITA="Inserisci agina destinazione collegamento"';
                    }
                    field("Shortcut Link"; Rec."Shortcut Link")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter Shortcut Link', Comment = 'ITA="Inserisci Link rapido collegamento"';
                    }
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action("Active Table Fields")
            {
                Caption = 'Active Mail Fields',
                    comment = 'ITA="Attivazione campi mail"';
                ToolTip = 'Active Mail Fields',
                    comment = 'ITA="Attivazione campi mail"';
                Image = List;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "ATC_CP_Field Notification Mail";
                RunPageLink = "Purchase Events" = field("Purchase Events"), "Table No." = field("Table No.");
                ApplicationArea = all;
            }
            action("Recipient Mail Setup")
            {
                Caption = 'Recipient Mail Setup',
                                comment = 'ITA="Configura destinatari mail"';
                ToolTip = 'Recipient Mail Setup',
                                comment = 'ITA="Configura destinatari mail"';
                Image = MailSetup;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "ATC_CP_Mail Recipients Setup";
                RunPageLink = "Purchase Events" = field("Purchase Events");
                ApplicationArea = all;
                PromotedOnly = true;
            }
            group(BodyMail)
            {
                Caption = 'Manage Body Mail', comment = 'ITA="Gestisci corpo mail"';
                ToolTip = 'Manage Body Mail', comment = 'ITA="Gestisci corpo mail"';
                Image = EditAttachment;

                action(Upload)
                {
                    Caption = 'Upload', comment = 'ITA="Carica"';
                    ApplicationArea = all;
                    Image = UpdateXML;
                    ToolTip = 'Use to Upload', Comment = 'ITA="Usa per caricare Body"';
                    trigger OnAction()
                    begin
                        Rec.UploadBodyText();
                        //GetBodyText(BodyText);
                    end;
                }

                action(Download)
                {
                    Caption = 'Download', comment = 'ITA="Scarica"';
                    ApplicationArea = all;
                    ToolTip = 'Use to Download the template', Comment = 'ITA="Usa per scaricare il Template"';
                    Image = MoveDown;
                    trigger OnAction()
                    begin
                        Rec.DownloadTemplate();
                    end;
                }
                action(Delete)
                {
                    Caption = 'Delete', comment = 'ITA="Cancella"';
                    ApplicationArea = all;
                    Image = DeleteXML;
                    ToolTip = 'User to Delete the Mail Body', Comment = 'ITA="Usa per cancellare il corpo della Mail"';
                    trigger OnAction()
                    var
                        MessConfirm_Msg: Label 'Are you sure to delete body mail?', comment = 'ITA="Sei sicuro di voler cancellare il corpo mail?"';
                    begin
                        if Confirm(MessConfirm_Msg) then
                            Clear(Rec."Mail Body");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ObjetcText := Rec.GetObjectMail();
        //GetBodyText(BodyText);
        EditField := Not Rec.Active;
        Rec.CalcFields("Mail Body");
        ExistBody := Rec."Mail Body".HasValue;
    end;


    trigger OnOpenPage()
    begin
        EditField := not Rec.Active;
    end;

    var
        ObjetcText: Text;
        // BodyText: Text;
        EditField: Boolean;
        ExistBody: Boolean;
}



