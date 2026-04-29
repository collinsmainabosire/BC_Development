page 50116 "Drug Inbound API"
{
    APIGroup = 'pharmacy';
    APIPublisher = 'bddev';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'drugInboundAPI';
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
}
