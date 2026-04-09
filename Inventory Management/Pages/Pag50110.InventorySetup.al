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

                field("Purchase No."; Rec."Purchase No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Purchase numbers';
                }
                field("SRN No."; Rec."SRN No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'SRN numbers';
                }
                field("Drug Nos"; Rec."Drug Nos")
                {
                    ApplicationArea = all;
                    ToolTip = 'Drug numbers';
                }
            }
        }
    }
}
