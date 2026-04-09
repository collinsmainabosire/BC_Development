codeunit 50101 "Drug Posting"
{
    /// <summary>
    /// Post.
    /// </summary>
    /// <param name="StoreRequisitionHeader">VAR Record "Store Requisition Header".</param>
    procedure Post(var StoreRequisitionHeader: Record "Store Requisition Header")
    var
        IsHandled: Boolean;
        BuildStoreRequisitionTempLedgers: Record "Drug Ledger Entry" temporary;
        AvailableStock: Integer;
        DrugLedger: Record "Drug Ledger Entry";
    begin
        AvailableStock := GetCurrentStock(DrugLedger."Drug No.");
        if AvailableStock < StoreRequisitionHeader.Quantity then
            Error('Insufficient stock for this drug.');
        IsHandled := false;
        OnBeforePost(StoreRequisitionHeader, IsHandled);
        ValidateStoreRequisition(StoreRequisitionHeader);
        LockStoreRequisition(StoreRequisitionHeader);
        ValidateStoreRequisitionStatus(StoreRequisitionHeader);
        ProcessPosting(BuildStoreRequisitionTempLedgers, StoreRequisitionHeader);
        FinalizePosting(StoreRequisitionHeader);
        OnAfterPost(StoreRequisitionHeader);
    end;

    //Validate the data integrity of the Store requisition
    local procedure ValidateStoreRequisition(var StoreRequisitionHeader: Record "Store Requisition Header")
    begin
        StoreRequisitionHeader.TestField("No.");
        StoreRequisitionHeader.TestField("Requested Date");
        StoreRequisitionHeader.TestField("Item No.");
        StoreRequisitionHeader.TestField("Item Description");
        StoreRequisitionHeader.TestField("Unit of Measure");
        StoreRequisitionHeader.TestField("Requested By");
        StoreRequisitionHeader.TestField(Status);
        StoreRequisitionHeader.TestField("Item Type");
        StoreRequisitionHeader.TestField(Quantity);
        if StoreRequisitionHeader.Quantity <= 0 then
            Error('Sorry your quanity %1 is either  zero or empty request valid items', StoreRequisitionHeader.Quantity);
    end;

    procedure GetCurrentStock(ItemNo: Code[20]): Decimal
    var
        Ledger: Record "Drug Ledger Entry";
    begin
        Ledger.SetRange("Drug No.", ItemNo);
        Ledger.CalcSums(Quantity);
        exit(Ledger.Quantity);
    end;
    //Lock the document to prevent two users from posting it
    /// <summary>
    /// LockStoreRequisition.
    /// </summary>
    /// <param name="StoreRequisitionHeader">VAR Record "Store Requisition Header".</param>
    Local procedure LockStoreRequisition(var StoreRequisitionHeader: Record "Store Requisition Header")
    begin
        StoreRequisitionHeader.LockTable();
        StoreRequisitionHeader.SetRange(StoreRequisitionHeader."No.");
    end;

    //Validation document state before posting
    local procedure ValidateStoreRequisitionStatus(var StoreRequisitionHeader: Record "Store Requisition Header")
    begin
        StoreRequisitionHeader.TestField(Status, StoreRequisitionHeader.Status::Released);
        if StoreRequisitionHeader.Status = StoreRequisitionHeader.Status::Posted then
            Error('%1 requisition has been posted, thank you', StoreRequisitionHeader."No.");
    end;

    //Building temporary ledger entries for store requsition
    local procedure BuildStoreRequisitionTempLedgers(var StoreRequisitionHeader: Record "Store Requisition Header";
    var TempDrugLedger: Record "Drug Ledger Entry" temporary)

    begin
        OnBeforeBuildTempLeaveLedger(StoreRequisitionHeader, TempDrugLedger);
        TempDrugLedger.Init();
        TempDrugLedger."Req No." := StoreRequisitionHeader."No.";
        TempDrugLedger."Date Created" := StoreRequisitionHeader."Requested Date";
        TempDrugLedger."Drug No." := StoreRequisitionHeader."Item No.";
        TempDrugLedger."Drug Name" := StoreRequisitionHeader."Item Description";
        TempDrugLedger."Unit of Measure" := StoreRequisitionHeader."Unit of Measure";
        TempDrugLedger."Requested By" := StoreRequisitionHeader."Requested By";
        TempDrugLedger."Requsition Type" := StoreRequisitionHeader."Requisition Type";
        TempDrugLedger.Type := StoreRequisitionHeader."Item Type";
        TempDrugLedger."Batch No." := StoreRequisitionHeader."Batch No.";
        TempDrugLedger."Expiry Date" := StoreRequisitionHeader."Expiry Date";
        TempDrugLedger.Quantity := -Abs(StoreRequisitionHeader.Quantity);
        TempDrugLedger.Insert();
        OnAfterBuildTempLeaveLedger(TempDrugLedger);
    end;

    //Validate Store Requisition Temporary Ledger
    local procedure ValidateStoreRequisitionTempLedgers(var BuildStoreRequisitionTempLedgers: Record "Drug Ledger Entry" temporary)
    begin
        if not BuildStoreRequisitionTempLedgers.FindSet() then
            Error('Nothing to post.');

        repeat
            if BuildStoreRequisitionTempLedgers.Quantity = 0 then
                Error('Ledger quantity cannot be zero.');
        until BuildStoreRequisitionTempLedgers.Next() = 0;
    end;

    //Process posting 
    local procedure ProcessPosting(var BuildStoreRequisitionTempLedgers: Record "Drug Ledger Entry" temporary; var StoreRequisitionHeader: Record "Store Requisition Header")
    begin
        BuildStoreRequisitionTempLedgers(StoreRequisitionHeader, BuildStoreRequisitionTempLedgers);
        ValidateStoreRequisitionTempLedgers(BuildStoreRequisitionTempLedgers);
        InsertStoreRequisitionTempLedgers(BuildStoreRequisitionTempLedgers);
    end;
    //Inserting temporary ledger to the real ledgers
    local procedure InsertStoreRequisitionTempLedgers(var BuildStoreRequisitionTempLedgers: Record "Drug Ledger Entry" temporary)
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
    local procedure FinalizePosting(var StoreRequisitionHeader: Record "Store Requisition Header")
    var
        StoreRequisitionLedger: Record "Drug Ledger Entry";
    begin

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

    //Event subsucriber for tempoerary ldegers builiding
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
