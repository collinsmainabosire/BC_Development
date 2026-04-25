table 50109 "Integration Log"
{
    Caption = 'Integration Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; EntryNo; Integer) { AutoIncrement = true; }
        field(2; Message; Text[250]) { }
        field(3; Status; Option)
        {
            OptionMembers = Success,Error;
        }
        field(4; CreatedAt; DateTime) { }
    }

    keys
    {
        key(PK; EntryNo) { Clustered = true; }
    }
}
