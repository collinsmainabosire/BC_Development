namespace ERP.ERP;

codeunit 50124 "Student Workflow Response Hand"
{
    procedure SetPendingApproval(var Variant: Variant)
    var
        StudentApplication: Record "Student Application";
    begin
        RecRefToStudentApplication(Variant, StudentApplication);

        StudentApplication.Status := StudentApplication.Status::"Pending Approval";

        StudentApplication.Modify(true);
    end;

    procedure ReleaseDocument(var Variant: Variant)
    var
        StudentApplication: Record "Student Application";
    begin
        RecRefToStudentApplication(Variant, StudentApplication);

        StudentApplication.Status := StudentApplication.Status::Approved;

        StudentApplication.Modify(true);
    end;

    procedure RejectDocument(var Variant: Variant)
    var
        StudentApplication: Record "Student Application";
    begin
        RecRefToStudentApplication(Variant, StudentApplication);

        StudentApplication.Status := StudentApplication.Status::Rejected;

        StudentApplication.Modify(true);
    end;

    local procedure RecRefToStudentApplication(Variant: Variant; var StudentApplication: Record "Student Application")
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
            Database::"Student Application":
                RecRef.SetTable(StudentApplication);
        end;
    end;
}
