codeunit 50103 "Inventory Posting Service"
{
    procedure PostDocument(DocumentNo: Code[20]; Type: Enum "Requisition Type")
    var
        Engine: Codeunit "Inventory Posting Engine";
        Handler: Interface InventoryPostingInterface;
        Factory: Codeunit "Posting Handler Factory";
    begin
        Handler := Factory.GetHandler(Type);
        Engine.RunPosting(DocumentNo, Handler);
    end;
}

