namespace ERP.ERP;

using System.Automation;

codeunit 50123 "Student Workflow Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Student Approval Mgmt", 'OnSendStudentApplicationForApproval', '', false, false)]
    local procedure RunWorkflowOnSendStudentApplicationForApproval(var StudentApplication: Record "Student Application")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent('RunWorkflowOnSendStudentApplicationApproval', StudentApplication);
    end;
      [EventSubscriber(ObjectType::Codeunit, Codeunit::"Student Approval Mgmt", 'OnCancelStudentApplicationForApproval', '', false, false)]
    local procedure RunWorkflowOnCancelStudentApplicationForApproval(var StudentApplication: Record "Student Application")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent('RunWorkflowOnCancelStudentApplicationApproval', StudentApplication);
    end;
}
