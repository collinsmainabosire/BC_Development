/// <summary>
/// Page Store Requisition List (ID 50103).
/// </summary>
page 50103 "Store Requisition List"
{
    ApplicationArea = All;
    Caption = 'Store Requisition List';
    PageType = List;
    SourceTable = "Store Requisition Header";
    DeleteAllowed = false;
    CardPageId = "Store Requisition Card";

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
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
                }
                field("Item Type"; Rec."Item Type")
                {
                    ToolTip = 'Specifies the value of the Item Type field.', Comment = '%';
                }
                field("Requisition Type"; Rec."Requisition Type")
                {
                    ToolTip = 'Specifies the value of the Requsition Type field.', Comment = '%';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Item Balance"; Rec."Item Balance")
                {
                    ToolTip = 'Specifies the value of the Item Balance field.', Comment = '%';
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
