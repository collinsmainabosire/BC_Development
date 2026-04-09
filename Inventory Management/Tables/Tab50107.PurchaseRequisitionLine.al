table 50107 "Purchase Requisition Line"
{
    Caption = 'Purchase Requisition Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            Editable = false;
        }
        field(5; "Unit of Measure"; Code[50])
        {
            Caption = 'Unit of Measure';
            Editable = false;
        }
        field(6; Status; Enum "Purchase Document Status")
        {
            Caption = 'Status';
        }
        field(7; "Item Type"; code[50])
        {
            Caption = 'Item Type';
        }
        field(8; "Item Balance"; Integer)
        {
            Caption = 'Item Balance';
            Editable = false;
            TableRelation = "Drug Ledger Entry";
            FieldClass = FlowField;
            CalcFormula = sum("Drug Ledger Entry".Quantity where("Drug No." = field("Item No.")));

        }
        field(9; Quantity; Integer)
        {
            Caption = 'Quantity';
            trigger OnValidate()
            begin
                if Quantity <= 0 then
                    Error('Quantity must be greater than zero');
            end;


        }
        field(12; "Item No."; code[20])
        {
            Caption = 'Item No';
            TableRelation = "Drug Header";
            trigger OnValidate()
            var
                Item: Record "Drug Header";
                StoreLine: Record "Store Requisition Line";
            begin
                if Item.Get("Item No.") then begin
                    "Item Description" := Item."Drug Name";
                    "Unit of Measure" := Item."Unit of Measure";
                    "Item Type" := Item.Type;
                end;
                //Prevent Item line duplicate
                StoreLine.SetRange("Document No.", "Document No.");
                StoreLine.SetRange("Item No.", "Item No.");
                if StoreLine.FindFirst() then
                    if StoreLine."Line No." <> "Line No." then
                        Error('Item %1 already exists in this requisition.', "Item No.");

                // Existing logic (populate fields)
                if Rec."Item No." <> '' then begin
                    if Item.Get("Item No.") then begin
                        "Item Description" := Item."Drug Name";
                        "Unit of Measure" := Item."Unit of Measure";
                    end;
                end;
            end;
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
