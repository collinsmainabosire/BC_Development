table 50111 "Student Application"
{
    Caption = 'Student Application';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }

        field(2; "Student Name"; Text[100])
        {
            Caption = 'Student Name';
            DataClassification = CustomerContent;
        }

        field(3; "Course Applied"; Text[100])
        {
            Caption = 'Course Applied';
            DataClassification = CustomerContent;
        }

        field(4; Status; Enum "Student Application Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }

        field(5; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(6; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then
            Error('Number cannot be empty.');

        Status := Status::Open;

        "Created By" := UserId;
        "Created Date" := Today;
    end;

    procedure TestNoOpenApprovalEntries()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        if ApprovalsMgmt.HasOpenApprovalEntries(RecordId) then
            Error('This document has open approval entries.');
    end;
}
