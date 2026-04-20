page 50113 "Drug API"
{
    APIGroup = 'Phamarcy';
    APIPublisher = 'BCDev';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'DrugAPI';
    DelayedInsert = true;
    EntityName = 'Drug';
    EntitySetName = 'Drugs';
    PageType = API;
    SourceTable = "Drug Header";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ID; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(DrugName; Rec."Drug Name")
                {
                    Caption = 'Drug Name';
                }
                field(UnitOfMeasure; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                }
            }
        }
    }
}
