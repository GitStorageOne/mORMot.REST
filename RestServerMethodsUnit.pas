unit RestServerMethodsUnit;

interface

uses
  // RTL
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  // mORMot
  mORMot,
  mORMotHttpServer,
  SynCommons,
  // Custom
  RestMethodsInterfaceUnit;

type

  TCustomRecord = record helper for rCustomRecord
    procedure FillResultFromServer();
  end;

  TRestMethods = class(TInjectableObjectRest, IRestMethods)
  public
    function HelloWorld(): string;
    function Sum(val1, val2: Double): Double;
    function GetCustomRecord(): rCustomRecord;
    function SendCustomRecord(const CustomResult: rCustomRecord): Boolean;
    function SendMultipleCustomRecords(const CustomResult: rCustomRecord; const CustomComplicatedRecord: rCustomComplicatedRecord): Boolean;
  end;

implementation

{ TCustomResultSrv }

procedure TCustomRecord.FillResultFromServer();
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

{ TServiceServer }

// [!] ServiceContext can be used from any method to access low level request data

// Test 2
function TRestMethods.HelloWorld(): string;
begin
  Result := 'Hello world';
end;

// Test 2.1
function TRestMethods.Sum(val1, val2: Double): Double;
begin
  Result := val1 + val2;
end;

// Test 2.2
function TRestMethods.GetCustomRecord(): rCustomRecord;
begin
  Result.FillResultFromServer();
end;

// Test 2.3
function TRestMethods.SendCustomRecord(const CustomResult: rCustomRecord): Boolean;
begin
  Result := True;
end;

// Test 2.4
function TRestMethods.SendMultipleCustomRecords(const CustomResult: rCustomRecord; const CustomComplicatedRecord: rCustomComplicatedRecord): Boolean;
begin
  Result := True;
end;

end.
