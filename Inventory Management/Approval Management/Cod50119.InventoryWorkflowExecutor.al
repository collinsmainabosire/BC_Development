namespace ERP.ERP;

using System.Automation;
using System.Security.User;

codeunit 50119 "Inventory Workflow Executor"
{
     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false,  false)]
   local procedure OnExecuteWorkflowResponse(ResponseWorkflowStepInstance: Record "Workflow Step Instance"; var Variant: Variant;xVariant: Variant; ResponseExecuted: Boolean)
      var
        SRN: Record "Store Requisition Header";
        RecRef: RecordRef;
    begin
        case ResponseWorkflowStepInstance."Function Name" of

            CreateSRNApprovalCode():
                begin
                    RecRef.GetTable(Variant);
                    RecRef.SetTable(SRN);

                    CreateSRNApprovalEntry(SRN);

                    ResponseExecuted := true;
                end;
        end;
    end;
     local procedure CreateSRNApprovalCode(): Code[128]
    begin
        exit('CREATESRNAPPROVAL');
    end;


local procedure CreateSRNApprovalEntry(var SRN: Record "Store Requisition Header")
var
    ApprovalEntry: Record "Approval Entry";
    ApprovalUserSetup: Record "User Setup";
begin
    ApprovalUserSetup.Get(UserId);

    ApprovalUserSetup.TestField("Approver ID");

    ApprovalEntry.Init();

    ApprovalEntry."Table ID" := Database::"Store Requisition Header";
    ApprovalEntry."Document Type" := ApprovalEntry."Document Type"::Quote;
    ApprovalEntry."Document No." := SRN."No.";

    ApprovalEntry."Sender ID" := UserId;
    ApprovalEntry."Approver ID" := ApprovalUserSetup."Approver ID";

    ApprovalEntry.Status := ApprovalEntry.Status::Open;

    ApprovalEntry."Record ID to Approve" := SRN.RecordId;

    ApprovalEntry.Insert(true);

    RestrictRecord(SRN);

    SRN.Status := SRN.Status::"Pending Approval";
    SRN.Modify(true);
end;
//Restriction procedure to restrict the record when it is sent for approval. This will prevent any changes on the record until approval decision is made.
local procedure RestrictRecord(SRN: Record "Store Requisition Header")
var
    RestrictedRecord: Record "Restricted Record";
begin
    RestrictedRecord.Init();

    RestrictedRecord."Record ID" := SRN.RecordId;

    RestrictedRecord.Insert();
end;
}
