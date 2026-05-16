namespace ERP.ERP;

codeunit 50116 "tudent App Approval Mgt"
{
    procedure SendStudentApplicationForApproval(var StudentApplication: Record "Student Application")
    begin
        OnSendStudentApplicationForApproval(StudentApplication);
    end;
}
