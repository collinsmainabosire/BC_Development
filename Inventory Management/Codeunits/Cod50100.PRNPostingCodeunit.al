codeunit 50100 "PRN Posting"
{
    procedure Post(var PurchaseRequisitionHeader: Record "Purchase Requisition")
    var
        PRNTempLedger: Record "Drug Ledger Entry" temporary;
        IsHandled: Boolean;
    begin
        OnBeforePost();
        if IsHandled then
            exit;
        ValidatePRNHeader(PurchaseRequisitionHeader);
        LockPRN(PurchaseRequisitionHeader);
        ValidatePRNState(PurchaseRequisitionHeader);
        //CheckIfPosted();
        ProcessPosting(PurchaseRequisitionHeader, PRNTempLedger);
        FinalizePosting(PurchaseRequisitionHeader);
        OnAfterPost();
    end;

    //Validating PRN
    local procedure ValidatePRNHeader(var PurchaseRequisitionHeader: Record "Purchase Requisition")
    begin
        PurchaseRequisitionHeader.TestField("No.");
        PurchaseRequisitionHeader.TestField("Requested Date");
        PurchaseRequisitionHeader.TestField("Requested by");
        PurchaseRequisitionHeader.TestField(Status);
        PurchaseRequisitionHeader.TestField("Requisition Type");
    end;

    //Locking the PRN
    local procedure LockPRN(var PurchaseRequisitionHeader: Record "Purchase Requisition")
    begin
        PurchaseRequisitionHeader.LockTable();
        if not PurchaseRequisitionHeader.Get(PurchaseRequisitionHeader."No.") then
            Error('Document not found');
        if PurchaseRequisitionHeader.Status = PurchaseRequisitionHeader.Status::Posted then
            Error('Document already posted');
        PurchaseRequisitionHeader.SetRange(PurchaseRequisitionHeader."No.");
    end;

    //Validate PRN state after lcoking
    local procedure ValidatePRNState(var PurchaseRequisitionHeader: Record "Purchase Requisition")
    begin
        PurchaseRequisitionHeader.TestField(Status, PurchaseRequisitionHeader.Status::Released);
        if PurchaseRequisitionHeader.Status = PurchaseRequisitionHeader.Status::Posted then
            Error('Sorry the PRN %1 %2 has been posted', PurchaseRequisitionHeader."No.", PurchaseRequisitionHeader."Requisition Type");
    end;

    //Precessing Posting level 
    local procedure ProcessPosting(var PurchaseRequisitionHeader: Record "Purchase Requisition"; var PRNTempLedger: Record "Drug Ledger Entry" temporary)
    begin
        BuildPRNTempLedgers(PurchaseRequisitionHeader, PRNTempLedger);
        ValidatePRNTempLedgers(PRNTempLedger);
        InsertPRNTempLedgers(PRNTempLedger);

    end;


    //BUilding Temporary purchase requsition ledgers
    local procedure BuildPRNTempLedgers(var PurchaseRequisitionHeader: Record "Purchase Requisition"; var TempDrugLedger: Record "Drug Ledger Entry" temporary)
    var
        Line: Record "Purchase Requisition Line";
    begin
        Line.SetRange("Document No.", PurchaseRequisitionHeader."No.");

        if Line.FindSet() then
            repeat
                TempDrugLedger.Init();
                //header building
                TempDrugLedger."Created By" := PurchaseRequisitionHeader."Requested By";
                TempDrugLedger."Date Created" := PurchaseRequisitionHeader."Requested Date";
                TempDrugLedger.Status := PurchaseRequisitionHeader.Status;
                TempDrugLedger."Requsition Type" := PurchaseRequisitionHeader."Requisition Type";
                //Lines
                //TempDrugLedger."Req No." := Line."Document No.";
                TempDrugLedger."Drug No." := Line."Item No.";
                TempDrugLedger."Drug Name" := Line."Item Description";
                TempDrugLedger.Type := Line."Item Type";
                TempDrugLedger.Quantity := Line.Quantity;
                TempDrugLedger."Unit of Measure" := Line."Unit of Measure";
                TempDrugLedger."Line No." := Line."Line No.";
                TempDrugLedger."Document No." := Line."Document No.";
                TempDrugLedger.Insert(true);
            until Line.Next() = 0;
    end;

    //Validating PRN Temp Ledgers
    local procedure ValidatePRNTempLedgers(var PRNTempLedger: Record "Drug Ledger Entry" temporary)
    begin
        if not PRNTempLedger.FindSet() then
            Error('Nothing to post.');

        // repeat
        //     if PRNTempLedger.Quantity = 0 then
        //         Error('Ledger quantity cannot be zero.');
        // until PRNTempLedger.Next() = 0;
    end;

    local procedure CheckIfAlreadyPosted(Header: Record "Purchase Requisition")
    var
        Ledger: Record "Drug Ledger Entry";
    begin
        Ledger.SetRange("Req No.", Header."No.");
        if Ledger.FindFirst() then
            Error('Entries already exist for document %1', Header."No.");
    end;
    //Inserting  PRN Temp Ledgers to item ledger entries
    local procedure InsertPRNTempLedgers(var PRNTempLedger: Record "Drug Ledger Entry" temporary)
    var
        PurchaseRequisitionLedger: Record "Drug Ledger Entry";

    begin
        if PRNTempLedger.FindSet() then
            repeat
                PurchaseRequisitionLedger.Init();
                PurchaseRequisitionLedger.TransferFields(PRNTempLedger, false);
                PurchaseRequisitionLedger.Insert(true);
            until PRNTempLedger.Next() = 0;
    end;

    local procedure FinalizePosting(var PurchaseRequisitionHeader: Record "Purchase Requisition")
    begin
        PurchaseRequisitionHeader.Status := PurchaseRequisitionHeader.Status::Posted;
        PurchaseRequisitionHeader.Modify(true);
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
