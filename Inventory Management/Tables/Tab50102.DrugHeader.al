table 50102 "Drug Header"
{
    Caption = 'Drug Header';
    DataClassification = ToBeClassified;
    LookupPageId = "Drug card";
    DrillDownPageId = "Drug card";

    fields
    {
        field(1; "Drug No."; Code[20])
        {
            Caption = 'Drug No.';
        }
        field(2; "Drug Name"; Text[100])
        {
            Caption = 'Drug Name';
        }
        field(3; "Date Created"; Date)
        {
            Caption = 'Date Created';
            Editable = false;
        }
        field(4; Inventory; Integer)
        {
            Caption = 'Inventory';
            Editable = false;
            TableRelation = "Drug Ledger Entry";
            FieldClass = FlowField;
            CalcFormula = sum("Drug Ledger Entry".Quantity where("Drug No." = field("Drug No.")));
        }
        field(5; "Unit of Measure"; code[20])
        {
            Caption = 'Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(6; "Type"; Code[50])
        {
            Caption = 'Type';
            TableRelation = "Drug Type";
        }
        field(7; "created by"; Text[100])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(8; "Posted By"; text[100])
        {
            Caption = 'Posted By';
            Editable = false;
        }
        field(9; "Posting Date"; DateTime)
        {
            Caption = 'Posted By';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Drug No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        ErrorDeletion: Label 'Sorry you cannot delete a record created';
    begin
        Error(ErrorDeletion);
    end;

    trigger OnInsert()
    begin
        "Date Created" := WorkDate;
        "created by" := UserId;

    end;
}
