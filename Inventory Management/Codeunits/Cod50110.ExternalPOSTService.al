codeunit 50110 "External POST Service"
{
    procedure SendData()
    var
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        JsonObj: JsonObject;
        ResponseText: Text;
        JsonText: Text;
        Headers: HttpHeaders;
    begin
        // Build JSON
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

        Response.Content().ReadAs(ResponseText);

        Message('Response: %1', ResponseText);
    end;

}
