codeunit 50110 "External POST Service"
{
    trigger OnRun()
    begin
        Message('Codeunit is running');
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
        if not ResultJson.ReadFrom(ResponseText) then
            Error('Invalid JSON received from API');

        // Set header
        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');

        // Send POST request
        if not Client.Post('https://jsonplaceholder.typicode.com/posts', Content, Response) then
            Error('HTTP call failed - no response from server');
        if not Response.IsSuccessStatusCode() then begin
            Response.Content().ReadAs(ResponseText);
            Error('API Error %1 \Reason: %2', Response.HttpStatusCode(), ResponseText);
        end;
        //Read response
        Response.Content().ReadAs(ResponseText);
        Message('Response: %1', ResponseText);

        //Convert JSON → AL
        ResultJson.ReadFrom(ResponseText);
        ResultJson.Get('id', Token);
        if ResultJson.Get('id', Token) then
            Id := Token.AsValue().AsInteger()
        else
            Error('Missing field: id');
        if ResultJson.Get('title', Token) then
            Title := Token.AsValue().AsText()
        else
            Error('Missing field: Title');
        if ResultJson.Get('body', Token) then
            Body := Token.AsValue().AsText()
        else
            Error('Missing field: Body');
        if ResultJson.Get('userId', Token) then
            UserId := Token.AsValue().AsInteger()
        else
            Error('Missing Username field');
        //Store in BC
        if Buffer.Get(Id) then begin
            Buffer.Title := Title;
            Buffer.Body := Body;
            Buffer.UserId := UserId;
            Buffer.Modify();
        end else begin
            Buffer.Init();
            Buffer.Id := Id;
            Buffer.Title := Title;
            Buffer.Body := Body;
            Buffer.UserId := UserId;
            Buffer.Insert(true);
        end;
    end;

}
