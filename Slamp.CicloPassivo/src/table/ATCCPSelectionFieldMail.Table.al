table 90211 "ATC_CP_Selection Field Mail"
{

    Caption = 'Selection Field Mail',
                comment = 'ITA="Selezione campi mail"';


    DrillDownPageId = "ATC_CP_Field Notification Mail";
    LookupPageId = "ATC_CP_Field Notification Mail";

    fields
    {

        field(1; "Purchase Events"; Enum "ATC_CP_Purchase Events")
        {
            Caption = 'Purchase Events', comment = 'ITA="Evento acquisto"';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Table No."; Integer)
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Table No.',
                        comment = 'ITA="Nr. tabella"';
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.',
                        comment = 'ITA="Nr. campo"';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnLookup();
            var
                TField: Record Field;
                PField: Page "Fields Lookup";
            begin

                TField.RESET();
                TField.SETRANGE(TField.TableNo, "Table No.");
                PField.SetTableView(TField);
                PField.LookupMode(true);

                IF PField.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    PField.GetRecord(TField);
                    "Field No." := TField."No.";
                END;

            end;
        }
        field(4; "Field Caption"; Code[80])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD("Table No."), "No." = field("Field No.")));

            Caption = 'Field Caption',
                        comment = 'ITA="Descrizione campo"';

            FieldClass = FlowField;
        }

        field(5; Active; Boolean)
        {
            Caption = 'Active', comment = 'ITA="Attiva"';
            DataClassification = CustomerContent;

        }

        field(6; "Use as Link String"; Code[3])
        {
            Caption = 'Use as Link String', comment = 'ITA="Usa come collegamento stringa"';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "Purchase Events", "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure PrimaryKeyField(pTableID: Integer; pFieldID: Integer) rIsPrimaryKeyField: Boolean
    var
        lRecordRef: RecordRef;
        lFieldRef: FieldRef;
        lKeyRef: KeyRef;
        lIndex: Integer;
    begin
        rIsPrimaryKeyField := FALSE;

        CLEAR(lRecordRef);
        CLEAR(lFieldRef);
        CLEAR(lKeyRef);

        lRecordRef.OPEN(pTableID);
        lKeyRef := lRecordRef.KEYINDEX(1);

        FOR lIndex := 1 TO lKeyRef.FIELDCOUNT DO
            IF NOT rIsPrimaryKeyField THEN BEGIN
                lFieldRef := lKeyRef.FIELDINDEX(lIndex);
                rIsPrimaryKeyField := (lFieldRef.NUMBER = pFieldID);
            END;

        lRecordRef.CLOSE();


        EXIT(rIsPrimaryKeyField);
    end;
}