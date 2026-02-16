page 90209 "ATC_CP_Item List"
{
    // version CP0

    Caption = 'Items',
                comment = 'ITA="Articoli"';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Item,History,Special Prices & Discounts,Request Approval,Periodic Activities,Inventory,Attributes',
                                 comment = 'ITA="Nuovo,Elabora,Report,Articolo,Storico,Prezzi e sconti speciali,Approvazione richieste,Attività periodiche,Inventario,Attributi"';
    RefreshOnActivate = true;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(Articolo)
            {
                Caption = 'Item',
                            comment = 'ITA="Articolo"';

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
                    ToolTip = 'Specifies the number of the item.',
                                comment = 'ITA="Specifica il numero dell''articolo."';
                    Visible = ShowNoField;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the item.',
                                comment = 'ITA="Specifica una descrizione dell''articolo."';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the item card represents a physical item (Inventory) or a service (Service).',
                                comment = 'ITA="Specifica se la scheda articolo rappresenta un articolo fisico (Magazzino) o un servizio (Assistenza)."';
                    Visible = IsFoundationEnabled;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                    HideValue = IsService;
                    ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.',
                                comment = 'ITA="Specifica quante unità dell''articolo, ad esempio pezzi, cartoni o scatole, sono presenti in magazzino."';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = all;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord();
    var
    //CRMCouplingManagement: Codeunit "CRM Coupling Management";
    //WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin
    end;

    trigger OnAfterGetRecord();
    begin
        EnableControls();
    end;

    /*
    trigger OnFindRecord(Which: Text): Boolean;
    var
        Found: Boolean;
    begin
        if RunOnTempRec then begin
            TempFilteredItem := Rec;
            Found := TempFilteredItem.FIND(Which);
            if Found then
                Rec := TempFilteredItem;
            exit(Found);
        end;
        exit(FIND(Which));
    end;
    */

    trigger OnNextRecord(Steps: Integer): Integer;
    var
        ResultSteps: Integer;
    begin
        if RunOnTempRec then begin
            TempFilteredItem := Rec;
            ResultSteps := TempFilteredItem.NEXT(Steps);
            if ResultSteps <> 0 then
                Rec := TempFilteredItem;
            exit(ResultSteps);
        end;
        exit(Rec.NEXT(Steps));
    end;

    trigger OnOpenPage();
    var
        lRecATCCPGeneralSetup: Record "ATC_CP_General Setup";
    begin
        lRecATCCPGeneralSetup.CalcPageVisibility(Show1stLivel, Show2ndLivel, Show3rdLivel, ShowNoField);
    end;

    var
        //TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
        TempFilteredItem: Record Item temporary;
        // ApplicationAreaSetup: Record "Application Area Setup";
        // PowerBIUserConfiguration: Record "Power BI User Configuration";
        // SetPowerBIUserConfig: Codeunit "Set Power BI User Config";
        // gCuCalculateStandardCost: Codeunit "Calculate Standard Cost";
        // gCuItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
        //ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        // ClientTypeManagement: Codeunit "Client Type Management";
        // SkilledResourceList: Page "Skilled Resource List";
        IsFoundationEnabled: Boolean;
        //[InDataSet]
        //SocialListeningSetupVisible: Boolean;
        //[InDataSet]
        //SocialListeningVisible: Boolean;
        // CRMIntegrationEnabled: Boolean;
        // CRMIsCoupledToRecord: Boolean;
        //OpenApprovalEntriesExist: Boolean;
        [InDataSet]
        IsService: Boolean;
        [InDataSet]
        //InventoryItemEditable: Boolean;
        //EnabledApprovalWorkflowsExist: Boolean;
        // CanCancelApprovalForRecord: Boolean;
        // IsOnPhone: Boolean;
        RunOnTempRec: Boolean;
    //EventFilter: Text;
    // PowerBIVisible: Boolean;
    // CanRequestApprovalForFlow: Boolean;
    // CanCancelApprovalForFlow: Boolean;

    [Scope('Cloud')]
    procedure GetSelectionFilter(): Text;
    var
        Item: Record Item;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SETSELECTIONFILTER(Item);
        exit(SelectionFilterManagement.GetSelectionFilterForItem(Item));
    end;

    [Scope('Cloud')]
    procedure SetSelection(var Item: Record Item);
    begin
        CurrPage.SETSELECTIONFILTER(Item);
    end;

    /*
    local procedure SetSocialListeningFactboxVisibility();
    var
        SocialListeningMgt: Codeunit "Social Listening Management";
    begin
        SocialListeningMgt.GetItemFactboxVisibility(Rec, SocialListeningSetupVisible, SocialListeningVisible);
    end;
    */

    local procedure EnableControls();
    begin
        IsService := (Rec.Type = Rec.Type::Service);
    end;
    /*
        local procedure SetWorkflowManagementEnabledState();
        var
            WorkflowManagement: Codeunit "Workflow Management";
            WorkflowEventHandling: Codeunit "Workflow Event Handling";
        begin
            EventFilter := WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode() + '|' +
              WorkflowEventHandling.RunWorkflowOnItemChangedCode();

            EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Item, EventFilter);
        end;
    */
    /*
        local procedure ClearAttributesFilter();
        begin
            Rec.CLEARMARKS();
            Rec.MARKEDONLY(false);
            TempFilterItemAttributesBuffer.RESET();
            TempFilterItemAttributesBuffer.DELETEALL();
            Rec.FILTERGROUP(0);
            Rec.SETRANGE("No.");
        end;
        */


    var
        Show1stLivel: Boolean;
        Show2ndLivel: Boolean;
        Show3rdLivel: Boolean;

        ShowNoField: Boolean;


}

