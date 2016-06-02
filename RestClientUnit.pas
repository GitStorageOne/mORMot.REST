unit RestClientUnit;

interface

uses
  // RTL
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  Vcl.Dialogs,
  // mORMot
  mORMot,
  mORMotHttpClient,
  SynCommons,
  // Custom
  RestMethodsInterfaceUnit;

type
  lAuthMode = (NoAuthentication, URI, SignedURI, Default, None, HttpBasic, SSPI);

  rCreateClientOptions = record
    AuthMode: lAuthMode;
    HostOrIP: string;
    Port: string;
  end;

var
  Model: TSQLModel;
  Client: TSQLRestClientURI;
  RestServerMethods: IRestMethods;

function CreateClient(Options: rCreateClientOptions): boolean;
procedure DestroyClient();
function ClientCreated(): boolean;

implementation

function CreateClient(Options: rCreateClientOptions): boolean;
begin
  Result := False;
  // Destroy current object
  DestroyClient();
  // Client initialization (for better understanding, each section contain separate code, later should be refactored)
  case Options.AuthMode of
    // NoAuthentication
    NoAuthentication:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        Client := TSQLHttpClient.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model);
      end;
    // TSQLRestServerAuthenticationURI
    URI:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        Client := TSQLHttpClient.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model);
        TSQLRestServerAuthenticationURI.ClientSetUser(Client, 'User', '');
      end;
    // TSQLRestServerAuthenticationSignedURI
    SignedURI:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        Client := TSQLHttpClient.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model);
        TSQLRestServerAuthenticationSignedURI.ClientSetUser(Client, 'User', '');
      end;
    // TSQLRestServerAuthenticationDefault
    Default:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        Client := TSQLHttpClient.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model);
        Client.SetUser('User', 'synopse');
      end;
    // TSQLRestServerAuthenticationNone
    None:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        Client := TSQLHttpClient.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model);
        TSQLRestServerAuthenticationNone.ClientSetUser(Client, 'User', '');
      end;
    // TSQLRestServerAuthenticationHttpBasic
    HttpBasic:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        Client := TSQLHttpClient.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model);
        TSQLRestServerAuthenticationHttpBasic.ClientSetUser(Client, 'User', '');
      end;
    // TSQLRestServerAuthenticationSSPI
    SSPI:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        Client := TSQLHttpClient.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model);
        TSQLRestServerAuthenticationSSPI.ClientSetUser(Client, 'User', '');
      end;
  end;
  // Preparing
  if not Client.ServerTimeStampSynchronize() then
    begin
      ShowMessage(UTF8ToString(Client.LastErrorMessage));
      exit;
    end;
  // Service initialization
  Client.ServiceDefine([IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
  Result := Client.Services['RestMethods'].Get(RestServerMethods);
end;

procedure DestroyClient();
begin
  if Assigned(Client) then
    FreeAndNil(Client);
  if Assigned(Model) then
    FreeAndNil(Model);
  RestServerMethods := nil;
end;

function ClientCreated(): boolean;
begin
  Result := Assigned(Client);
end;

end.
