codeunit 50107 "Drug Management"
{
    procedure CreateDrug(No: Code[20]; Description: Text[100]; UnitOfMeasure: Code[20]; Type: Code[20])
    var
        Drug: Record "Drug Header";
    begin
        // VALIDATION LAYER
        if Drug."Drug Name" = '' then
            Error('Drug Name must have a value.');
        if UnitOfMeasure = '' then
            Error('Unit of Measure must have a value.');

        if Drug.Get(No) then
            Error('Drug %1 already exists', No);
        // ASSIGN FIELDS
        Drug.Init();
        Drug."No." := No;
        Drug."Drug Name" := Description;
        Drug."Unit of Measure" := UnitOfMeasure;
        Drug.Type := Type;
        // INSERT RECORD
        Drug.Insert(true);
    end;



