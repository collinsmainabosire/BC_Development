namespace ERP.ERP;

codeunit 50116 "Student App Approval Mgt"
{
    procedure SendStudentApplicationForApproval(var StudentApplication: Record "Store Requisition Header")
    begin
        OnSendStudentApplicationForApproval(StudentApplication);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendStudentApplicationForApproval(var StudentApplication: Record "Store Requisition Header")
    begin
    end;
}
