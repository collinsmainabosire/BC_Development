page 50113 "Drug API"
{
    APIGroup = 'phamarcy';
    APIPublisher = 'bcdev';
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
                field(id; Rec.SystemId)
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
}
