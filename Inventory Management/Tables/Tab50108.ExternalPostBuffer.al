table 50108 "External Post Buffer"
{
    Caption = 'External Post Buffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; Title; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Body; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; UserId; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }
}
