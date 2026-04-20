page 50114 "Drug Ledger API"
{
    APIGroup = 'phamarcy';
    APIPublisher = 'bcdev';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'drugLedgerAPI';
    DelayedInsert = true;
    EntityName = 'drugLedger';
    EntitySetName = 'drugLedgers';
    PageType = API;
    SourceTable = "Drug Ledger Entry";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
    trigger OnOpenPage()
    begin
        Rec.SetRange(Status, Rec.Status::Posted);
    end;
}
