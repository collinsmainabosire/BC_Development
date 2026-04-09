page 50107 "Purchase Requisition List"
{
    ApplicationArea = All;
    Caption = 'Purchase Requisition List';
    PageType = List;
    SourceTable = "Purchase Requisition";
    DeleteAllowed = false;
    CardPageId = "Purchase Requisition Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Req No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Req No. field.', Comment = '%';
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.', Comment = '%';
                }
                field("Requisition Type"; Rec."Requisition Type")
                {
                    ToolTip = 'Specifies the value of the Requsition Type field.', Comment = '%';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ToolTip = 'Specifies the value of the Requested By field.', Comment = '%';
                }
            }
        }
    }
}
