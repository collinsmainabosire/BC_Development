query 50100 "Inventory Summary"
{
    Caption = 'Inventory Summary';
    QueryType = Normal;

    elements
    {
        dataitem(DrugLedgerEntry; "Drug Ledger Entry")
        {
            DataItemTableFilter = Status = const(Posted);
            column(DrugNo; "Drug No.")
            {
            }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
            column(ReqNo; "Req No.")
            {
            }
            column(BatchNo; "Batch No.")
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
