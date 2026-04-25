codeunit 50109 "External API Service"
{
    procedure CallExternalAPI()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Content: Text;
        StatusCode: Integer;
        JsonObj: JsonObject;
    begin
        // Call API
        if not Client.Get('https://jsonplaceholder.typicode.com/posts/1', Response) then
            Error('Failed to reach external service');

        // Check HTTP status
        StatusCode := Response.HttpStatusCode();

        if StatusCode <> 200 then begin
            Response.Content().ReadAs(Content);
            Error('API Error. Status: %1, Response: %2', StatusCode, Content);
        end;

        // Read response
        Response.Content().ReadAs(Content);

        Message('Response Received:\n%1', Content);
        JsonObj.ReadFrom(Content);
    end;
}