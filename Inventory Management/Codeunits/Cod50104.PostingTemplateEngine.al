codeunit 50104 "Posting Template Engine"
{
    /// <summary>
    /// RunPosting.
    /// </summary>
    /// <param name="DocumentNo">Code[20].</param>
    /// <param name="HeaderVariant">Variant.</param>
    /// <param name="PostingHandler">VAR Interface InventoryPostingInterface.</param>
    procedure RunPosting(DocumentNo: Code[20]; HeaderVariant: Variant; var PostingHandler: Interface InventoryPostingInterface)
    begin
        //Load document
        PostingHandler.PreValidate(DocumentNo);
        //Main post exceution
        PostingHandler.Post(DocumentNo);
    end;
}
