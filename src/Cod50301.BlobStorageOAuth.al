namespace fredborg.blobstorage.oauth;
using fredborg.blobstorage.setup;

codeunit 50301 BlobStorageOAuth
{
    procedure GetBlobUsingOauth()
    var
        BlobStorageSetup: Record BlobStorageSetup;
        Result: Text;
        Content: HttpContent;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        Client: HttpClient;
        RequestHeader: HttpHeaders;
        ContentHeader: HttpHeaders;
        Jobject: JsonObject;
        JToken: JsonToken;
        ClientId: Text;
        ClientSecret: Text;
    begin
        BlobStorageSetup.Get();
        IsolatedStorage.Get(BlobStorageSetup."Client Secret", ClientSecret);
        IsolatedStorage.Get(BlobStorageSetup."Client ID", ClientSecret);
        Client.Clear();
        Request.GetHeaders(RequestHeader);
        Content.WriteFrom('client_id=' + ClientId + '&scope=https://storage.azure.com/.default&client_secret=' + ClientSecret + '&grant_type=client_credentials');
        Request.Content := Content;
        Request.Content.GetHeaders(ContentHeader);
        ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        Request.SetRequestUri('https://login.microsoftonline.com/c66e4de1-d2a6-4b74-985c-1c0cd590d903/oauth2/v2.0/token');
        Request.Method('POST');
        Client.Send(Request, Response);
        Content := Response.Content;
        Response.Content.ReadAs(Result);

        jobject.ReadFrom(Result);
        Jobject.SelectToken('access_token', JToken);

        clear(Request);
        Clear(RequestHeader);
        Clear(Response);
        Client.Clear();
        Client.DefaultRequestHeaders.Add('Authorization', StrSubstNo('Bearer %1', JToken.AsValue().AsText()));
        //Request headers
        Request.GetHeaders(RequestHeader);
        Request.Content := Content;
        RequestHeader.Add('Accept', '*/*');
        Request.Content.GetHeaders(ContentHeader);
        ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/json');
        ContentHeader.Add('x-ms-version', '2019-02-02');
        //Set URL and type
        Request.SetRequestUri('https://testfilesfredborg.blob.core.windows.net/files/TEST.txt');
        Request.Method('get');
        //Call HTTP
        Client.Send(Request, Response);
        Content := Response.Content;
        response.Content().ReadAs(Result);

        Message(Result);
    end;
}
