codeunit 50104 "Inventory Posting Engine"
{
    /// <summary>
    /// RunPosting.
    /// </summary>
    /// <param name="DocumentNo">Code[20].</param>
    /// <param name="PostingHandler">VAR Interface InventoryPostingInterface.</param>
    procedure RunPosting(DocumentNo: Code[20]; PostingHandler: Interface InventoryPostingInterface)
    begin
        //Load document
        PostingHandler.PreValidate(DocumentNo);
        //Main post exceution
        PostingHandler.Post(DocumentNo);
    end;
}
