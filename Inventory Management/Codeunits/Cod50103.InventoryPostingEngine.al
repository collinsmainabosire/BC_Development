codeunit 50103 "Inventory Posting Engine"
{
    procedure PostDocument(DocumentNo: Code[20]; DocType: Enum "Requisition Type")
    var
        StoreHeader: Record "Store Requisition Header";
        StorePosting: Codeunit "Store Requisition Posting";
        PurchaseHeader: Record "Purchase Requisition";
        PurchasePost: Codeunit "PRN Posting";
    begin

        case DocType of
            DocType::Store:
                begin
                    StoreHeader.Get(DocumentNo);
                    StorePosting.PostStoreRequisition(StoreHeader);
                end;

            DocType::Purchase:
                begin
                    PurchaseHeader.Get(DocumentNo);
                    PurchasePost.PostPurchase(PurchaseHeader);
                end;

            else
                Error('unsupported Document type');
        end;
    end;
}
