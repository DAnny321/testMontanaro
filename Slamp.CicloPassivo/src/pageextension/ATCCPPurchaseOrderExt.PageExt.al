pageextension 90207 "ATC_CP_Purchase Order Ext" extends "Purchase Order"
{

    layout
    {
        addlast(General)
        {
            field("ATC_CP_User Request"; Rec."ATC_CP_User Request")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies User Request', Comment = 'ITA="Specifica utente richiedente"';
                Editable = false;
            }
            field("ATC_CP_Expense Type"; Rec."ATC_CP_Expense Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Expense Type', Comment = 'ITA="Specifica il tipo di spesa"';
                Editable = false;
            }
            field("ATC_CP_Request Description"; Rec."ATC_CP_Request Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Request Description', Comment = 'ITA="Specifica descrizione richiesta"';
                Editable = false;
            }
            field("ATC_CP_Creation Date"; Rec."ATC_CP_Creation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies when the traced record was created', Comment = 'ITA="Specifica la data di creazione del record tracciato"';
                Editable = false;
            }
            field("ATC_CP_Request Priority"; Rec."ATC_CP_Request Priority")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the request Priority', Comment = 'ITA="Specifica la priorità richiesta"';
                Editable = IsEditable;
            }
            field("ATC_CP_1st Vendor Rating"; Rec."ATC_CP_1st Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '1st Vendor Rating', Comment = 'ITA="Primo rating fornitori"';
                Visible = Show1stRating;
            }
            field("ATC_CP_2nd Vendor Rating"; Rec."ATC_CP_2nd Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '2st Vendor Rating', Comment = 'ITA="Secondo rating fornitori"';
                Visible = Show2ndRating;
            }
            field("ATC_CP_3rd Vendor Rating"; Rec."ATC_CP_3rd Vendor Rating")
            {
                ApplicationArea = All;
                ToolTip = '3st Vendor Rating', Comment = 'ITA="Terzo rating fornitori"';
                Visible = Show3rdRating;
            }
            field(ATC_CP_RequestAdditionalInfo; RequestAdditionalInfo)
            {
                Caption = 'Additional Info', comment = 'ITA="Informazioni aggiuntive"';
                ApplicationArea = All;
                ToolTip = 'Additional Info', Comment = 'ITA="Vengono spcifica le informazioni aggiuntive"';
                Editable = IsEditable;
                MultiLine = true;

                trigger OnValidate()
                begin
                    Rec.ATC_CP_SetRequestAdditionalInfo(RequestAdditionalInfo);
                end;
            }

        }
    }
    actions
    {

        addlast("Request Approval")
        {
            action(ATC_CP_RequestPurchPost)
            {
                Caption = 'Request Receipt Post', comment = 'ITA="Richiedi reg. carico"';
                ApplicationArea = All;
                ToolTip = 'Request Receipt Post', comment = 'ITA="Richiedi reg. carico"';
                Image = ReceiptReminder;
                trigger OnAction()
                begin
                    Message('Ok');
                end;
            }
        }

    }

    trigger OnOpenPage()
    var
        lRecPr_ATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin
        lRecPr_ATCCPGeneralSetup.CalcRatingVisibility(Show1stRating, Show2ndRating, Show3rdRating);
        //glbVisible := lRecPr_ATCCPGeneralSetup.isVisible();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        RequestAdditionalInfo := Rec.ATC_CP_GetWorkDescription();
        IsEditable := (Rec."Quote No." = '') and (Rec.Status = Rec.status::Open);
    end;

    trigger OnAfterGetRecord()
    begin
        IsEditable := (Rec."Quote No." = '') and (Rec.Status = Rec.status::Open);
    end;

    var
        Show1stRating: Boolean;
        Show2ndRating: Boolean;
        Show3rdRating: Boolean;
        //glbVisible: Boolean;
        RequestAdditionalInfo: Text;
        IsEditable: Boolean;
}