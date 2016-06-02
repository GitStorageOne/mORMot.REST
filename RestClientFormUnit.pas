unit RestClientFormUnit;

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
  SynLog,
  SynCommons,
  // Custom
  RestClientUnit,
  RestMethodsInterfaceUnit;

type

  TCustomRecord = record helper for rCustomRecord
    procedure FillFromClient();
  end;

  TForm1 = class(TForm)
    EditServerAdress: TEdit;
    EditServerPort: TEdit;
    ButtonStartStop: TButton;
    TimerRefreshLogMemo: TTimer;
    GroupBoxIRestMethods: TGroupBox;
    ButtonMethHelloWorld: TButton;
    ButtonMethSum: TButton;
    ButtonGetCustomRecord: TButton;
    LabelAuthenticationMode: TLabel;
    ComboBoxAuthMode: TComboBox;
    ButtonMethSendCustomRecord: TButton;
    MemoLog: TMemo;
    ButtonCLS: TButton;
    CheckBoxAutoScroll: TCheckBox;
    CheckBoxDisableLog: TCheckBox;
    ButtonMethSendMultipleCustomRecords: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartStopClick(Sender: TObject);
    procedure ButtonCLSClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerRefreshLogMemoTimer(Sender: TObject);
    procedure ButtonMethHelloWorldClick(Sender: TObject);
    procedure ButtonMethSumClick(Sender: TObject);
    procedure ButtonGetCustomRecordClick(Sender: TObject);
    procedure ComboBoxAuthModeChange(Sender: TObject);
    procedure ButtonMethSendCustomRecordClick(Sender: TObject);
    procedure CheckBoxDisableLogClick(Sender: TObject);
    procedure ButtonMethSendMultipleCustomRecordsClick(Sender: TObject);
  private
    { Private declarations }
    function LogEvent(Sender: TTextWriter; Level: TSynLogInfo; const Text: RawUTF8): boolean;
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
{ TCustomResult }

procedure TCustomRecord.FillFromClient();
var
  i: Integer;
begin
  ResultCode := 200;
  ResultStr := 'Awesome';
  ResultTimeStamp := Now();
  SetLength(ResultArray, 3);
  for i := 0 to 2 do
    ResultArray[i] := 'str_' + i.ToString();
end;

{ Form1 }

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
  i: Integer;
  List: TList<TLocalLog>;
begin
  DestroyClient();
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

// Changing client auth mode

// Grabbing new events from thread safe list
procedure TForm1.TimerRefreshLogMemoTimer(Sender: TObject);
var
  List: TList<TLocalLog>;
  i: Integer;
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
  if ClientCreated() then
    ButtonStartStop.Caption := 'Stop client'
  else
    ButtonStartStop.Caption := 'Start client';
end;

// Clears log memo
procedure TForm1.ButtonCLSClick(Sender: TObject);
begin
  MemoLog.Clear;
end;

// Manual server unload
procedure TForm1.ButtonStartStopClick(Sender: TObject);
var
  AM: lAuthMode;
  CreateClientOptions: rCreateClientOptions;
begin
  if ClientCreated() then
    // Unload current server if required
    DestroyClient()
  else
    begin
      // Create server object with selected Auth mode
      AM := lAuthMode(ComboBoxAuthMode.ItemIndex);
      CreateClientOptions.AuthMode := AM;
      CreateClientOptions.HostOrIP := EditServerAdress.Text;
      CreateClientOptions.Port := EditServerPort.Text;
      CreateClient(CreateClientOptions);
    end;
end;

procedure TForm1.ComboBoxAuthModeChange(Sender: TObject);
begin
  if ClientCreated() then
    ButtonStartStopClick(ButtonStartStop);
end;

procedure TForm1.CheckBoxDisableLogClick(Sender: TObject);
begin
  if not CheckBoxDisableLog.Checked then
    TSQLLog.Family.Level := LOG_VERBOSE
  else
    TSQLLog.Family.Level := [];
end;

{ RestServerMethods execution }

procedure TForm1.ButtonMethHelloWorldClick(Sender: TObject);
begin
  if Assigned(RestServerMethods) then
    RestServerMethods.HelloWorld();
end;

procedure TForm1.ButtonMethSendCustomRecordClick(Sender: TObject);
var
  CustomResult: rCustomRecord;
begin
  if Assigned(RestServerMethods) then
    begin
      CustomResult.FillFromClient();
      RestServerMethods.SendCustomRecord(CustomResult);
    end;
end;

procedure TForm1.ButtonMethSumClick(Sender: TObject);
begin
  if Assigned(RestServerMethods) then
    RestServerMethods.Sum(Random(100) + 0.6, Random(100) + 0.3);
end;

procedure TForm1.ButtonGetCustomRecordClick(Sender: TObject);
var
  CustomResult: rCustomRecord;
begin
  if Assigned(RestServerMethods) then
    CustomResult := RestServerMethods.GetCustomRecord();
end;

procedure TForm1.ButtonMethSendMultipleCustomRecordsClick(Sender: TObject);
var
  cr: rCustomRecord;
  ccr: rCustomComplicatedRecord;
begin
  if Assigned(RestServerMethods) then
    begin
      cr.FillFromClient();
      ccr.SimpleString := 'Simple string, Простая строка, 単純な文字列';
      ccr.SimpleInteger := 100500;
      ccr.AnotherRecord := cr;
      RestServerMethods.SendMultipleCustomRecords(cr, ccr);
    end;
end;

end.
