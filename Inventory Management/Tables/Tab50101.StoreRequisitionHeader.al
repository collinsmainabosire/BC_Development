table 50101 "Store Requisition Header"
{
    Caption = 'Store Requisition Header';
    DataClassification = ToBeClassified;

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
        // }
        // field(5; "Unit of Measure"; Code[50])
        // {
        //     Caption = 'Unit of Measure';
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
        //             Error('Your quantity is %1. Quantity cannot be zero or less negative', Quantity);
        //         if Quantity > "Item Balance" then
        //             Error('Your %1 %2 of %3 is more than available stock. Available stock is %4 please revise your quantity', Quantity, "Unit of Measure",
        //              "Item Description", "Item Balance");
        //     end;
        // }
        field(11; "Requisition Type"; Option)
        {
            Caption = 'Requisition Type';
            OptionMembers = ,Purchase,Store;
        }
        field(12; "Batch No."; Code[50])
        {
            Caption = 'Batch No.';
       
        }
        field(13; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
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
            InventorySetup.TestField(InventorySetup."SRN No.");
            "No." := NoSeriesManagement.GetNextNo(InventorySetup."SRN No.", WorkDate, true);

        end;
        "Requested By" := UserId;
        "Requested Date" := WorkDate;
        "Requisition Type" := "Requisition Type"::Store;
    end;

}
