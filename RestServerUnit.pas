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
  lAuthorizationMode = (NoAuthorization, URI, SignedURI, Default, None, HttpBasic, SSPI);

  rCreateServerOptions = record
    Protocol: lProtocol;
    AuthMode: lAuthorizationMode;
    Port: string;
  end;

var
  Model: TSQLModel;
  RestServer: TSQLRestServer;
  HTTPServer: TSQLHttpServer;

function CreateServer(Options: rCreateServerOptions): boolean;
procedure DestroyServer();
function ServerCreated(): boolean;

implementation

procedure ApplyAuthenticationRules(ServiceFactoryServer: TServiceFactoryServer);
var
  ID: TID;
  GROUP: TSQLAuthGroup;
begin // TSQLAuthUser, TSQLAuthGroup
  ID := RestServer.MainFieldID(TSQLAuthGroup, 'User');
  GROUP := TSQLAuthGroup.Create(RestServer, ID);
  GROUP.Free;
  ServiceFactoryServer.AllowAll();
end;

function CreateServer(Options: rCreateServerOptions): boolean;
var
  ServiceFactoryServer: TServiceFactoryServer;
  WebSocketServerRest: TWebSocketServerRest;
begin
  Result := false;
  // Destroy current object
  DestroyServer();
  // Server initialization (!!! for better understanding, each section contain separate code, later should be refactored)
  case Options.AuthMode of
    // NoAuthentication
    NoAuthorization:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        RestServer := TSQLRestServerFullMemory.Create(Model, false);
        RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
      end;
    // TSQLRestServerAuthenticationURI
    URI:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        RestServer := TSQLRestServerFullMemory.Create(Model, false { make AuthenticationSchemesCount = 0 } );
        ServiceFactoryServer := RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
        RestServer.AuthenticationRegister(TSQLRestServerAuthenticationURI); // register single authentication mode
        ApplyAuthenticationRules(ServiceFactoryServer);
      end;
{$REGION 'Other Auth modes UNDER DEVELOPMENT'}
    // // TSQLRestServerAuthenticationSignedURI
    // SignedURI:
    // begin
    // Model := TSQLModel.Create([], ROOT_NAME);
    // RestServer := TSQLRestServerFullMemory.Create(Model, false);
    // RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
    // try
    // HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', Options.HttpServerKind);
    // Result := True;
    // except
    // on E: Exception do
    // begin
    // ShowMessage(E.ToString);
    // DestroyServer();
    // end;
    // end;
    // end;
    // // TSQLRestServerAuthenticationDefault
    // Default:
    // begin
    // Model := TSQLModel.Create([], ROOT_NAME);
    // RestServer := TSQLRestServerFullMemory.Create(Model, false);
    // RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
    // try
    // HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', Options.HttpServerKind);
    // Result := True;
    // except
    // on E: Exception do
    // begin
    // ShowMessage(E.ToString);
    // DestroyServer();
    // end;
    // end;
    // end;
    // // TSQLRestServerAuthenticationNone
    // None:
    // begin
    // // Model := TSQLModel.Create([TSQLAuthGroup,TSQLAuthUser], ROOT_NAME);
    // Model := TSQLModel.Create([], ROOT_NAME);
    // RestServer := TSQLRestServerFullMemory.Create(Model, false);
    // RestServer.AuthenticationRegister(TSQLRestServerAuthenticationNone);
    // RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
    // try
    // HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', Options.HttpServerKind);
    // Result := True;
    // except
    // on E: Exception do
    // begin
    // ShowMessage(E.ToString);
    // DestroyServer();
    // end;
    // end;
    // end;
    // // TSQLRestServerAuthenticationHttpBasic
    // HttpBasic:
    // begin
    // Model := TSQLModel.Create([], ROOT_NAME);
    // RestServer := TSQLRestServerFullMemory.Create(Model, false);
    // RestServer.AuthenticationRegister(TSQLRestServerAuthenticationHttpBasic);
    // RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
    // try
    // HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', Options.HttpServerKind);
    // Result := True;
    // except
    // on E: Exception do
    // begin
    // ShowMessage(E.ToString);
    // DestroyServer();
    // end;
    // end;
    // end;
    // // TSQLRestServerAuthenticationSSPI
    // SSPI:
    // begin
    // Model := TSQLModel.Create([], ROOT_NAME);
    // RestServer := TSQLRestServerFullMemory.Create(Model, false);
    // RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
    // try
    // HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', Options.HttpServerKind);
    // Result := True;
    // except
    // on E: Exception do
    // begin
    // ShowMessage(E.ToString);
    // DestroyServer();
    // end;
    // end;
    // end;
{$ENDREGION}
  else
    begin
      DestroyServer();
      raise Exception.Create('Selected Authentication mode not available in this build.');
    end;
  end;
  // protocol initialization
  try
    case Options.Protocol of
      HTTP_Socket:
        begin
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', useHttpSocket);
        end;
      // HTTPsys:
      // begin
      // HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', useHttpApi); // require manual URI registration
      // end;
      HTTPsys:
        begin
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', useHttpApiRegisteringURI);
        end;
      WebSocketBidir_JSON:
        begin
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', useBidirSocket);
          WebSocketServerRest := HTTPServer.WebSocketsEnable(RestServer, '', True);
        end;
      WebSocketBidir_Binary:
        begin
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', useBidirSocket);
          WebSocketServerRest := HTTPServer.WebSocketsEnable(RestServer, '', false);
        end;
      WebSocketBidir_BinaryAES:
        begin
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', useBidirSocket);
          WebSocketServerRest := HTTPServer.WebSocketsEnable(RestServer, '2141D32ADAD54D9A9DB56000CC9A4A70', false);
        end;
      // NamedPipe:
      // begin
      // end;
    else
      begin
        DestroyServer();
        raise Exception.Create('Selected protocol not available in this build.');
      end;
    end;
    Result := True;
  except
    on E: Exception do
      begin
        ShowMessage(E.ToString);
        DestroyServer();
      end;
  end;
  //
end;

procedure DestroyServer();
begin
  // if used HttpApiRegisteringURI then remove registration (require run as admin), but seems not work from here
  if Assigned(HTTPServer) and (HTTPServer.HTTPServer.ClassType = THttpApiServer) then
    THttpApiServer(HTTPServer.HTTPServer).RemoveUrl(ROOT_NAME, HTTPServer.Port, false, '+');
  if Assigned(HTTPServer) then
    FreeAndNil(HTTPServer);
  if Assigned(RestServer) then
    FreeAndNil(RestServer);
  if Assigned(Model) then
    FreeAndNil(Model);
end;

function ServerCreated(): boolean;
begin
  Result := Assigned(HTTPServer);
end;

end.
