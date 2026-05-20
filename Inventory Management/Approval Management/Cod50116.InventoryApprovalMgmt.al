namespace ERP.ERP;

codeunit 50116 "Inventory Approval Mgmt"
{
    
    var
        WorkflowManagement: Codeunit System.Automation."Workflow Management";
    procedure SendSRNForApproval(var SRN: Record "Store Requisition Header")

    begin
        CheckSRNApprovalPossible(SRN);

        WorkflowManagement.HandleEvent(RunWorkflowOnSendSRNApprovalCode(), SRN);
    end;
      procedure CancelSRNApproval(var SRN: Record "Store Requisition Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelSRNApprovalCode(), SRN);
    end;

     local procedure CheckSRNApprovalPossible(SRN: Record "Store Requisition Header")
    begin
        SRN.TestField(Status, SRN.Status::Open);
    end;

    procedure RunWorkflowOnSendSRNApprovalCode(): Code[128]
    begin
        exit('RUNWORKFLOWONSENDSRNAPPROVAL');
    end;

    procedure RunWorkflowOnCancelSRNApprovalCode(): Code[128]
    begin
        exit('RUNWORKFLOWONCANCELSRNAPPROVAL');
    end;

}
