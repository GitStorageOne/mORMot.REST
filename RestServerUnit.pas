unit RestServerUnit;

interface

uses
  // RTL
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  Vcl.Dialogs,
  // mORMot
  mORMot,
  mORMotHttpServer,
  SynBidirSock,
  SynCommons,
  SynCrtSock,
  // Custom
  RestMethodsInterfaceUnit,
  RestServerMethodsUnit;

type
  lProtocol = (HTTP_Socket, HTTPsys, WebSocketBidir_JSON, WebSocketBidir_Binary, WebSocketBidir_BinaryAES, NamedPipe);
  lAuthenticationMode = (NoAuthentication, URI, SignedURI, Default, None, HttpBasic, SSPI);

  rServerSettings = record
    Protocol: lProtocol;
    AuthMode: lAuthenticationMode;
    Port: string;
  end;

  tRestServer = class
  private
    fModel: TSQLModel;
    fRestServer: TSQLRestServer;
    fHTTPServer: TSQLHttpServer;
    fServerSettings: rServerSettings;
    fInitialized: boolean;
    procedure ApplyAuthenticationRules(ServiceFactoryServer: TServiceFactoryServer);
  public
    property Initialized: boolean read fInitialized;
    constructor Create();
    destructor Destroy(); override;
    function Initialize(SrvSettings: rServerSettings): boolean;
    function DeInitialize(): boolean;
  end;

var
  RestServer: tRestServer;

implementation

{ tRestServer }

constructor tRestServer.Create();
begin
  //
end;

destructor tRestServer.Destroy();
begin
  DeInitialize();
  inherited;
end;

procedure tRestServer.ApplyAuthenticationRules(ServiceFactoryServer: TServiceFactoryServer);
var
  ID: TID;
  GROUP: TSQLAuthGroup;
begin // TSQLAuthUser, TSQLAuthGroup
  ID := fRestServer.MainFieldID(TSQLAuthGroup, 'User');
  GROUP := TSQLAuthGroup.Create(fRestServer, ID);
  GROUP.Free;
  ServiceFactoryServer.AllowAll();
end;

function tRestServer.Initialize(SrvSettings: rServerSettings): boolean;
var
  ServiceFactoryServer: TServiceFactoryServer;
  { WebSocketServerRest: TWebSocketServerRest; }
begin
  Result := false;
  // Destroy current object
  if DeInitialize() then
    try
      // Server initialization (!!! for better understanding, each section contain separate code, later should be refactored)
      fServerSettings := SrvSettings;
      case fServerSettings.AuthMode of
        // NoAuthentication
        NoAuthentication:
          begin
            fModel := TSQLModel.Create([], ROOT_NAME);
            fRestServer := TSQLRestServerFullMemory.Create(fModel, false);
            fRestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
          end;
        // TSQLRestServerAuthenticationURI
        URI:
          begin
            fModel := TSQLModel.Create([], ROOT_NAME);
            fRestServer := TSQLRestServerFullMemory.Create(fModel, false { make AuthenticationSchemesCount = 0 } );
            ServiceFactoryServer := fRestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
            fRestServer.AuthenticationRegister(TSQLRestServerAuthenticationURI); // register single authentication mode
            ApplyAuthenticationRules(ServiceFactoryServer);
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
            fModel := TSQLModel.Create([], ROOT_NAME);
            fRestServer := TSQLRestServerFullMemory.Create(fModel, false { make AuthenticationSchemesCount = 0 } );
            ServiceFactoryServer := fRestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
            fRestServer.AuthenticationRegister(TSQLRestServerAuthenticationDefault); // register single authentication mode
            ApplyAuthenticationRules(ServiceFactoryServer);
          end;
        // TSQLRestServerAuthenticationNone
        None:
          begin
            fModel := TSQLModel.Create([], ROOT_NAME);
            fRestServer := TSQLRestServerFullMemory.Create(fModel, false { make AuthenticationSchemesCount = 0 } );
            ServiceFactoryServer := fRestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
            fRestServer.AuthenticationRegister(TSQLRestServerAuthenticationNone); // register single authentication mode
            ApplyAuthenticationRules(ServiceFactoryServer);
          end;
        // TSQLRestServerAuthenticationHttpBasic
        HttpBasic:
          begin
            fModel := TSQLModel.Create([], ROOT_NAME);
            fRestServer := TSQLRestServerFullMemory.Create(fModel, false { make AuthenticationSchemesCount = 0 } );
            ServiceFactoryServer := fRestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
            fRestServer.AuthenticationRegister(TSQLRestServerAuthenticationHttpBasic); // register single authentication mode
            ApplyAuthenticationRules(ServiceFactoryServer);
          end;
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
      // protocol initialization
      case fServerSettings.Protocol of
        HTTP_Socket:
          begin
            fHTTPServer := TSQLHttpServer.Create(AnsiString(fServerSettings.Port), [fRestServer], '+', useHttpSocket);
          end;
        {
          // require manual URI registration, we will not use this option
          HTTPsys:
          begin
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', useHttpApi);
          end;
        }
        HTTPsys:
          begin
            fHTTPServer := TSQLHttpServer.Create(AnsiString(fServerSettings.Port), [fRestServer], '+', useHttpApiRegisteringURI);
          end;
        WebSocketBidir_JSON:
          begin
            fHTTPServer := TSQLHttpServer.Create(AnsiString(fServerSettings.Port), [fRestServer], '+', useBidirSocket);
            { WebSocketServerRest := } fHTTPServer.WebSocketsEnable(fRestServer, '', True);
          end;
        WebSocketBidir_Binary:
          begin
            fHTTPServer := TSQLHttpServer.Create(AnsiString(fServerSettings.Port), [fRestServer], '+', useBidirSocket);
            { WebSocketServerRest := } fHTTPServer.WebSocketsEnable(fRestServer, '', false);
          end;
        WebSocketBidir_BinaryAES:
          begin
            fHTTPServer := TSQLHttpServer.Create(AnsiString(fServerSettings.Port), [fRestServer], '+', useBidirSocket);
            { WebSocketServerRest := } fHTTPServer.WebSocketsEnable(fRestServer, '2141D32ADAD54D9A9DB56000CC9A4A70', false);
          end;
        NamedPipe:
          begin
            if not fRestServer.ExportServerNamedPipe(NAMED_PIPE_NAME) then
              Exception.Create('Unable to register server with named pipe channel.');
          end;
      else
        begin
          DeInitialize();
          raise Exception.Create('Selected protocol not available in this build.');
        end;
      end;
      Result := True;
    except
      on E: Exception do
        begin
          ShowMessage(E.ToString);
          DeInitialize();
        end;
    end;
  fInitialized := Result;
end;

function tRestServer.DeInitialize(): boolean;
begin
  Result := True;
  try
    // if used HttpApiRegisteringURI then remove registration (require run as admin), but seems not work from here
    if Assigned(fHTTPServer) and (fHTTPServer.HTTPServer.ClassType = THttpApiServer) then
      THttpApiServer(fHTTPServer.HTTPServer).RemoveUrl(ROOT_NAME, fHTTPServer.Port, false, '+');
    if Assigned(fHTTPServer) then
      FreeAndNil(fHTTPServer);
    if Assigned(fRestServer) then
      FreeAndNil(fRestServer);
    if Assigned(fModel) then
      FreeAndNil(fModel);
    fInitialized := false;
  except
    on E: Exception do
      begin
        ShowMessage(E.ToString);
        Result := false;
      end;
  end;
end;

initialization

RestServer := tRestServer.Create();

finalization

if Assigned(RestServer) then
  FreeAndNil(RestServer);

end.
