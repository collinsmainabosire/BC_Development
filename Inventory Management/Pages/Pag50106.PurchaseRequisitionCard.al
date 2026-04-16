page 50106 "Purchase Requisition Card"
{
    ApplicationArea = All;
    Caption = 'Purchase Requisition Card';
    PageType = Card;
    SourceTable = "Purchase Requisition";
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Req No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Req No. field.', Comment = '%';
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.', Comment = '%';
                    Editable = false;
                }
                field("Requisition Type"; Rec."Requisition Type")
                {
                    ToolTip = 'Specifies the value of the Requsition Type field.', Comment = '%';

                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ToolTip = 'Specifies the value of the Requested By field.', Comment = '%';
                    Editable = false;
                }
            }
            part(Lines; "Purchase Line ListPart")
            {
                SubPageLink = "Document No." = field("No.");
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PurchasePosting: Codeunit "Inventory Posting Engine";
                //Header: Record "Purchase Requisition";
                begin
                    if Confirm('Do you want to post this requisition application?', true) then begin
                        PurchasePosting.PostDocument(Rec."No.", Rec."Requisition Type");

                        //Only runs if posting succeeded
                        Message('Requisition  %1 %2 posted successfully.', Rec."No.", Rec."Requisition Type");
                        CurrPage.Update();
                    end;
                end;
            }
        }
    }
}
