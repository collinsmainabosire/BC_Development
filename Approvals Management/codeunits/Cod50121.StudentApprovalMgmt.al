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
        OnCancelStudentApplicationForApproval(StudentApplication);
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
  /// OnCancelStudentApplicationForApproval.
  /// </summary>
  /// <param name="StudentApplication">VAR Record "Student Application".</param>
  [IntegrationEvent(false, false)]
    procedure OnCancelStudentApplicationForApproval(var StudentApplication: Record "Student Application")
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

    /// <summary>
    /// SetStatusToPendingApproval.
    /// </summary>
    /// <param name="StudentApplication">VAR Record "Student Application".</param>
    procedure SetStatusToPendingApproval(var StudentApplication: Record "Student Application")
    begin
        StudentApplication.Status := StudentApplication.Status::"Pending Approval";
        StudentApplication.Modify(true);
    end;

    /// <summary>
    /// SetStatusToApproved.
    /// </summary>
    /// <param name="StudentApplication">VAR Record "Student Application".</param>
    procedure SetStatusToApproved(var StudentApplication: Record "Student Application")
    begin
        StudentApplication.Status := StudentApplication.Status::Approved;
        StudentApplication.Modify(true);
    end;

    /// <summary>
    /// SetStatusToRejected.
    /// </summary>
    /// <param name="StudentApplication">VAR Record "Student Application".</param>
    procedure SetStatusToRejected(var StudentApplication: Record "Student Application")
    begin
        StudentApplication.Status := StudentApplication.Status::Rejected;
        StudentApplication.Modify(true);
    end;

    /// <summary>
    /// ReOpenDocument.
    /// </summary>
    /// <param name="StudentApplication">VAR Record "Student Application".</param>
    procedure ReOpenDocument(var StudentApplication: Record "Student Application")
    begin
        StudentApplication.Status := StudentApplication.Status::Open;
        StudentApplication.Modify(true);
    end;
}
