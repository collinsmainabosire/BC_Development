page 50110 "Inventory Setups"
{
    ApplicationArea = All;
    Caption = 'Inventory Setup';
    PageType = List;
    SourceTable = "Inventory Setups";

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
