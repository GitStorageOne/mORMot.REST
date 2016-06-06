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
  lProtocol = (HTTP_Socket, HTTP_HTTPsys, WebSocketBidir_JSON, WebSocketBidir_Binary, WebSocketBidir_BinaryAES, NamedPipe);
  lAuthorizationMode = (NoAuthorization, URI, SignedURI, Default, None, HttpBasic, SSPI);

  rCreateClientOptions = record
    Protocol: lProtocol;
    AuthMode: lAuthorizationMode;
    HostOrIP: string;
    Port: string;
    UserLogin: RawUTF8;
    UserPassword: RawUTF8;
  end;

var
  Model: TSQLModel;
  Client: TSQLHttpClientGeneric;
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
  Model := TSQLModel.Create([], ROOT_NAME);
  case Options.Protocol of
    HTTP_Socket:
      begin
        Client := TSQLHttpClientWinSock.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model, 5000, 5000, 10000);
      end;
    HTTP_HTTPsys:
      begin
        Client := TSQLHttpClientWinHTTP.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model, 5000, 5000, 10000);
      end;
    WebSocketBidir_JSON:
      begin
        Client := TSQLHttpClientWebsockets.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model, 5000, 5000, 10000);
        (Client as TSQLHttpClientWebsockets).WebSocketsUpgrade('', True);
      end;
    WebSocketBidir_Binary:
      begin
        Client := TSQLHttpClientWebsockets.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model, 5000, 5000, 10000);
        (Client as TSQLHttpClientWebsockets).WebSocketsUpgrade('', False);
      end;
    WebSocketBidir_BinaryAES:
      begin
        Client := TSQLHttpClientWebsockets.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model, 5000, 5000, 10000);
        (Client as TSQLHttpClientWebsockets).WebSocketsUpgrade('2141D32ADAD54D9A9DB56000CC9A4A70', False);
      end;
    // NamedPipe:
    // begin
    //
    // end;
  else
    begin
      DestroyClient();
      raise Exception.Create('Selected protocol not available in this build.');
    end;
  end;
  case Options.AuthMode of
    // NoAuthentication
    NoAuthorization:
      begin
        // nothing to do here
      end;
    // TSQLRestServerAuthenticationURI
    URI:
      begin
        // Client.SetUser(Options.UserLogin, Options.UserPassword);
        TSQLRestServerAuthenticationURI.ClientSetUser(Client, Options.UserLogin, Options.UserPassword);
      end;
{$REGION 'Other Auth modes UNDER DEVELOPMENT'}
    // // TSQLRestServerAuthenticationSignedURI
    // SignedURI:
    // begin
    // Model := TSQLModel.Create([], ROOT_NAME);
    // Client := TSQLHttpClient.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model);
    // TSQLRestServerAuthenticationSignedURI.ClientSetUser(Client, Options.UserLogin, Options.UserPassword);
    // end;
    // // TSQLRestServerAuthenticationDefault
    // Default:
    // begin
    // Model := TSQLModel.Create([], ROOT_NAME);
    // Client := TSQLHttpClient.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model);
    // Client.SetUser(Options.UserLogin, Options.UserPassword);
    // end;
    // // TSQLRestServerAuthenticationNone
    // None:
    // begin
    // Model := TSQLModel.Create([], ROOT_NAME);
    // Client := TSQLHttpClient.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model);
    // TSQLRestServerAuthenticationNone.ClientSetUser(Client, Options.UserLogin, Options.UserPassword);
    // end;
    // // TSQLRestServerAuthenticationHttpBasic
    // HttpBasic:
    // begin
    // Model := TSQLModel.Create([], ROOT_NAME);
    // Client := TSQLHttpClient.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model);
    // TSQLRestServerAuthenticationHttpBasic.ClientSetUser(Client, Options.UserLogin, Options.UserPassword);
    // end;
    // // TSQLRestServerAuthenticationSSPI
    // SSPI:
    // begin
    // Model := TSQLModel.Create([], ROOT_NAME);
    // Client := TSQLHttpClient.Create(AnsiString(Options.HostOrIP), AnsiString(Options.Port), Model);
    // TSQLRestServerAuthenticationSSPI.ClientSetUser(Client, Options.UserLogin, Options.UserPassword);
    // end;
{$ENDREGION}
  else
    begin
      DestroyClient();
      raise Exception.Create('Selected Authentication mode not available in this build.');
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
  // Result := Client.Services['RestMethods'].Get(RestServerMethods);
  Result := Client.Services.Resolve(IRestMethods, RestServerMethods); // same result, but no chance to make mistake with service name
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
