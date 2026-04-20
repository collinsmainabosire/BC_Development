codeunit 50108 "Inventory Query Service"
{
    procedure GetInventory()
    var
        InvQuery: Query "Inventory Summary";
    begin
        InvQuery.Open();

        while InvQuery.Read() do begin
            Message('%1  - %3', InvQuery.DrugNo, InvQuery.Quantity);
        end;

        InvQuery.Close();
    end;
}
