codeunit 50103 "Inventory Posting Engine"
{
    procedure PostDocument(DocumentNo: Code[20]; DocType: Enum "Requisition Type")
    var
        StoreHeader: Record "Store Requisition Header";
        StorePosting: Codeunit "Store Requisition Posting";
        PurchaseHeader: Record "Purchase Requisition";
        PurchasePost: Codeunit "PRN Posting";
    begin
        if DocumentNo = '' then
            Error('Document No. is required.');

        case DocType of
            DocType::Store:
                begin
                    if not StoreHeader.Get(DocumentNo) then
                        Error('Store Requisition %1 not found.', DocumentNo);

                    StorePosting.PostStoreRequisition(StoreHeader);
                end;

            DocType::Purchase:
                begin
                    if not PurchaseHeader.Get(DocumentNo) then
                        Error('Purchase Requisition %1 not found.', DocumentNo);

                    PurchasePost.PostPurchase(PurchaseHeader);
                end;

            else
                Error('Unsupported Document Type');
        end;
    end;
}
