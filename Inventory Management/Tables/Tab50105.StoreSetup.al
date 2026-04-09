table 50105 "Store Setup"
{
    Caption = 'Inventory Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Drug Nos"; code[20])
        {
            Caption = 'Drug Nos';
            TableRelation = "No. Series";
        }
        field(3; "Purchase No."; code[20])
        {
            Caption = 'Purchase No.';
            TableRelation = "No. Series";
        }
        field(4; "SRN No."; code[20])
        {
            Caption = 'SRN No.';
            TableRelation = "No. Series";
        }
        field(5; "Other No."; code[20])
        {
            Caption = 'Other No.';
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
