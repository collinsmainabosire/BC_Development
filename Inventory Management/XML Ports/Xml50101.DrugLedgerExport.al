xmlport 50101 "Drug Ledger Export"
{
    Caption = 'Drug Ledger Export';
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(DrugLedgerEntry; "Drug Ledger Entry")
            {
                fieldelement(EntryNo; DrugLedgerEntry."Entry No.")
                {
                }
                fieldelement(DrugNo; DrugLedgerEntry."Drug No.")
                {
                }
                fieldelement(DocumentNo; DrugLedgerEntry."Document No.")
                {
                }
                fieldelement(Quantity; DrugLedgerEntry.Quantity)
                {
                }
                fieldelement(PostedBy; DrugLedgerEntry."Posted By")
                {
                }
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
    trigger OnPreXmlPort()
    var
        Ledger: Record "Drug Ledger Entry";
    begin
        Ledger.SetRange(Status, Ledger.Status::Posted);
    end;
}
