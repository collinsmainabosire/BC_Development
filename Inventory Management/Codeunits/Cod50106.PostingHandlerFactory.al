codeunit 50106 "Posting Handler Factory"
{
    /// <summary>
    /// GetHandler.
    /// </summary>
    /// <param name="Type">Enum "Requisition Type".</param>
    /// <returns>Return value of type Interface InventoryPostingInterface.</returns>
    procedure GetHandler(Type: Enum "Requisition Type"): Interface InventoryPostingInterface
    var
        StorePosting: Codeunit "Store Requisition Posting";
        PurchasePosting: Codeunit "Post Purchase";
    begin
        case Type of
            Type::Store:
                exit(StorePosting);

            Type::Purchase:
                exit(PurchasePosting);
        end;

        Error('No handler found for type %1', Type);
    end;
}
