page 50114 "Drug Ledger API"
{
    APIGroup = 'pharmacy';
    APIPublisher = 'bcdev';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'drugLedgerAPI';
    DelayedInsert = true;
    EntityName = 'drugLedger';
    EntitySetName = 'drugLedgers';
    PageType = API;
    SourceTable = "Drug Ledger Entry";
    ODataKeyFields = SystemId;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'System Id';
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(drugNo; Rec."Drug No.")
                {
                    Caption = 'Drug No.';
                }
                field(drugName; Rec."Drug Name")
                {
                    Caption = 'Drug Name';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(unitOfMeasure; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                }
                field(postedBy; Rec."Posted By")
                {
                    Caption = 'Posted By';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posted On';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Error('You cannot insert ledger entries manually. Use posting.');
    end;
}
