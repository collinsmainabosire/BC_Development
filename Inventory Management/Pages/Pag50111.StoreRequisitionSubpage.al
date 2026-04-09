/// <summary>
/// Page Store Requisition Subpage (ID 50111).
/// </summary>
page 50111 "Store Requisition Subpage"
{
    ApplicationArea = All;
    Caption = 'Store Requisition Subpage';
    PageType = ListPart;
    SourceTable = "Store Requisition Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
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
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Item Balance"; Rec."Item Balance")
                {
                    ToolTip = 'Specifies the value of the Item balance field.', Comment = '%';
                }
            }
        }
    }
}
