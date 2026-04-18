/// <summary>
/// Codeunit PRN Posting (ID 50100) implements Interface InventoryPostingInterface.
/// </summary>
codeunit 50100 "Post Purchase" implements "InventoryPostingInterface"
{

    procedure Post(DocumentNo: Code[20])
    var
        Header: Record "Purchase Requisition";
    begin
        if not Header.Get(DocumentNo) then
            Error('Document %1 not found', DocumentNo);
        PostPurchase(Header);
    end;

    procedure PreValidate(DocumentNo: Code[20])
    var
        Header: Record "Purchase Requisition";
    begin
        if not Header.Get(DocumentNo) then
            Error('PRN %1 not found', DocumentNo);

        CheckIfAlreadyPosted(Header);
        Header.TestField(Status, Header.Status::Released);
    end;

    /// <summary>
    /// PostPurchase.
    /// </summary>
    /// <param name="Header">VAR Record "Purchase Requisition".</param>
    procedure PostPurchase(var Header: Record "Purchase Requisition")
    var
        TempLedger: Record "Drug Ledger Entry" temporary;
        Line: Record "Purchase Requisition Line";
        IsHandled: Boolean;
        EntryNo: Integer;
    begin
        OnBeforePost(Header, IsHandled);
        if IsHandled then
            exit;
        LockPRN(Header);
        ValidatePRNStatus(Header);
        BuildTempLedgerEntries(Header, TempLedger, EntryNo);
        ValidateTempLines(TempLedger);
        InsertLedgerEntries(TempLedger);
        FinalizePosting(Header);
        OnAfterPost(Header);
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
    var
        Line: Record "Purchase Requisition Line";
    begin
        PurchaseRequisitionHeader.LockTable();
    end;

    //Validate PRN state after lcoking
    local procedure ValidatePRNStatus(var PurchaseRequisitionHeader: Record "Purchase Requisition")
    begin
        PurchaseRequisitionHeader.TestField(Status, PurchaseRequisitionHeader.Status::Released);
        if PurchaseRequisitionHeader.Status = PurchaseRequisitionHeader.Status::Posted then
            Error('Sorry the PRN %1 %2 has been posted', PurchaseRequisitionHeader."No.", PurchaseRequisitionHeader."Requisition Type");
    end;

    //BUilding Temporary purchase requsition ledgers
    local procedure BuildTempLedgerEntries(var PurchaseRequisitionHeader: Record "Purchase Requisition"; var TempDrugLedger: Record "Drug Ledger Entry" temporary; var EntryNo: Integer)
    var
        Line: Record "Purchase Requisition Line";
        IsHandled: Boolean;
    begin
        OnBeforeBuildTempPRNLLedgers(PurchaseRequisitionHeader, TempDrugLedger, IsHandled);
        if not IsHandled then
            exit;
        EntryNo := 0;
        Line.SetRange("Document No.", PurchaseRequisitionHeader."No.");
        if Line.FindSet() then
            repeat
                EntryNo += 1;
                TempDrugLedger.Init();
                TempDrugLedger."Entry No." := EntryNo;
                TempDrugLedger."Created By" := PurchaseRequisitionHeader."Requested By";
                TempDrugLedger."Date Created" := PurchaseRequisitionHeader."Requested Date";
                TempDrugLedger.Status := PurchaseRequisitionHeader.Status;
                TempDrugLedger."Requsition Type" := PurchaseRequisitionHeader."Requisition Type";
                TempDrugLedger."Drug No." := Line."Item No.";
                TempDrugLedger."Drug Name" := Line."Item Description";
                TempDrugLedger.Type := Line."Item Type";
                TempDrugLedger.Quantity := Abs(Line.Quantity);
                TempDrugLedger."Unit of Measure" := Line."Unit of Measure";
                TempDrugLedger."Line No." := Line."Line No.";
                TempDrugLedger."Document No." := Line."Document No.";
                TempDrugLedger.Insert(true);
            until Line.Next() = 0;
        OnAfterBuildTempPRNLLedgers(TempDrugLedger);
    end;

    //Validating PRN Temp Ledgers
    local procedure ValidateTempLines(var PRNTempLedger: Record "Drug Ledger Entry" temporary)
    begin
        if PRNTempLedger.FindSet() then
            Error('Nothing to post.');

        repeat
        // if PRNTempLedger.Quantity = 0 then
        //   Error('Ledger quantity cannot be zero.');
        until PRNTempLedger.Next() = 0;
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
    local procedure InsertLedgerEntries(var PRNTempLedger: Record "Drug Ledger Entry" temporary)
    var
        PurchaseRequisitionLedger: Record "Drug Ledger Entry";
        IsHandled: Boolean;

    begin
        if not IsHandled then
            exit;
        if PRNTempLedger.FindSet() then
            repeat
                PurchaseRequisitionLedger.Init();
                PurchaseRequisitionLedger.TransferFields(PRNTempLedger, false);
                PurchaseRequisitionLedger."Entry No." := 0;
                PurchaseRequisitionLedger.Insert(false);
            until PRNTempLedger.Next() = 0;
    end;

    local procedure FinalizePosting(var PurchaseRequisitionHeader: Record "Purchase Requisition")
    var
        IsHandled: Boolean;
    begin
        if not IsHandled then
            exit;
        PurchaseRequisitionHeader.Status := PurchaseRequisitionHeader.Status::Posted;
        PurchaseRequisitionHeader.Modify(true);
    end;
    //Events
    [IntegrationEvent(false, false)]
    local procedure OnBeforePost(Var Header: Record "Purchase Requisition";  var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPost(var Header: Record "Purchase Requisition")
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeBuildTempPRNLLedgers(var PurchaseRequisitionHeader: Record "Purchase Requisition"; var PRNTempLedger: Record "Drug Ledger Entry" temporary
    ; var IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterBuildTempPRNLLedgers(var PRNTempLedger: Record "Drug Ledger Entry" temporary)
    begin

    end;
}
