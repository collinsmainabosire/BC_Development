codeunit 50110 "External POST Service"
{
    trigger OnRun()
    begin
        SendData();
    end;

    procedure SendData()
    var
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        JsonObj: JsonObject;
        ResponseText: Text;
        JsonText: Text;
        Headers: HttpHeaders;
        ResultJson: JsonObject;
        Buffer: Record "External Post Buffer";
        Token: JsonToken;
        Title: Text;
        Body: Text;
        UserId: Integer;
        Id: Integer;
    begin
        // Building JSON
        JsonObj.Add('title', 'BC Integration');
        JsonObj.Add('body', 'Learning HttpClient');
        JsonObj.Add('userId', 1);

        // Convert JSON to text
        JsonObj.WriteTo(JsonText);
        Content.WriteFrom(JsonText);

        // Set header
        Content.GetHeaders(Headers);
        Headers.Add('Content-Type', 'application/json');

        // Send POST request
        Client.Post('https://jsonplaceholder.typicode.com/posts', Content, Response);

        if not Response.IsSuccessStatusCode() then
            Error('POST failed');
        //Read response
        Response.Content().ReadAs(ResponseText);
        Message('Response: %1', ResponseText);

        //Convert JSON → AL
        ResultJson.ReadFrom(ResponseText);
        ResultJson.Get('id', Token);
        Id := Token.AsValue().AsInteger();
        ResultJson.Get('title', Token);
        Title := Token.AsValue().AsText();
        ResultJson.Get('body', Token);
        Body := Token.AsValue().AsText();
        ResultJson.Get('userId', Token);
        UserId := Token.AsValue().AsInteger();

        //Store in BC
        Buffer.Init();
        Buffer.Id := Id;
        Buffer.Title := Title;
        Buffer.Body := Body;
        Buffer.UserId := UserId;
        Buffer.Insert();
        Message('Data stored successfully');
    end;

}
