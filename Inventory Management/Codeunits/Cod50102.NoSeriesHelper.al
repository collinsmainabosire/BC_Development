codeunit 50102 "No. Series Helper"
{
    //Drug number series set
    procedure GetDrugNo(): Code[20]
    var
        SetUp: Record "Store Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        SetUp.Get();
        SetUp.TestField("Drug Nos");
        Exit(NoSeriesMgt.GetNextNo(SetUp."Drug Nos", WorkDate, true));
    end;

    /// <summary>
    /// GetStoreNoReq.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure GetStoreNoReq(): Code[20]
    var
        SetUp: Record "Store Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        SetUp.Get();
        SetUp.TestField("SRN No.");
        exit(NoSeriesMgt.GetNextNo(SetUp."SRN No.", WorkDate, true));
    end;

    /// <summary>
    /// GetPurchaseNo.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure GetPurchaseNo(): Code[20]
    var
        SetUp: Record "Store Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        SetUp.Get();
        SetUp.TestField("Purchase No.");
        exit(NoSeriesMgt.GetNextNo(SetUp."Purchase No.", WorkDate, true));
    end;
}
