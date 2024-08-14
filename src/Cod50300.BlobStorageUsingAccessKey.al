namespace fredborg.blobstorage.accesskey;

using fredborg.blobstorage.setup;
using System.Azure.Storage;

codeunit 50300 BlobStorageUsingAccessKey
{
    procedure ReadContainerfile(): Text
    var
        ABSContainerContent: Record "ABS Container Content";
        BlobStorageSetup: Record BlobStorageSetup;
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        ABSBlobClient: Codeunit "ABS Blob Client";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        Authorization: Interface "Storage Service Authorization";
        instr: Instream;
        AccountAccessKey: text;
        AccountName: Text;
        AccountContainer: Text;
        filename: Text;
        output: Text;
        secretText: SecretText;
    begin
        BlobStorageSetup.Get();
        IsolatedStorage.Get(BlobStorageSetup."Access Key", AccountAccessKey);
        AccountName := 'bcstoragefredborg';
        AccountContainer := 'files';
        secretText := AccountAccessKey;
        Authorization := StorageServiceAuthorization.CreateSharedKey(secretText);
        ABSBlobClient.Initialize(AccountName, AccountContainer, Authorization);
        ABSOperationResponse := ABSBlobClient.ListBlobs(ABSContainerContent);
        if ABSOperationResponse.IsSuccessful() then begin
            ABSContainerContent.Reset();
            if ABSContainerContent.FindSet() then
                repeat
                    Clear(instr);
                    ABSOperationResponse := ABSBlobClient.GetBlobAsStream(ABSContainerContent.Name, instr);
                    if ABSOperationResponse.IsSuccessful() then
                        while not instr.EOS do begin
                            instr.ReadText(output);
                            output := output + output;
                        end;
                until ABSContainerContent.Next() = 0;
        end;

        exit(output);
    end;
}
