codeunit 50100 "PRN Posting Codeunit"
{
    procedure Post(var PurchaseRequisitionHeader: Record "Purchase Requisition")
    var
        PRNTempLedger: Record "Drug Ledger Entry" temporary;
    begin
        OnBeforePost();
        ValidatePRN(PurchaseRequisitionHeader);
        LockPRN(PurchaseRequisitionHeader);
        ValidatePRNState(PurchaseRequisitionHeader);
        ProcessPosting(PurchaseRequisitionHeader, PRNTempLedger);
        //FinalizePsoting();
        OnAfterPost();
    end;

    //Validating PRN
    local procedure ValidatePRN(var PurchaseRequisitionHeader: Record "Purchase Requisition")
    begin
        PurchaseRequisitionHeader.TestField("No.");
        PurchaseRequisitionHeader.TestField("Requested Date");
        PurchaseRequisitionHeader.TestField("Item No.");
        PurchaseRequisitionHeader.TestField("Item Description");
        PurchaseRequisitionHeader.TestField("Unit of Measure");
        PurchaseRequisitionHeader.TestField("Requested by");
        PurchaseRequisitionHeader.TestField(Status);
        PurchaseRequisitionHeader.TestField("Item Type");
        PurchaseRequisitionHeader.TestField(Quantity);
        PurchaseRequisitionHeader.TestField("Requisition Type");
    end;

    //Locking the PRN
    local procedure LockPRN(var PurchaseRequisitionHeader: Record "Purchase Requisition")
    begin
        PurchaseRequisitionHeader.LockTable();
        PurchaseRequisitionHeader.SetRange(PurchaseRequisitionHeader."No.");
    end;

    //Validate PRN state after lcoking
    local procedure ValidatePRNState(var PurchaseRequisitionHeader: Record "Purchase Requisition")
    begin
        PurchaseRequisitionHeader.TestField(Status, PurchaseRequisitionHeader.Status::Released);
        if PurchaseRequisitionHeader.Status = PurchaseRequisitionHeader.Status::Posted then
            Error('Sorry the PRN %1 %2 has been posted', PurchaseRequisitionHeader."No.", PurchaseRequisitionHeader."Item Description");
    end;

    //Precessing Posting level 
    local procedure ProcessPosting(var PurchaseRequisitionHeader: Record "Purchase Requisition"; var PRNTempLedger: Record "Drug Ledger Entry" temporary)
    begin
        BuildPRNTempLedgers(PurchaseRequisitionHeader, PRNTempLedger);
        ValidatePRNTempLedgers(PRNTempLedger);
        InsertPRNTempLedgers(PRNTempLedger);

    end;


    //BUilding Temporary purchase requsition ledgers
    local procedure BuildPRNTempLedgers(var PurchaseRequisitionHeader: Record "Purchase Requisition"; var PRNTempLedger: Record "Drug Ledger Entry" temporary)

    begin
        OnBeforeBuildTempPRNLLedgers(PurchaseRequisitionHeader, PRNTempLedger);
        PRNTempLedger.Init();
        PRNTempLedger."Req No." := PurchaseRequisitionHeader."No.";
        PRNTempLedger."Date Created" := PurchaseRequisitionHeader."Requested Date";
        PRNTempLedger."Drug No." := PurchaseRequisitionHeader."Item No.";
        PRNTempLedger."Drug Name" := PurchaseRequisitionHeader."Item Description";
        PRNTempLedger."Unit of Measure" := PurchaseRequisitionHeader."Unit of Measure";
        PRNTempLedger."Requested by" := PurchaseRequisitionHeader."Requested by";
        PRNTempLedger.Status := PurchaseRequisitionHeader.Status;
        PRNTempLedger.Type := PurchaseRequisitionHeader."Item Type";
        PRNTempLedger.Quantity := PurchaseRequisitionHeader.Quantity;
        PRNTempLedger."Requsition Type" := PurchaseRequisitionHeader."Requisition Type";
        PRNTempLedger.Insert();
        OnAfterBuildTempPRNLLedgers(PRNTempLedger);
    end;

    //Validating PRN Temp Ledgers
    local procedure ValidatePRNTempLedgers(var PRNTempLedger: Record "Drug Ledger Entry" temporary)
    begin
        if PRNTempLedger.FindSet() then
            repeat


            until PRNTempLedger.Next() = 0;
    end;

    //Inserting  PRN Temp Ledgers to item ledger entries
    local procedure InsertPRNTempLedgers(var PRNTempLedger: Record "Drug Ledger Entry" temporary)
    var
        PurchaseRequisitionLedger: Record "Drug Ledger Entry";

    begin
        if PRNTempLedger.FindSet() then
            repeat
                PurchaseRequisitionLedger.Init();
                PurchaseRequisitionLedger.TransferFields(PRNTempLedger);
                PurchaseRequisitionLedger."Entry No." := 0;
                PurchaseRequisitionLedger.Insert(true);
            until PRNTempLedger.Next() = 0;
    end;
    //Events
    [IntegrationEvent(false, false)]
    local procedure OnBeforePost()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPost()
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeBuildTempPRNLLedgers(var PurchaseRequisitionHeader: Record "Purchase Requisition"; var PRNTempLedger: Record "Drug Ledger Entry" temporary)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterBuildTempPRNLLedgers(var PRNTempLedger: Record "Drug Ledger Entry" temporary)
    begin

    end;
}
