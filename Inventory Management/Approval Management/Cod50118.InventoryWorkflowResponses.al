namespace ERP.ERP;

using System.Automation;

codeunit 50118 "Inventory Workflow Responses"
{
    var
    WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    [EventSubscriber(ObjectType::Codeunit,Codeunit::"Workflow Response Handling",  'OnAddWorkflowResponsesToLibrary','', true, true)]
     local procedure AddResponsesToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CreateSRNApprovalCode(), 0,'Create SRN Approval', 'GROUP 0');
    end;
     procedure CreateSRNApprovalCode(): Code[128]
    begin
        exit('CREATESRNAPPROVAL');
    end;
}
