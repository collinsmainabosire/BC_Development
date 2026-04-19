codeunit 50107 "Drug Management"
{
    procedure CreateDrug(No: Code[20]; Description: Text[100]; UnitOfMeasure: Code[20]; Type: Code[20])
    var
        Drug: Record "Drug Header";
    begin
        if Drug.Get(No) then
            Error('Drug %1 already exists', No);

        Drug.Init();
        Drug."No." := No;
        Drug."Drug Name" := Description;
        Drug."Unit of Measure" := UnitOfMeasure;
        Drug.Type := Type;

        Drug.Insert(true);
    end;
}
