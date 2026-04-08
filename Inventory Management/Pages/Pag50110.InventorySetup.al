page 50110 "Store Setup"
{
    ApplicationArea = All;
    Caption = 'Inventory Setup';
    PageType = List;
    SourceTable = "Store Setup";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Drug Nos"; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Drug numbers';
                }
                field("Purchase No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Purchase numbers';
                }
                field("SRN No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'SRN numbers';
                }
            }
        }
    }
}
