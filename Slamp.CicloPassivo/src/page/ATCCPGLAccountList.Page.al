page 90208 "ATC_CP_G/L Account List"
{

    Caption = 'G/L Account List',
        comment = 'ITA="Lista conti C/G"';
    DataCaptionFields = "Search Name";
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "G/L Account";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;

                field("ATC_CP_Expence Category"; Rec."ATC_CP_Expence Category")
                {
                    ApplicationArea = All;
                    Visible = Show1stLivel;
                    ToolTip = 'Specifies Expence Category', Comment = 'ITA="Specifica Codice categoria di spesa"';
                }

                field("ATC_CP_Expence SubCategory"; Rec."ATC_CP_Expence SubCategory")
                {
                    ApplicationArea = All;
                    Visible = Show2ndLivel;
                    ToolTip = 'Specifies Expence SubCategory', Comment = 'ITA="Specifica Codice sottocategoria di spesa"';
                }

                field("ATC_CP_Expence Details"; Rec."ATC_CP_Expence Details")
                {
                    ApplicationArea = All;
                    Visible = Show3rdLivel;
                    ToolTip = 'Specifies Expence Details', Comment = 'ITA="Specifica Codice dettaglio di spesa"';
                }

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    Visible = ShowNoField;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.',
                                comment = 'ITA="Specifica il numero del movimento o del record interessato, in base alla numerazione specificata."';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the name of the general ledger account.',
                                comment = 'ITA="Specifica il nome del conto C/G."';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        NameIndent := 0;
        FormatLine();
    end;

    trigger OnOpenPage()
    var
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin
        lRecATCCPGeneralSetup.CalcPageVisibility(Show1stLivel, Show2ndLivel, Show3rdLivel, ShowNoField);
    end;

    var
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;

    [Scope('Cloud')]
    procedure SetSelection(var VarRecGLAccount: Record "G/L Account");
    begin
        CurrPage.SETSELECTIONFILTER(VarRecGLAccount);
    end;

    [Scope('Cloud')]
    procedure GetSelectionFilter(): Text;
    var
        lRecGLAccount: Record "G/L Account";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SETSELECTIONFILTER(lRecGLAccount);
        exit(SelectionFilterManagement.GetSelectionFilterForGLAccount(lRecGLAccount));
    end;

    local procedure FormatLine();
    begin
        NameIndent := Rec.Indentation;
        Emphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;
    /*
    local procedure NoCheckVisibility() Show: Boolean;
    begin
        exit(true);
    end;

    */
    var
        Show1stLivel: Boolean;
        Show2ndLivel: Boolean;
        Show3rdLivel: Boolean;
        ShowNoField: Boolean;

}

