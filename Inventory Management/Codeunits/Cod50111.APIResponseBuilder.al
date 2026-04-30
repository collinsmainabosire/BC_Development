namespace ERP.ERP;

codeunit 50111 "API Response Builder"
{
    procedure BuildSuccess(No: Code[20]; DrugName: Text; UOM: Code[20]; Type: Code[20]) ResponseText: Text
    var
        JsonObj: JsonObject;
        DataObj: JsonObject;
    begin
        // -------------------------
        // BUILD DATA OBJECT
        // -------------------------
        DataObj.Add('no', No);
        DataObj.Add('drugName', DrugName);
        DataObj.Add('unitOfMeasure', UOM);
        DataObj.Add('type', Type);

        // -------------------------
        // BUILD FINAL RESPONSE
        // -------------------------
        JsonObj.Add('success', true);
        JsonObj.Add('message', 'Drug created successfully');
        JsonObj.Add('data', DataObj);

        JsonObj.WriteTo(ResponseText);

        exit(ResponseText);
    end;
}
