page 50101 "Drug Card"
{
    ApplicationArea = All;
    Caption = 'Drug card';
    PageType = Card;
    SourceTable = "Drug Header";
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Drug No."; Rec."Drug No.")
                {
                    ToolTip = 'Specifies the value of the Drug No. field.', Comment = '%';
                }
                field("Drug Name"; Rec."Drug Name")
                {
                    ToolTip = 'Specifies the value of the Drug Name field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
                field(Quantity; Rec.Inventory)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("created by"; Rec."created by")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
            }
        }
    }
}
