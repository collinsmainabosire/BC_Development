namespace ERP.ERP;

codeunit 50113 "Drug Query API"
{

    [ServiceEnabled]
    procedure GetAllDrugs(): Text
    var
        DrugService: Codeunit "Drug Query Service";
    begin
        exit(DrugService.GetDrugs());
    end;
}
