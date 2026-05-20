namespace ERP.ERP;

using System.Automation;

codeunit 50121 "Student Approval Mgmt"
{
    /// <summary>
    /// SendApprovalRequest.
    /// </summary>
    /// <param name="StudentApplication">VAR Record "Student Application".</param>
    procedure SendApprovalRequest(var StudentApplication: Record "Student Application")
    begin
        CheckStudentApplicationApprovalWorkflowEnabled(StudentApplication);

        OnSendStudentApplicationForApproval(StudentApplication);
    end;

    local procedure CheckStudentApplicationApprovalWorkflowEnabled(var StudentApplication: Record "Student Application")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        if not WorkflowManagement.CanExecuteWorkflow(StudentApplication,
           StudentApplicationWorkflowEventCode())
        then
            Error('No approval workflow exists for this document.');
    end;

    /// <summary>
    /// StudentApplicationWorkflowEventCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure StudentApplicationWorkflowEventCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendStudentApplicationApproval'));
    end;

    /// <summary>
    /// OnSendStudentApplicationForApproval.
    /// </summary>
    /// <param name="StudentApplication">VAR Record "Student Application".</param>
    [IntegrationEvent(false, false)]
    procedure OnSendStudentApplicationForApproval(var StudentApplication: Record "Student Application")
    begin
    end;

    /// <summary>
    /// OnCancelStudentApplicationApprovalRequest.
    /// </summary>
    /// <param name="StudentApplication">VAR Record "Student Application".</param>
    [IntegrationEvent(false, false)]
    procedure OnCancelStudentApplicationApprovalRequest(var StudentApplication: Record "Student Application")
    begin
    end;
}
