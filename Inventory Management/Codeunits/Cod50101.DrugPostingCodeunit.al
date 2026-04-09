codeunit 50101 "Drug Posting"
{
    procedure Post(var Header: Record "Store Requisition Header")
    var
        TempLedger: Record "Drug Ledger Entry" temporary;
        IsHandled: Boolean;
    begin
        OnBeforePost(Header, IsHandled);
        if IsHandled then
            exit;

        ValidateHeader(Header);
        LockHeader(Header);
        ValidateStatus(Header);
        CheckIfAlreadyPosted(Header);
        ProcessPosting(TempLedger, Header);
        Finalize(Header);
        OnAfterPost(Header);
    end;

    //Validate the data integrity of the Store requisition
    local procedure ValidateHeader(var StoreRequisitionHeader: Record "Store Requisition Header")
    begin
        StoreRequisitionHeader.TestField("No.");
        StoreRequisitionHeader.TestField("Requested Date");
        StoreRequisitionHeader.TestField("Requested By");
        StoreRequisitionHeader.TestField(Status);
    end;

    //Lock the document to prevent two users from posting it
    /// <summary>
    /// LockStoreRequisition.
    /// </summary>
    /// <param name="StoreRequisitionHeader">VAR Record "Store Requisition Header".</param>
    Local procedure LockHeader(var StoreRequisitionHeader: Record "Store Requisition Header")
    begin

        StoreRequisitionHeader.LockTable();
        if not StoreRequisitionHeader.Get(StoreRequisitionHeader."No.") then
            Error('Document not found');
        if StoreRequisitionHeader.Status = StoreRequisitionHeader.Status::Posted then
            Error('Document already posted');
        StoreRequisitionHeader.SetRange(StoreRequisitionHeader."No.");
    end;

    //Validation document state before posting
    local procedure ValidateStatus(var StoreRequisitionHeader: Record "Store Requisition Header")
    begin
        StoreRequisitionHeader.TestField(Status, StoreRequisitionHeader.Status::Released);
        if StoreRequisitionHeader.Status = StoreRequisitionHeader.Status::Posted then
            Error('%1 requisition has been posted, thank you', StoreRequisitionHeader."No.");
    end;

    local procedure CheckIfAlreadyPosted(Header: Record "Store Requisition Header")
    var
        Ledger: Record "Drug Ledger Entry";
    begin
        Ledger.SetRange("Req No.", Header."No.");
        if Ledger.FindFirst() then
            Error('Entries already exist for document %1', Header."No.");
    end;

    //Building temporary ledger entries for store requsition
    local procedure BuildTempLedgerEntries(var Header: Record "Store Requisition Header";
    var TempDrugLedger: Record "Drug Ledger Entry" temporary)
    var
        Line: Record "Store Requisition Line";
    begin
        OnBeforeBuildTempLeaveLedger(Header, TempDrugLedger);
        Line.SetRange("Document No.", Header."No.");
        if Line.FindSet() then
            repeat
                TempDrugLedger.Init();
                TempDrugLedger."Drug No." := Line."Item No.";
                TempDrugLedger."Drug Name" := Line."Item Description";
                TempDrugLedger.Quantity := -Abs(Line.Quantity);
                TempDrugLedger."Req No." := Line."Document No.";
                TempDrugLedger."Requsition Type" := Header."Requisition Type";
                TempDrugLedger.Status := Header.Status;
                TempDrugLedger."Posting Date" := CurrentDateTime;
                TempDrugLedger.Insert();
            until Line.Next() = 0;
        OnAfterBuildTempLeaveLedger(TempDrugLedger);
    end;

    //Validate Store Requisition Temporary Ledger
    local procedure ValidateTempLines(var TempDrugLedgEntry: Record "Drug Ledger Entry" temporary)
    begin
        if not TempDrugLedgEntry.FindSet() then
            Error('Nothing to post.');

        repeat
            if TempDrugLedgEntry.Quantity = 0 then
                Error('Ledger quantity cannot be zero.');
        until TempDrugLedgEntry.Next() = 0;

    end;

    //Process posting 
    local procedure ProcessPosting(var BuildStoreRequisitionTempLedgers: Record "Drug Ledger Entry" temporary; var Header: Record "Store Requisition Header")
    begin
        if Header.Status = Header.Status::Posted then
            Error('Document already posted.');
        BuildTempLedgerEntries(Header, BuildStoreRequisitionTempLedgers);
        ValidateTempLines(BuildStoreRequisitionTempLedgers);
        CheckIfPosted(Header);
        InsertLedgerEntries(BuildStoreRequisitionTempLedgers);
    end;
    //checking if the document is already posted
    local procedure CheckIfPosted(var Header: Record "Store Requisition Header")
    var
        Ledger: Record "Drug Ledger Entry";
    begin
        Header.SetRange(header."No.", Ledger."Req No.");
        if Ledger.FindFirst() then
            Error('Entries already exist for document %1', Header."No.");
    end;
    //Inserting temporary ledger to the real ledgers
    local procedure InsertLedgerEntries(var BuildStoreRequisitionTempLedgers: Record "Drug Ledger Entry" temporary)
    var
        StoreRequisitionLedger: Record "Drug Ledger Entry";
    begin
        if BuildStoreRequisitionTempLedgers.FindSet() then
            repeat
                StoreRequisitionLedger.Init();
                StoreRequisitionLedger.TransferFields(BuildStoreRequisitionTempLedgers, false);
                StoreRequisitionLedger."Entry No." := 0;
                StoreRequisitionLedger.Insert(false);
            until BuildStoreRequisitionTempLedgers.Next() = 0;

    end;

    //Finalize Posting
    local procedure Finalize(var Header: Record "Store Requisition Header")
    var
        StoreRequisitionLedger: Record "Drug Ledger Entry";
    begin
        Header.Status := Header.Status::Posted;
        Header.Modify(true);
    end;
    //Events
    [IntegrationEvent(false, false)]
    local procedure OnBeforePost(var StoreRequisitionHeader: Record "Store Requisition Header"; var IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPost(var StoreRequisitionHeader: Record "Store Requisition Header")
    begin

    end;

    //Event subsucriber for tempoerary ledgers builiding
    [IntegrationEvent(false, false)]
    local procedure OnBeforeBuildTempLeaveLedger(var StoreRequisitionHeader: Record "Store Requisition Header";
    var BuildStoreRequisitionTempLedgers: Record "Drug Ledger Entry" temporary)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterBuildTempLeaveLedger(var BuildStoreRequisitionTempLedgers: Record "Drug Ledger Entry" temporary)
    begin

    end;
}
