unit RestServerFormUnit;

// mORMot RESTful API test case 1.02

interface

uses
  // RTL
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  // mORMot
  mORMot,
  mORMotHttpServer,
  SynLog,
  SynCommons,
  // Custom
  RestServerUnit;

type
  TForm1 = class(TForm)
    EditPort: TEdit;
    LabelPortCap: TLabel;
    ButtonStartStop: TButton;
    MemoLog: TMemo;
    ButtonCLS: TButton;
    TimerRefreshLogMemo: TTimer;
    CheckBoxAutoScroll: TCheckBox;
    LabelAuthenticationMode: TLabel;
    ComboBoxAuthMode: TComboBox;
    ButtonShowAuthInfo: TButton;
    CheckBoxDisableLog: TCheckBox;
    CheckBoxUseHTTPsys: TCheckBox;
    procedure ButtonStartStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonCLSClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerRefreshLogMemoTimer(Sender: TObject);
    procedure ComboBoxAuthModeChange(Sender: TObject);
    procedure ButtonShowAuthInfoClick(Sender: TObject);
    procedure CheckBoxDisableLogClick(Sender: TObject);
  private
    function LogEvent(Sender: TTextWriter; Level: TSynLogInfo; const Text: RawUTF8): boolean;
    function GetAuthModeDescription(AM: lAuthMode): string;
  public
    { Public declarations }
  end;

  TLocalLog = class
    Level: TSynLogInfo;
    Text: RawUTF8;
  end;

var
  Form1: TForm1;
  LogThreadSafeList: TThreadList<TLocalLog>;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Create thread safe List with log data class
  LogThreadSafeList := TThreadList<TLocalLog>.Create();
  // Enable logging
  with TSQLLog.Family do
    begin
      Level := LOG_VERBOSE;
      EchoCustom := LogEvent;
      NoFile := True;
    end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: integer;
  List: TList<TLocalLog>;
begin
  DestroyServer();
  // Clear and destroy LogThreadSafeList
  List := LogThreadSafeList.LockList();
  for i := 0 to List.Count - 1 do
    List.Items[i].Free;
  List.Clear;
  LogThreadSafeList.UnlockList();
  LogThreadSafeList.Free;
end;

// Processing mORMot log event
function TForm1.LogEvent(Sender: TTextWriter; Level: TSynLogInfo; const Text: RawUTF8): boolean;
var
  List: TList<TLocalLog>;
  LogEventData: TLocalLog;
begin
  List := LogThreadSafeList.LockList;
  Result := True;
  try
    LogEventData := TLocalLog.Create();
    LogEventData.Level := Level;
    LogEventData.Text := Text;
    List.Add(LogEventData);
  finally
    LogThreadSafeList.UnlockList();
  end;
end;

