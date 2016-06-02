program mORMotRESTsrv;

{$I Synopse.inc}

uses
  Vcl.Forms,
  RestServerFormUnit in 'RestServerFormUnit.pas' {Form1},
  RestServerUnit in 'RestServerUnit.pas',
  RestServerMethodsUnit in 'RestServerMethodsUnit.pas',
  RestMethodsInterfaceUnit in 'RestMethodsInterfaceUnit.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Turquoise Gray');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
