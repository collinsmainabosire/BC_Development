table 50104 "Purchase Requisition"
{
    Caption = 'Purchase Requisition';
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
             Editable = false;
        }
        field(2; "Requested Date"; Date)
        {
            Caption = 'Requested Date';
        }
        // field(3; "Item No."; Code[20])
        // {
        //     Caption = 'Item No.';
        //     TableRelation = "Drug Header";

        //     trigger OnValidate()
        //     var
        //         Item: Record "Drug Header";
        //     begin
        //         if Item.Get("Item No.") then begin
        //             "Item Description" := Item."Drug Name";
        //             "Unit of Measure" := Item."Unit of Measure";
        //             "Item Type" := Item.Type;
        //         end;
        //     end;
        // }

        // field(4; "Item Description"; Text[100])
        // {
        //     Caption = 'Item Description';
        //      Editable = false;
        // }
        // field(5; "Unit of Measure"; Code[50])
        // {
        //     Caption = 'Unit of Measure';
        //      Editable = false;
        // }
        field(6; "Requested By"; Text[100])
        {
            Caption = 'Requested By';
        }
        field(7; Status; Enum "Purchase Document Status")
        {
            Caption = 'Status';
        }
        // field(8; "Item Type"; code[50])
        // {
        //     Caption = 'Item Type';
        // }
        // field(9; "Item Balance"; Integer)
        // {
        //     Caption = 'Item Balance';
        //     Editable = false;
        //     TableRelation = "Drug Ledger Entry";
        //     FieldClass = FlowField;
        //     CalcFormula = sum("Drug Ledger Entry".Quantity where("Drug No." = field("Item No.")));
        // }
        // field(10; Quantity; Integer)
        // {
        //     Caption = 'Quantity';
        //     trigger OnValidate()
        //     begin
        //         if Quantity <= 0 then
        //             Error('Your quantity is %1. Quantity cannot be zero or less negative', Quantity)
        //     end;
        // }
        field(11; "Requisition Type"; Option)
        {
            Caption = 'Requisition Type';
            OptionMembers = ,Purchase,Store;
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
    var
        InventorySetup: Record "Store Setup";
        NoSeriesManagement: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            InventorySetup.Get();
            InventorySetup.TestField("Purchase No.");
            "No." := NoSeriesManagement.GetNextNo(InventorySetup."Purchase No.", WorkDate, true);
        end;
        "Requested By" := UserId;
        "Requested Date" := WorkDate;
        "Requisition Type" := "Requisition Type"::Purchase;
    end;
}
