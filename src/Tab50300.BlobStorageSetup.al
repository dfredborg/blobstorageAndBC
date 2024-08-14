namespace fredborg.blobstorage.setup;
table 50300 BlobStorageSetup
{
    Caption = 'BlobStorageSetup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; "Access Key"; Guid)
        {
            Caption = 'Access Key';
        }
        field(3; "Client ID"; Guid)
        {
            Caption = 'Client ID';
        }
        field(4; "Client Secret"; Guid)
        {
            Caption = 'Client Secret';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
