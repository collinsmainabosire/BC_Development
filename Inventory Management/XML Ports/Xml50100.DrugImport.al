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
                    Drug: Record "Drug Header";
                    DrugMgt: Codeunit "Drug Management";
                begin
                    DrugMgt.CreateDrug(Drug."Drug Name", Drug."Unit of Measure", Drug.Type);
                    CurrXMLport.Skip();
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
