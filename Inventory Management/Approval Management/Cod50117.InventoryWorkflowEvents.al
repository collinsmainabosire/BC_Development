namespace ERP.ERP;

using System.Automation;

codeunit 50117 "InventoryWorkflow Events"
{
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        InventoryApprovalMgmt: Codeunit "Inventory Approval Mgmt";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure AddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(InventoryApprovalMgmt.RunWorkflowOnSendSRNApprovalCode(), Database::"Store Requisition Header", 'Approval requested for Inventory.', 0, false);

        WorkflowEventHandling.AddEventToLibrary(InventoryApprovalMgmt.RunWorkflowOnCancelSRNApprovalCode(), Database::"Store Requisition Header", 'Approval cancelled for Inventory.', 0, false);
    end;
}
