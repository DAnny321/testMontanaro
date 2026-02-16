page 90215 "ATC_CP_Expence Category"
{

    PageType = List;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = "ATC_CP_Expence Category";
    Caption = 'Expence Category',
                comment = 'ITA="Categoria di spesa"';

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
                Caption = 'SubCategory', comment = 'ITA="Sottocategorie"';
                ApplicationArea = All;
                Image = Setup;
                ToolTip = 'SubCategory', comment = 'ITA="Sottocategorie"';
                RunObject = page "ATC_CP_Expence SubCategory";
                RunPageLink = "Category Code" = field(Code);
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = Show2ndLivel;
                Enabled = Show2ndLivel;
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



