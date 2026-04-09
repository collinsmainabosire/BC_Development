table 50100 "Drug Type"
{
    Caption = 'Drug Type';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
            Editable = false;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }

    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    begin
        Error('Sorry you cannot delete created type');
    end;
}
