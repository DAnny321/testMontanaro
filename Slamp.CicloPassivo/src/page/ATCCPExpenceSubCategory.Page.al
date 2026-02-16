page 90216 "ATC_CP_Expence SubCategory"
{


    PageType = List;
    SourceTable = "ATC_CP_Expence SubCategory";
    Caption = 'Expence SubCategory',
                comment = 'ITA="Sottocategoria di spesa"';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Code', Comment = 'ITA="Inserisci Codice"';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter Description', Comment = 'ITA="Inserisci Descrizione"';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Category)
            {
                Caption = 'Expence Detail', comment = 'ITA="Dettaglio di spesa"';
                ToolTip = 'Expence Detail', comment = 'ITA="Dettaglio di spesa"';
                ApplicationArea = All;
                Image = Setup;
                RunObject = page "ATC_CP_Expence Details";
                RunPageLink = "Category Code" = field("Category Code"), "SubCategory Code" = field(Code);
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = Show3rdLivel;
                Enabled = Show3rdLivel;
                PromotedOnly = true;
            }
        }
    }
    trigger OnOpenPage();
    var
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin
        lRecATCCPGeneralSetup.CalcPageVisibility(Show1stLivel, Show2ndLivel, Show3rdLivel, ShowNoField);
    end;

    var
        Show1stLivel: Boolean;
        Show2ndLivel: Boolean;
        Show3rdLivel: Boolean;
        ShowNoField: Boolean;
}

