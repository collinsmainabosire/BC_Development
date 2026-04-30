namespace ERP.ERP;

codeunit 50112 "Drug Query Service"
{
    procedure GetDrugs() ResponseText: Text
    var
        Drug: Record "Drug Header";
        JsonObj: JsonObject;
        DataArray: JsonArray;
        ItemObj: JsonObject;
        Count: Integer;
    begin
        if Drug.FindSet() then begin
            repeat
                Clear(ItemObj);

                ItemObj.Add('no', Drug."No.");
                ItemObj.Add('drugName', Drug."Drug Name");
                ItemObj.Add('unitOfMeasure', Drug."Unit of Measure");
                ItemObj.Add('type', Drug.Type);

                DataArray.Add(ItemObj);
                Count += 1;

            until Drug.Next() = 0;
        end;

        JsonObj.Add('success', true);
        JsonObj.Add('count', Count);
        JsonObj.Add('data', DataArray);

        JsonObj.WriteTo(ResponseText);
        exit(ResponseText);
    end;
}
