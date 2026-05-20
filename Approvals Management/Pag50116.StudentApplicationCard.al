namespace ERP.ERP;

page 50116 "Student Application Card"
{

    PageType = Card;
    SourceTable = "Student Application";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                }

                field("Student Name"; Rec."Student Name")
                {
                }

                field("Course Applied"; Rec."Course Applied")
                {
                }

                field(Status; Rec.Status)
                {
                    Editable = false;
                }

                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                }

                field("Created Date"; Rec."Created Date")
                {
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SendApprovalRequest)
            {
                ApplicationArea = All;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;

                trigger OnAction()
                var
                // StudentApprovalMgmt: Codeunit "Student Approval Mgmt";
                begin
                    //  StudentApprovalMgmt.SendApprovalRequest(Rec);
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = All;
                Caption = 'Cancel Approval Request';
                Image = CancelApprovalRequest;

                trigger OnAction()
                var
                   // StudentApprovalMgmt: Codeunit "Student Approval Mgmt";
                begin
                   // StudentApprovalMgmt.CancelApprovalRequest(Rec);
                end;
            }
        }
    }
}