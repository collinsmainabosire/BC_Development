page 50100 "Drug Type List"
{
    ApplicationArea = All;
    Caption = 'Drug Type List';
    PageType = List;
    SourceTable = "Drug Type";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field("Drug Type"; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Drug Type field.', Comment = '%';
                }
            }
        }
    }
}
