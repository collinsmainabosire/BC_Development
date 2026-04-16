codeunit 50101 "Store Requisition Posting"
{
    procedure PostStoreRequisition(var Header: Record "Store Requisition Header")
    var
        TempLedger: Record "Drug Ledger Entry" temporary;
        IsHandled: Boolean;
    begin
        OnBeforePost(Header, IsHandled);
        if IsHandled then
            exit;

        ValidateHeader(Header);
        ValidateStatus(Header);
        CheckIfAlreadyPosted(Header);
        LockHeader(Header);
        BuildTempLedgerEntries(Header, TempLedger);
        ValidateTempLines(TempLedger);
        InsertLedgerEntries(TempLedger);
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

        StoreRequisitionHeader.Reset();
        StoreRequisitionHeader.SetRange("No.", StoreRequisitionHeader."No.");
        StoreRequisitionHeader.FindFirst();
        StoreRequisitionHeader.LockTable();

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
    var
        TempDrugLedger: Record "Drug Ledger Entry" temporary)
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
                TempDrugLedger."Document No." := Line."Document No.";
                TempDrugLedger."Line No." := Line."Line No.";
                TempDrugLedger."Date Created" := Header."Requested Date";
                TempDrugLedger."Created By" := Header."Requested By";
                TempDrugLedger.Type := Line."Item Type";
                TempDrugLedger."Unit of Measure" := Line."Unit of Measure";
                TempDrugLedger."Batch No." := Line."Batch No.";
                TempDrugLedger."Posting Date" := CurrentDateTime;

                if GetBatchStock(Line."Item No.", Line."Batch No.") < Abs(Line.Quantity) then
                    Error('Insufficient stock for Item %1 Batch %2', Line."Item No.", Line."Batch No.");

                TempDrugLedger.Insert();
            until Line.Next() = 0;

        if GetBatchStock(TempDrugLedger."Drug No.", TempDrugLedger."Batch No.") < Abs(TempDrugLedger.Quantity) then
            Error(
                'Insufficient stock for Item %1 Batch %2. Available: %3',
                TempDrugLedger."Drug No.",
                TempDrugLedger."Batch No.",
                GetBatchStock(TempDrugLedger."Drug No.", TempDrugLedger."Batch No.")
            );
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

    /// <summary>
    /// GetBatchStock.
    /// </summary>
    /// <param name="ItemNo">Code[20].</param>
    /// <param name="BatchNo">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetBatchStock(ItemNo: Code[20]; BatchNo: Code[20]): Decimal
    var
        Ledger: Record "Drug Ledger Entry";
    begin
        Ledger.SetRange("Drug No.", ItemNo);
        Ledger.SetRange("Batch No.", BatchNo);
        Ledger.CalcSums(Quantity);
        exit(Ledger.Quantity);

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
                StoreRequisitionLedger.Insert(true);
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
