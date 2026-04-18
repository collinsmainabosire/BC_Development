codeunit 50105 "Inventory Posting Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Post Purchase", OnAfterPost, '', false, false)]
    local procedure LogPostPurchase(var Header: Record "Purchase Requisition")
    begin
        Message('Purchase Posted successfully', Header."No.");
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
                    Error('Quantity of %1 of line %2  item %exceeds recommended purchase', Line."Document No.", Line."Line No.", Line."Item Description");
                IsHandled := true;
            until Line.next() = 0;
    end;
}
