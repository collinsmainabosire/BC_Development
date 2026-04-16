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
        field(9; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            trigger OnValidate()
            begin
                if "Batch No." = '' then
                    Error('Batch No. must be specified.');
            end;
        }
        field(10; "Requisition Type"; Enum "Requisition Type")
        {
            Caption = 'Requisition Type';
            NotBlank = true;
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

        CheckDuplicateBatchLine(Rec);

    end;

    local procedure CheckDuplicateBatchLine(Line: Record "Store Requisition Line")
    var
        TempLine: Record "Store Requisition Line";
    begin
        TempLine.SetRange("Document No.", Line."Document No.");
        TempLine.SetRange("Item No.", Line."Item No.");
        TempLine.SetRange("Batch No.", Line."Batch No.");

        if TempLine.FindSet() then
            if TempLine.Count > 1 then
                Error('Item %1 with Batch %2 already exists.', Line."Item No.", Line."Batch No.");
    end;
}
