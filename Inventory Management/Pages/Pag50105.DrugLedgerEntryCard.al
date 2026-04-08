page 50105 "Drug Ledger Entry Card"
{
    ApplicationArea = All;
    Caption = 'Drug Ledger Entry Card';
    PageType = Card;
    SourceTable = "Drug Ledger Entry";
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
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
                field(Quantity; Rec.Quantity)
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
                field("Requsition Type"; Rec."Requsition Type")
                {
                    ToolTip = 'Specifies the value of the Requsition Type field.', Comment = '%';
                    Editable = false;
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
