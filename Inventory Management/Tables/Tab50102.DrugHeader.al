table 50102 "Drug Header"
{
    Caption = 'Drug Header';
    DataClassification = ToBeClassified;
    LookupPageId = "Drug card";
    DrillDownPageId = "Drug card";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
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
            CalcFormula = sum("Drug Ledger Entry".Quantity where("Drug No." = field("No.")));
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
        field(7; "Created By"; Text[100])
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
        key(PK; "No.")
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
    var
        NoSeriesManagement: Codeunit "No. Series Helper";
    begin
        if "No." = '' then begin
            "No." := NoSeriesManagement.GetDrugNo();
        end;
        "Date Created" := WorkDate;
        "Created By" := UserId;
    end;

    /// <summary>
    /// ValidateHeader.
    /// </summary>
    /// <param name="Header">VAR Record "Store Requisition Header".</param>
    local procedure ValidateHeader(var Header: Record "Drug Header")
    begin
        Header.TestField("No.");
        Header.TestField("Drug Name");
        Header.TestField(Type);
        Header.TestField("Unit of Measure");
        Header.TestField("Date Created");
    end;
}
