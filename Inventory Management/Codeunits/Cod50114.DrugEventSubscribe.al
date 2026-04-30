namespace ERP.ERP;

codeunit 50114 "Drug Event Subscribe"
{
    [EventSubscriber(ObjectType::Table, Database::"Drug Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnDrugInserted(var Rec: Record "Drug Header")
    begin
        Message('Drug inserted: %1', Rec."Drug Name");
    end;
}
