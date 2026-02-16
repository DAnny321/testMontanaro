page 90204 "ATC_CP_Dimension Values"
{
    // version CP0

    Caption = 'Purchase Request Dimension Values',
                comment = 'ITA="Setup valori dimensioni per richieste di acquisto"';
    DataCaptionFields = "Dimension Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Dimension Value";
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the code for the dimension value.',
                                comment = 'ITA="Specifica il codice valore dimensioni."';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies a descriptive name for the dimension value.',
                                comment = 'ITA="Specifica un nome descrittivo per il valore di dimensione."';
                }
                field("Dimension Value Type"; Rec."Dimension Value Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purpose of the dimension value.',
                                comment = 'ITA="Specifica lo scopo del valore di dimensione."';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.',
                                comment = 'ITA="Specifica che la registrazione nelle transazioni del record correlato è bloccata, ad esempio nel caso in cui un cliente venga dichiarato insolvente o un articolo venga posto in quarantena."';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ConfiguresUsersRoles)
            {
                PromotedOnly = true;
                Image = UserSetup;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = gRoleVis;
                ToolTip = 'Configure user role by driver', comment = 'ITA="Configura ruoli utenti per driver"';
                Caption = 'Configure user role by driver', comment = 'ITA="Configura ruoli utenti per driver"';
                RunObject = Page "ATC_CP_Dimension User Role";
                RunPageLink = "Dimension Code" = FIELD("Dimension Code"),
                                Code = FIELD(Code);
            }
            action(ConfiguresHierAssoc)
            {
                Image = Hierarchy;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = gAssVis;
                Caption = 'Configure driver-hierarchy association', comment = 'ITA="Configura associazione driver-gerarchia"';
                RunObject = Page ATC_CP_DriverCategoryAssoc;
                RunPageLink = "Dimension Code" = FIELD("Dimension Code"),
                                Code = FIELD(Code);
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        NameIndent := 0;
        FormatLine();
    end;

    trigger OnOpenPage();
    var
    //DimensionCode: Code[20];
    begin
        PR_ATCCPGeneralSetup.get();
        PR_ATCCPGeneralSetup.TESTFIELD("Driver Dimension Code");
        Rec.FILTERGROUP(8);
        Rec.SETRANGE("Dimension Code", PR_ATCCPGeneralSetup."Driver Dimension Code");
        Rec.FILTERGROUP(2);
    end;

    var
        PR_ATCCPGeneralSetup: Record "ATC_CP_General Setup";
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;

    local procedure FormatLine();
    begin
        Emphasize := Rec."Dimension Value Type" <> Rec."Dimension Value Type"::Standard;
        NameIndent := Rec.Indentation;
    end;

    procedure SetVisibile(pRoleVis: boolean; pAssVis: boolean)
    begin
        gRoleVis := pRoleVis;
        gAssVis := pAssVis;
    end;

    var
        gRoleVis: boolean;
        gAssVis: boolean;
}

