namespace ERP.ERP;

page 50113 Drug
{
    APIGroup = 'pharmacy';
    APIPublisher = 'training';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'drug';
    DelayedInsert = true;
    EntityName = 'drug';
    EntitySetName = 'drugs';
    PageType = API;
    SourceTable = "Drug Header";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(drugName; Rec."Drug Name")
                {
                    Caption = 'Drug Name';
                }
                field(unitOfMeasure; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                }
            }
        }
    }
    var
        DrugMgt: Codeunit "Drug Management";

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        DrugMgt.CreateDrug(Rec."No.", Rec."Drug Name", Rec."Unit of Measure", Rec.Type);

        exit(false);
    end;
}
