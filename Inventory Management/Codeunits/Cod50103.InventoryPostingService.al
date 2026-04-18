codeunit 50103 "Inventory Posting Service"
{
    procedure PostDocument(DocumentNo: Code[20]; Type: Enum "Requisition Type")
    var
        Engine: Codeunit "Inventory Posting Engine";
        Handler: Interface InventoryPostingInterface;
        StorePosting: Codeunit "Store Requisition Posting";
        PurchasePosting: Codeunit "Post Purchase";
    begin
        case Type of
            Type::Store:
                Handler := StorePosting;

            Type::Purchase:
                Handler := PurchasePosting;

            else
                Error('Unsupported document type');
        end;

        Engine.RunPosting(DocumentNo, Handler);
    end;
}