// Get description for AuthMode
function TForm1.GetAuthModeDescription(AM: lAuthMode): string;
begin
  case AM of
    NoAuthentication:
      Result := 'Disabled authentication.';
    URI:
      Result := 'Weak authentication scheme using URL-level parameter';
    SignedURI:
      Result := 'Secure authentication scheme using URL-level digital signature - expected format of session_signature is:' + #13 + 'Hexa8(SessionID) + Hexa8(TimeStamp) + ' + #13 +
        'Hexa8(crc32(SessionID + HexaSessionPrivateKey Sha256(salt + PassWord) + Hexa8(TimeStamp) + url))';
    Default:
      Result := 'mORMot secure RESTful authentication scheme, this method will use a password stored via safe SHA-256 hashing in the TSQLAuthUser ORM table';
    None:
      Result := 'mORMot weak RESTful authentication scheme, this method will authenticate with a given username, but no signature' + #13 +
        'on client side, this scheme is not called by TSQLRestClientURI.SetUser() method - so you have to write:' + #13 + 'TSQLRestServerAuthenticationNone.ClientSetUser(Client,''User'','''');';
    HttpBasic:
      Result := 'Authentication using HTTP Basic scheme. This protocol send both name and password as clear (just base-64 encoded) so should only be used over SSL / HTTPS' +
        ', or for compatibility reasons. Will rely on TSQLRestServerAuthenticationNone for authorization, on client side, this scheme is not called by TSQLRestClientURI.SetUser() ' +
        'method - so you have to write: TSQLRestServerAuthenticationHttpBasic.ClientSetUser(Client,''User'',''password'');' + #13 +
        'for a remote proxy-only authentication (without creating any mORMot session), you can write: TSQLRestServerAuthenticationHttpBasic.ClientSetUserHttpOnly(Client,''proxyUser'',''proxyPass'');';
    SSPI:
      Result := 'authentication of the current logged user using Windows Security Support Provider Interface (SSPI)' + #13 +
        '- is able to authenticate the currently logged user on the client side, using either NTLM or Kerberos - it would allow to safely authenticate on a mORMot server without prompting' +
        ' the user to enter its password' + #13 + '- if ClientSetUser() receives aUserName as '''', aPassword should be either '''' if you expect NTLM authentication to take place,' +
        ' or contain the SPN registration (e.g. ''mymormotservice/myserver.mydomain.tld'') for Kerberos authentication.' + #13 +
        '- if ClientSetUser() receives aUserName as ''DomainName\UserName'', then authentication will take place on the specified domain, with aPassword as plain password value.';
  else
    Result := 'Authentication description';
  end;
end;

// Changing server auth mode
procedure TForm1.ComboBoxAuthModeChange(Sender: TObject);
begin
  if ServerCreated() then
    ButtonStartStopClick(ButtonStartStop);
end;

// Grabbing new events from thread safe list
procedure TForm1.TimerRefreshLogMemoTimer(Sender: TObject);
var
  List: TList<TLocalLog>;
  i: integer;
begin
  List := LogThreadSafeList.LockList();
  try
    if Assigned(Form1) and not Application.Terminated and (List.Count > 0) then
      begin
        for i := 0 to List.Count - 1 do
          begin
            Form1.MemoLog.Lines.BeginUpdate();
            Form1.MemoLog.Lines.Add(string(List.Items[i].Text));
            Form1.MemoLog.Lines.EndUpdate();
            List.Items[i].Free;
          end;
        List.Clear();
        if CheckBoxAutoScroll.Checked then
          SendMessage(Form1.MemoLog.Handle, WM_VSCROLL, SB_BOTTOM, 0);
      end;
  finally
    LogThreadSafeList.UnlockList();
  end;
  CheckBoxUseHTTPsys.Enabled := not ServerCreated();
  if ServerCreated then
    ButtonStartStop.Caption := 'Stop server'
  else
    ButtonStartStop.Caption := 'Start server';
end;

// Clears log memo
procedure TForm1.ButtonCLSClick(Sender: TObject);
begin
  MemoLog.Clear;
end;

procedure TForm1.ButtonShowAuthInfoClick(Sender: TObject);
var
  AM: lAuthMode;
begin
  AM := lAuthMode(ComboBoxAuthMode.ItemIndex);
  ShowMessage(GetAuthModeDescription(AM));
end;

procedure TForm1.ButtonStartStopClick(Sender: TObject);
var
  CreateServerOptions: rCreateServerOptions;
begin
  if ServerCreated then
    // Unload current server if required
    DestroyServer()
  else
    begin
      // Create server object with selected Auth mode
      if CheckBoxUseHTTPsys.Checked then
        CreateServerOptions.HttpServerKind := useHttpApiRegisteringURI
      else
        CreateServerOptions.HttpServerKind := useBidirSocket;
      CreateServerOptions.AuthMode := lAuthMode(ComboBoxAuthMode.ItemIndex);
      CreateServerOptions.Port := EditPort.Text;
      CreateServer(CreateServerOptions);
    end;
end;

// Enable/Disable loggint to memo (slow down performance when enabled)
procedure TForm1.CheckBoxDisableLogClick(Sender: TObject);
begin
  if not CheckBoxDisableLog.Checked then
    TSQLLog.Family.Level := LOG_VERBOSE
  else
    TSQLLog.Family.Level := [];
end;

end.
