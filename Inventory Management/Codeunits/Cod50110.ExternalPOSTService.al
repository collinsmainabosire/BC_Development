codeunit 50110 "External POST Service"
{
    // Entry point when you run the codeunit
    trigger OnRun()
    begin
        SendData();
    end;

    procedure SendData()
    var
        Client: HttpClient;                 // Used to send HTTP requests
        Content: HttpContent;               // Holds request body (JSON)
        Response: HttpResponseMessage;      // Stores API response
        ResponseText: Text;                 // Raw response as text

        JsonObj: JsonObject;                // Used to build JSON request
        JsonText: Text;                     // JSON converted to text for sending
        ResultJson: JsonObject;             // Used to read JSON response
        Token: JsonToken;                   // Temporary holder for JSON values

        Headers: HttpHeaders;              // HTTP headers for request

        Buffer: Record "External Post Buffer";   // Table to store API data
        Log: Record "Integration Log";            // Table to store logs

        Title: Text;
        Body: Text;
        UserId: Integer;
        Id: Integer;
    begin
        
        // 🔹 1. BUILD JSON REQUEST
        
        JsonObj.Add('title', 'BC Integration');
        JsonObj.Add('body', 'Learning HttpClient');
        JsonObj.Add('userId', 1);

        // Convert JSON object into text format for HTTP request
        JsonObj.WriteTo(JsonText);
        Content.WriteFrom(JsonText);
        // Set HTTP header so API knows we are sending JSON
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');
        // 🔹 2. SEND API REQUEST
        if not Client.Post('https://jsonplaceholder.typicode.com/posts', Content, Response) then begin
            LogError('HTTP request failed - no response from server');
            Error('HTTP request failed');
        end;
        // 🔹 3. CHECK API RESPONSE
        if not Response.IsSuccessStatusCode() then begin
            Response.Content().ReadAs(ResponseText);
            LogError(StrSubstNo(
                'API Error %1: %2',
                Response.HttpStatusCode(),
                ResponseText));

            Error('API call failed');
        end;
        // Read response body
        Response.Content().ReadAs(ResponseText);

        // Convert response JSON text into AL JSON object
        if not ResultJson.ReadFrom(ResponseText) then begin
            LogError('Invalid JSON received from API');
            Error('Invalid JSON response');
        end;
        // 🔹 4. EXTRACT VALUES FROM JSON
        if ResultJson.Get('id', Token) then
            Id := Token.AsValue().AsInteger();

        if ResultJson.Get('title', Token) then
            Title := Token.AsValue().AsText();

        if ResultJson.Get('body', Token) then
            Body := Token.AsValue().AsText();

        if ResultJson.Get('userId', Token) then
            UserId := Token.AsValue().AsInteger();
        // 🔹 5. SAVE DATA INTO BC TABLE
        if Buffer.Get(Id) then begin
            // If record exists → update it
            Buffer.Title := Title;
            Buffer.Body := Body;
            Buffer.UserId := UserId;
            Buffer.Modify();
        end else begin
            // If record does not exist → insert new
            Buffer.Init();
            Buffer.Id := Id;
            Buffer.Title := Title;
            Buffer.Body := Body;
            Buffer.UserId := UserId;
            Buffer.Insert(true);
        end;
        // 🔹 6. LOG SUCCESS
        LogSuccess(StrSubstNo('Record %1 inserted/updated successfully', Id));

        Message('Integration completed successfully');
    end;

    // 🔹 LOG SUCCESS MESSAGE INTO LOG TABLE

    local procedure LogSuccess(LogText: Text)
    var
        Log: Record "Integration Log";
    begin
        Log.Init();
        Log.Message := LogText;
        Log.Status := Log.Status::Success;
        Log.CreatedAt := CurrentDateTime;
        Log.Insert(true);
    end;
    // 🔹 LOG ERROR MESSAGE INTO LOG TABLE
    local procedure LogError(LogText: Text)
    var
        Log: Record "Integration Log";
    begin
        Log.Init();
        Log.Message := LogText;
        Log.Status := Log.Status::Error;
        Log.CreatedAt := CurrentDateTime;
        Log.Insert(true);
    end;
}