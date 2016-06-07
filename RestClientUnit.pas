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
  lAuthenticationMode = (NoAuthentication, URI, SignedURI, Default, None, HttpBasic, SSPI);

  rClientSettings = record
    Protocol: lProtocol;
    AuthMode: lAuthenticationMode;
    HostOrIP: string;
    Port: string;
    UserLogin: RawUTF8;
    UserPassword: RawUTF8;
  end;

  rConnectionSettings = record
    SendTimeout: Cardinal;
    ReceiveTimeout: Cardinal;
    ConnectTimeout: Cardinal;
    procedure LanNetworkPreset();
  end;

  tRestClient = class
  private
    fModel: TSQLModel;
    fClient: TSQLHttpClientGeneric;
    fClientSettings: rClientSettings;
    fConnectionSettings: rConnectionSettings;
    fInitialized: boolean;
  public
    RestMethods: IRestMethods;
    property Initialized: boolean read fInitialized;
    constructor Create();
    destructor Destroy(); override;
    function Initialize(ClSettings: rClientSettings; ConSettings: rConnectionSettings): boolean; overload;
    function Initialize(ClSettings: rClientSettings): boolean; overload;
    procedure DeInitialize();
  end;

var
  RestClient: tRestClient;

implementation

{ rConnectionSettings }

procedure rConnectionSettings.LanNetworkPreset();
begin
  SendTimeout := 5000;
  ReceiveTimeout := 5000;
  ConnectTimeout := 10000;
end;

{ tRestClient }

constructor tRestClient.Create();
begin
  fConnectionSettings.LanNetworkPreset();
end;

destructor tRestClient.Destroy();
begin
  DeInitialize();
  inherited;
end;

function tRestClient.Initialize(ClSettings: rClientSettings; ConSettings: rConnectionSettings): boolean;
begin
  fConnectionSettings := ConSettings;
  Result := Initialize(ClSettings);
end;

function tRestClient.Initialize(ClSettings: rClientSettings): boolean;
begin
  Result := False;
  // Destroy current object
  DeInitialize();
  // Client initialization (for better understanding, each section contain separate code, later should be refactored)
  fClientSettings := ClSettings;
  fModel := TSQLModel.Create([], ROOT_NAME);
  case fClientSettings.Protocol of
    HTTP_Socket:
      begin
        fClient := TSQLHttpClientWinSock.Create(AnsiString(fClientSettings.HostOrIP), AnsiString(fClientSettings.Port), fModel, fConnectionSettings.SendTimeout, fConnectionSettings.ReceiveTimeout,
          fConnectionSettings.ConnectTimeout);
      end;
    HTTP_HTTPsys:
      begin
        fClient := TSQLHttpClientWinHTTP.Create(AnsiString(fClientSettings.HostOrIP), AnsiString(fClientSettings.Port), fModel, fConnectionSettings.SendTimeout, fConnectionSettings.ReceiveTimeout,
          fConnectionSettings.ConnectTimeout);
      end;
    WebSocketBidir_JSON:
      begin
        fClient := TSQLHttpClientWebsockets.Create(AnsiString(fClientSettings.HostOrIP), AnsiString(fClientSettings.Port), fModel, fConnectionSettings.SendTimeout, fConnectionSettings.ReceiveTimeout,
          fConnectionSettings.ConnectTimeout);
        (fClient as TSQLHttpClientWebsockets).WebSocketsUpgrade('', True);
      end;
    WebSocketBidir_Binary:
      begin
        fClient := TSQLHttpClientWebsockets.Create(AnsiString(fClientSettings.HostOrIP), AnsiString(fClientSettings.Port), fModel, fConnectionSettings.SendTimeout, fConnectionSettings.ReceiveTimeout,
          fConnectionSettings.ConnectTimeout);
        (fClient as TSQLHttpClientWebsockets).WebSocketsUpgrade('', False);
      end;
    WebSocketBidir_BinaryAES:
      begin
        fClient := TSQLHttpClientWebsockets.Create(AnsiString(fClientSettings.HostOrIP), AnsiString(fClientSettings.Port), fModel, fConnectionSettings.SendTimeout, fConnectionSettings.ReceiveTimeout,
          fConnectionSettings.ConnectTimeout);
        (fClient as TSQLHttpClientWebsockets).WebSocketsUpgrade('2141D32ADAD54D9A9DB56000CC9A4A70', False);
      end;
    {
      NamedPipe:
      begin
      end;
    }
  else
    begin
      DeInitialize();
      raise Exception.Create('Selected protocol not available in this build.');
    end;
  end;
  case fClientSettings.AuthMode of
    // NoAuthentication
    NoAuthentication:
      begin
        // nothing to do here
      end;
    // TSQLRestServerAuthenticationURI
    URI:
      begin
        // fClient.SetUser(Options.UserLogin, Options.UserPassword);
        TSQLRestServerAuthenticationURI.ClientSetUser(fClient, fClientSettings.UserLogin, fClientSettings.UserPassword);
      end;
    {
      // TSQLRestServerAuthenticationSignedURI
      SignedURI:
      begin
      end;
    }
    // TSQLRestServerAuthenticationDefault
    Default:
      begin
        fClient.SetUser(fClientSettings.UserLogin, fClientSettings.UserPassword);
      end;
    // TSQLRestServerAuthenticationNone
    None:
      begin
        TSQLRestServerAuthenticationNone.ClientSetUser(fClient, fClientSettings.UserLogin, fClientSettings.UserPassword);
      end;
    {
      // TSQLRestServerAuthenticationHttpBasic
      HttpBasic:
      begin
      end;
    }
    {
      // TSQLRestServerAuthenticationSSPI
      SSPI:
      begin
      end;
    }
  else
    begin
      DeInitialize();
      raise Exception.Create('Selected Authentication mode not available in this build.');
    end;
  end;
  // Preparing
  if not fClient.ServerTimeStampSynchronize() then
    begin
      ShowMessage(UTF8ToString(fClient.LastErrorMessage));
      exit;
    end;
  // Service initialization
  fClient.ServiceDefine([IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
  // Result := Client.Services['RestMethods'].Get(RestServerMethods);
  Result := fClient.Services.Resolve(IRestMethods, RestMethods); // same result, but no chance to make mistake with service name
  fInitialized := Result;
end;

procedure tRestClient.DeInitialize();
begin
  if Assigned(fClient) then
    FreeAndNil(fClient);
  if Assigned(fModel) then
    FreeAndNil(fModel);
  RestMethods := nil;
  fInitialized := False;
end;

initialization

RestClient := tRestClient.Create();

finalization

if Assigned(RestClient) then
  FreeAndNil(RestClient);

end.
