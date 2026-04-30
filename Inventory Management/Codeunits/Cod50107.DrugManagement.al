codeunit 50107 "Drug Management"
{
    // INTEGRATION EVENT (PUBLISHER)
    [IntegrationEvent(false, false)]
    procedure OnAfterDrugCreated(No: Code[20]; DrugName: Text)
    begin
    end;
    /// <summary>
    /// CreateDrug.
    /// </summary>
    /// <param name="No">Code[20].</param>
    /// <param name="Description">Text[100].</param>
    /// <param name="UnitOfMeasure">Code[20].</param>
    /// <param name="Type">Code[20].</param>
    /// <returns>Return variable ResponseText of type Text.</returns>
    procedure CreateDrug(Description: Text[100]; UnitOfMeasure: Code[20]; Type: Code[20]) ResponseText: Text
    var
        Drug: Record "Drug Header";
        ResponseBuilder: Codeunit "API Response Builder";
        NewNo: Code[20];
    begin

        // ASSIGN FIELDS
        Drug.Init();
        Drug."Drug Name" := Description;
        Drug."Unit of Measure" := UnitOfMeasure;
        Drug.Type := Type;
        // VALIDATION LAYER
        if Drug."Drug Name" = '' then
            Error('Drug Name must have a value.');
        if UnitOfMeasure = '' then
            Error('Unit of Measure must have a value.');
        // INSERT RECORD
        Drug.Insert(true);
        exit(ResponseBuilder.BuildSuccess(NewNo, Description, UnitOfMeasure, Type));

        // CALL EVENT AFTER INSERT
        OnAfterDrugCreated(Drug."No.", Drug."Drug Name");
    end;

}

