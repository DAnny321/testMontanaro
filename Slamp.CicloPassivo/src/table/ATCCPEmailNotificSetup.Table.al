table 90205 "ATC_CP_Email Notific. Setup"
{
    Caption = 'Email Notific. Setup', comment = 'ITA="Setup notifiche mail"';
    DrillDownPageId = "ATC_CP_Email Notif. Setup List";
    LookupPageId = "ATC_CP_Email Notif. Setup List";
    fields
    {
        field(1; "Purchase Events"; Enum "ATC_CP_Purchase Events")
        {
            Caption = 'Purchase Events', comment = 'ITA="Evento acquisto"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                RequestRelease_Lbl: Label 'Notify for release purchase request', comment = 'ITA="Notifica per rilascio richiesta di acquisto"';
                OrderCreation_Lbl: Label 'Notify for creation order from purchase request', comment = 'ITA="Notifica per creazione ordine da richiesta di acquisto"';
                RequestReceiptPost_Lbl: Label 'Notify for request receipd post', comment = 'ITA="Notifica per richiesta registrazione carico acquisti"';
                OrderRelease_Lbl: Label 'Notify for release purchase order', comment = 'ITA="Notifica per rilascio ordine di acquisto"';
            //Error_Err: Label 'Not valid: please contact the administrator', comment = 'ITA="Non valido: contattare un amministratore"';
            begin
                case "Purchase Events" of
                    "Purchase Events"::" ":
                        begin
                            Validate("Table No.", 0);
                            Description := '';
                        end;
                    "Purchase Events"::OrderCreation:
                        begin
                            Validate("Table No.", 38);
                            Description := OrderCreation_Lbl;
                        end;
                    "Purchase Events"::RequestRelease:
                        begin
                            Validate("Table No.", 38);
                            Description := RequestRelease_Lbl;
                        end;
                    "Purchase Events"::RequestReceiptPost:
                        begin
                            Validate("Table No.", 38);
                            Description := RequestReceiptPost_Lbl;
                        end;
                    "Purchase Events"::ReleaseOrder:
                        begin
                            Validate("Table No.", 38);
                            Description := OrderRelease_Lbl;
                        end;
                    else
                        Error('');
                end;
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description', comment = 'ITA="Descrizione evento"';
            DataClassification = CustomerContent;
        }
        field(10; Active; Boolean)
        {
            Caption = 'Active', comment = 'ITA="Attivo"';
            DataClassification = CustomerContent;
        }
        field(20; "Send Mail As"; Text[250])
        {
            Caption = 'Send Mail As', comment = 'ITA="Invia mail come"';
            DataClassification = CustomerContent;
        }

        field(80; "Table No."; Integer)
        {
            Caption = 'Destination Table No.',
                        comment = 'ITA="Nr. tabella destinazione"';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
            trigger OnValidate()
            var
                PrFieldMail: Record "ATC_CP_Selection Field Mail";
                TField: Record Field;
                ErrorTable_Err: Label '%1 cannot be 0', comment = 'ITA="%1 non può essere 0"';
            begin
                PrFieldMail.Reset();
                PrFieldMail.SetRange("Purchase Events", "Purchase Events");
                PrFieldMail.SetRange("Table No.", "Table No.");
                PrFieldMail.DeleteAll();

                if "Table No." = 0 then
                    Error(ErrorTable_Err, FieldCaption("Table No."));

                TField.RESET();
                TField.SETRANGE(TField.TableNo, "Table No.");
                //TField.SETRANGE(TField.Class, TField.Class::Normal);
                IF TField.FindSet() THEN
                    REPEAT
                        PrFieldMail.INIT();
                        PrFieldMail."Purchase Events" := "Purchase Events";
                        PrFieldMail."Table No." := TField.TableNo;
                        PrFieldMail."Field No." := TField."No.";
                        PrFieldMail.INSERT();
                    UNTIL TField.NEXT() = 0;
            end;
        }
        field(85; "Table Caption"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption"
            WHERE("Object Type" = CONST(Table),
            "Object ID" = FIELD("Table No.")));

            Caption = 'Table Caption',
                        comment = 'ITA="Didascalia tabella"';
            FieldClass = FlowField;
        }

        field(90; "No. of Fields Selected to Send"; Integer)
        {
            Caption = 'No. of Fields Selected to Send', comment = 'ITA="Nr. di campi selezionati per invio"';
            FieldClass = FlowField;
            CalcFormula = count("ATC_CP_Selection Field Mail" where("Table No." = field("Table No."), "Purchase Events" = field("Purchase Events"), Active = filter(true)));
        }
        field(100; "Mail Object"; Blob)
        {
            Caption = 'Mail Object', comment = 'ITA="Oggetto mail"';
            DataClassification = CustomerContent;

        }
        field(110; "Mail Body"; Blob)
        {
            Caption = 'Mail Body', comment = 'ITA="Corpo mail"';
            DataClassification = CustomerContent;
        }

        field(120; "Create Link"; Boolean)
        {
            Caption = 'Create Link', comment = 'ITA="Crea link collegamento"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not "Create Link" then begin
                    "Shortcut Link" := '';
                    "Link Target Page" := 0;
                end else
                    "Shortcut Link" := '%11';

            end;
        }

        field(125; "Shortcut Link"; Text[5])
        {
            Caption = ' Shortcut Link', comment = 'ITA="Link rapido collegamento"';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(130; "Link Target Page"; Integer)
        {
            Caption = ' Link Target Page', comment = 'ITA="Pagina destinazione collegamento"';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Page));
            DataClassification = CustomerContent;
        }

        field(135; "Request Confirm Message"; Boolean)
        {
            Caption = 'Request Confirm Message', comment = 'ITA="Richiedi messaggio di conferma"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Purchase Events")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        TestField("Purchase Events");
    end;

    trigger OnDelete()
    var
        lRecATCCPSelectionFieldMail: Record "ATC_CP_Selection Field Mail";
        lRecATCCPMailRecipientsSetup: Record "ATC_CP_Mail Recipients Setup";
    begin
        lRecATCCPSelectionFieldMail.Reset();
        lRecATCCPSelectionFieldMail.SetRange("Purchase Events", Rec."Purchase Events");
        lRecATCCPSelectionFieldMail.DeleteAll();

        lRecATCCPMailRecipientsSetup.Reset();
        lRecATCCPMailRecipientsSetup.SetRange("Purchase Events", Rec."Purchase Events");
        lRecATCCPMailRecipientsSetup.DeleteAll();
    end;

    procedure SetObjectMail(NewObjectMail: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Mail Object");
        "Mail Object".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewObjectMail);
        MODIFY();
    end;

    procedure GetObjectMail(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Mail Object");
        "Mail Object".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator()));
    end;

    procedure UploadBodyText();
    var
        FileManagement: Codeunit "File Management";
        cuTempBlob: Codeunit "Temp Blob";
        // inStream: InStream;
        RecordRef: RecordRef;
        SelectFile_Lbl: Label 'Select file', comment = 'ITA="Seleziona file"';
        MessConfirm_Lbl: Label 'Do you want substitute previous template?', comment = 'ITA="Si desidera sostituire il template precedente?"';
        ErrMod_Err: Label 'Operation Canceled', comment = 'ITA="Operazione annullata"';
    begin
        CalcFields("Mail Body");
        if "Mail Body".HasValue then
            if Confirm(MessConfirm_Lbl) then
                Clear("Mail Body")
            else
                Error(ErrMod_Err);
        FileManagement.BLOBImport(cuTempBlob, SelectFile_Lbl);
        RecordRef.GetTable(Rec);
        cuTempBlob.ToRecordRef(RecordRef, FieldNo("Mail Body"));
        RecordRef.SetTable(Rec);
        Modify();
    end;

    procedure DownloadTemplate();
    var
        // lCuFileManagement: Codeunit "File Management";
        cuTempBlob: Codeunit "Temp Blob";
        // RecordRef: RecordRef;
        inStream: InStream;
        FileName_Lbl: Label 'Release Template Body Mail.html', comment = 'ITA="Template rilascio corpo mail.html"';
        FileText: Text;
    begin
        cuTempBlob.FromRecord(Rec, Rec.FieldNo("Mail Body"));
        cuTempBlob.CreateInStream(inStream);
        FileText := FileName_Lbl;
        DownloadFromStream(inStream, '', '', '', FileText);
    end;

    /*
    procedure GetBodyText(var varText: Text)
    var
        inStream: InStream;
        prova: BigText;
    begin
        CalcFields("Mail Body");
        if "Mail Body".HasValue then begin
            "Mail Body".CreateInStream(inStream, TEXTENCODING::UTF8);
            prova.Read(inStream);
            prova.GetSubText(varText, 1);
            //inStream.Read(varText)
        end else
            varText := '"';
    end;
    */

}
