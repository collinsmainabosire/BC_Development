codeunit 50105 "Inventory Posting Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Post Purchase", OnAfterPost, '', false, false)]
    local procedure LogPostPurchase(var Header: Record "Purchase Requisition")
    begin
        Message('Purchase Posted successfully', Header."No.");
    end;

}
