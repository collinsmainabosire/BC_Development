namespace ERP.ERP;

using System.Automation;

codeunit 50122 "Student Workflow Event Handlin"
{
    procedure RunWorkflowOnSendStudentApplicationApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendStudentApplicationApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddStudentWorkflowEventsToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(
            RunWorkflowOnSendStudentApplicationApprovalCode(), Database::"Student Application",'Approval of a student application is requested.', 0, false);
    end;
}
