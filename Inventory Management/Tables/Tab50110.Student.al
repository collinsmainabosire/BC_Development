table 50110 Student
{
    Caption = 'Student';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Admission No."; Code[20])
        {
            Caption = 'Admission No.';
        }
        field(2; "First Name"; Text[100])
        {
            Caption = 'First Name';
        }
        field(3; "Middle Name"; Text[100])
        {
            Caption = 'Middle Name';
        }
        field(4; "Last Name"; Text[100])
        {
            Caption = 'Last Name';
        }
        field(5; Age; Integer)
        {
            Caption = 'Age';
        }
        field(6; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
        }
        field(7; "Place of Birth"; Text[50])
        {
            Caption = 'Place of Birth';
        }
        field(8; Email; Code[100])
        {
            Caption = 'Email';
        }
        field(9; Address; Code[100])
        {
            Caption = 'Address';
        }
    }
    keys
    {
        key(PK; "Admission No.")
        {
            Clustered = true;
        }
    }
}

