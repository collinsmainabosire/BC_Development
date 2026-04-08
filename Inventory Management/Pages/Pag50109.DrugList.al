page 50109 "Drug List"
{
    ApplicationArea = All;
    Caption = 'Drug List';
    PageType = List;
    SourceTable = "Drug Header";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
                field(Inventory; Rec.Inventory)
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
                field("Posted By"; Rec."Posted By")
                {
                    ToolTip = 'Specifies the value of the Posted By field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posted By field.', Comment = '%';
                }
            }
        }
    }
}
