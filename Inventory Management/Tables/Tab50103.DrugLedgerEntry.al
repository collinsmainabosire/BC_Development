table 50103 "Drug Ledger Entry"
{
    Caption = 'Drug Ledger Entry';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'Drug No.';
        }
        field(3; "Drug Name"; Text[100])
        {
            Caption = 'Drug Name';
        }
        field(4; "Date Created"; Date)
        {
            Caption = 'Date Created';
            Editable = false;
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
            Editable = false;

        }
        field(6; "Unit of Measure"; code[20])
        {
            Caption = 'Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(7; "Type"; Code[50])
        {
            Caption = 'Type';
            TableRelation = "Drug Type";
        }
        field(8; "Created By"; Text[100])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(9; "Posted By"; text[100])
        {
            Caption = 'Posted By';
            Editable = false;
        }
        field(10; "Posting Date"; DateTime)
        {
            Caption = 'Posted On';
            Editable = false;
        }
        field(11; "Req No."; code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(12; "Requested By"; text[100])
        {
            Caption = 'Requested By';
            Editable = false;
        }
        field(13; Status; Enum "Purchase Document Status")
        {
            Caption = 'Status';
        }
        field(14; "Requsition Type"; Option)
        {
            Caption = 'Requisition Type';
            OptionMembers = ,Pruchase,Store;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        ErrorDeletion: Label 'Sorry you cannot delete a ledger entry created';
    begin
        Error(ErrorDeletion);
    end;

    trigger OnInsert()
    begin
        "Posted By" := UserId;
        "Posting Date" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        Error('Sorry you cannot modify ledger entries');
    end;
}
