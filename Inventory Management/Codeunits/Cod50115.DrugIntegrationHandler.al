namespace ERP.ERP;

codeunit 50115 "Drug Integration Handler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Drug Management", 'OnAfterDrugCreated', '', false, false)]
    local procedure HandleDrugCreated(No: Code[20]; DrugName: Text)
    begin
        Message('Integration Event Fired: %1 created', DrugName);
    end;
}
