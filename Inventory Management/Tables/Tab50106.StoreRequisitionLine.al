table 50106 "Store Requisition Line"
{
    Caption = 'Store Requisition Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = "Drug Header";
            trigger OnValidate()
            var
                Item: Record "Drug Header";
            begin
                if Item.Get("Item No.") then begin
                    "Item Description" := Item."Drug Name";
                    "Unit of Measure" := Item."Unit of Measure";
                    "Item Type" := Item.Type;
                end
            end;
        }
        field(4; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
            trigger OnValidate()
            begin
                if Quantity <= 0 then
                    Error('Quantity must be greater than zero');
            end;
        }
        field(6; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure';
        }
        field(7; "Item Type"; Code[20])
        {
            Caption = 'Item Type';
        }
        field(8; "Item Balance"; Integer)
        {
            Caption = 'Item Balance';
            TableRelation = "Drug Ledger Entry";
            FieldClass = FlowField;
            CalcFormula = sum("Drug Ledger Entry".Quantity where("Drug No." = field("Item No.")));
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        StoreLine: Record "Store Requisition Line";
    begin
        if "Line No." = 0 then begin
            StoreLine.SetRange("Document No.", "Document No.");

            if StoreLine.FindLast() then
                "Line No." := StoreLine."Line No." + 1000
            else
                "Line No." := 1000;
        end;
    end;
}
