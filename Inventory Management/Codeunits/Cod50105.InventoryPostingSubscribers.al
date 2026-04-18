codeunit 50105 "Inventory Posting Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Post Purchase", OnAfterPost, '', false, false)]
    local procedure LogPostPurchase(var Header: Record "Purchase Requisition")
    begin
        Message('Purchase Posted successfully', Header."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Post Purchase", 'OnBeforePost', '', false, false)]
    local procedure RequireApproval(var Header: Record "Purchase Requisition"; var IsHandled: Boolean)
    begin
        if Header.Status <> Header.Status::Released then
            Error('Document %1 must be approved before posting', Header."No.");
    end;
    //preventing posting of purchase of quantities above 100
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Post Purchase", OnBeforeBuildTempPRNLLedgers, '', false, false)]
    local procedure BlocklargePurchage(var PurchaseRequisitionHeader: Record "Purchase Requisition";
    var PRNTempLedger: Record "Drug Ledger Entry" temporary; var IsHandled: Boolean)
    var
        Line: Record "Purchase Requisition Line";
    begin
        Line.SetRange("Document No.", PurchaseRequisitionHeader."No.");
        if Line.FindSet() then
            repeat
                if Line.Quantity > 100 then
                    Error('Quantity of %1 of line %2  item %3 %4 exceeds recommended purchase', Line."Document No.", Line."Line No.", Line."Item No.", Line."Item Description");
            //IsHandled := true;
            until Line.next() = 0;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Post Purchase", 'OnBeforeBuildTempPRNLLedgers', '', false, false)]
    local procedure LimitTotalQuantity(var PurchaseRequisitionHeader: Record "Purchase Requisition"; var PRNTempLedger: Record "Drug Ledger Entry" temporary;
    var IsHandled: Boolean)
    var
        Line: Record "Purchase Requisition Line";
        TotalQty: Decimal;
    begin
        Line.SetRange("Document No.", PurchaseRequisitionHeader."No.");

        if Line.FindSet() then
            repeat
                TotalQty += Line.Quantity;
            until Line.Next() = 0;

        if TotalQty > 500 then
            Error('Total quantity exceeds allowed limit');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Post Purchase", 'OnAfterPost', '', false, false)]
    local procedure LogPosting(var Header: Record "Purchase Requisition")
    var
        Ishandled: Boolean;
    begin
        //Ishandled := true;
        Message('PRN %1 posted by %2 at %3', Header."No.", UserId, CurrentDateTime);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Post Purchase", 'OnBeforePost', '', false, false)]
    local procedure RestrictPostingTime(var Header: Record "Purchase Requisition"; var IsHandled: Boolean)
    begin
        if Time > 180000T then
            Error('Posting not allowed after 6 PM');
    end;
}
