xmlport 50100 "Drug Import"
{
    Caption = 'Drug Import';
    Direction = Import;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(DrugHeader; "Drug Header")
            {
                fieldelement(No; DrugHeader."No.")
                {
                }
                fieldelement(DrugName; DrugHeader."Drug Name")
                {
                }
                fieldelement(UnitofMeasure; DrugHeader."Unit of Measure")
                {
                }
                fieldelement(Type; DrugHeader."Type")
                {
                }
                trigger OnBeforeInsertRecord()
                var
                    ExistingDrug: Record "Drug Header";
                begin
                    if ExistingDrug."No." = '' then
                        Error('Drug number cannot be empty');

                    if ExistingDrug.Get(DrugHeader."No.") then
                        Error('Drug 1% already exisits', DrugHeader."No.");
                end;
            }
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

}
