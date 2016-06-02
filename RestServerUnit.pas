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
  SynCommons,
  SynCrtSock,
  // Custom
  RestMethodsInterfaceUnit,
  RestServerMethodsUnit;

type
  lAuthMode = (NoAuthentication, URI, SignedURI, Default, None, HttpBasic, SSPI);

  rCreateServerOptions = record
    HttpServerKind: TSQLHttpServerOptions;
    AuthMode: lAuthMode;
    Port: string;
  end;

var
  Model: TSQLModel;
  RestServer: TSQLRestServer;
  HTTPServer: TSQLHttpServer;
  // Internal settings for tests
  UseHTTPsys: boolean = false;

function CreateServer(Options: rCreateServerOptions): boolean;
procedure DestroyServer();
function ServerCreated(): boolean;

implementation

function CreateServer(Options: rCreateServerOptions): boolean;
begin
  Result := false;
  // Destroy current object
  DestroyServer();
  // Server initialization (for better understanding, each section contain separate code, later should be refactored)
  case Options.AuthMode of
    // NoAuthentication
    NoAuthentication:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        RestServer := TSQLRestServerFullMemory.Create(Model, false);
        RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
        try
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', Options.HttpServerKind);
          Result := True;
        except
          on E: Exception do
            begin
              ShowMessage(E.ToString);
              DestroyServer();
            end;
        end;
      end;
    // TSQLRestServerAuthenticationURI
    URI:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        RestServer := TSQLRestServerFullMemory.Create(Model, false);
        RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
        try
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', Options.HttpServerKind);
          Result := True;
        except
          on E: Exception do
            begin
              ShowMessage(E.ToString);
              DestroyServer();
            end;
        end;
      end;
    // TSQLRestServerAuthenticationSignedURI
    SignedURI:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        RestServer := TSQLRestServerFullMemory.Create(Model, false);
        RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
        try
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', Options.HttpServerKind);
          Result := True;
        except
          on E: Exception do
            begin
              ShowMessage(E.ToString);
              DestroyServer();
            end;
        end;
      end;
    // TSQLRestServerAuthenticationDefault
    Default:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        RestServer := TSQLRestServerFullMemory.Create(Model, false);
        RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
        try
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', Options.HttpServerKind);
          Result := True;
        except
          on E: Exception do
            begin
              ShowMessage(E.ToString);
              DestroyServer();
            end;
        end;
      end;
    // TSQLRestServerAuthenticationNone
    None:
      begin
        // Model := TSQLModel.Create([TSQLAuthGroup,TSQLAuthUser], ROOT_NAME);
        Model := TSQLModel.Create([], ROOT_NAME);
        RestServer := TSQLRestServerFullMemory.Create(Model, false);
        RestServer.AuthenticationRegister(TSQLRestServerAuthenticationNone);
        RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
        try
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', Options.HttpServerKind);
          Result := True;
        except
          on E: Exception do
            begin
              ShowMessage(E.ToString);
              DestroyServer();
            end;
        end;
      end;
    // TSQLRestServerAuthenticationHttpBasic
    HttpBasic:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        RestServer := TSQLRestServerFullMemory.Create(Model, false);
        RestServer.AuthenticationRegister(TSQLRestServerAuthenticationHttpBasic);
        RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
        try
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', Options.HttpServerKind);
          Result := True;
        except
          on E: Exception do
            begin
              ShowMessage(E.ToString);
              DestroyServer();
            end;
        end;
      end;
    // TSQLRestServerAuthenticationSSPI
    SSPI:
      begin
        Model := TSQLModel.Create([], ROOT_NAME);
        RestServer := TSQLRestServerFullMemory.Create(Model, false);
        RestServer.ServiceDefine(TRestMethods, [IRestMethods], SERVICE_INSTANCE_IMPLEMENTATION);
        try
          HTTPServer := TSQLHttpServer.Create(AnsiString(Options.Port), [RestServer], '+', Options.HttpServerKind);
          Result := True;
        except
          on E: Exception do
            begin
              ShowMessage(E.ToString);
              DestroyServer();
            end;
        end;
      end;
  end;
end;

procedure DestroyServer();
begin
// if used HttpApiRegisteringURI then remove registration (require run as admin), but seems not work from here
  if Assigned(HTTPServer) and (HTTPServer.HTTPServer.ClassType = THttpApiServer) then
    THttpApiServer(HTTPServer.HTTPServer).RemoveUrl(ROOT_NAME, HTTPServer.Port, false, '+');
  FreeAndNil(HTTPServer);
  FreeAndNil(RestServer);
  FreeAndNil(Model);
end;

function ServerCreated(): boolean;
begin
  Result := Assigned(HTTPServer);
end;

end.
