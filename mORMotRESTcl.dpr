program mORMotRESTcl;

{$I Synopse.inc}

uses
  Vcl.Forms,
  RestClientFormUnit in 'RestClientFormUnit.pas' {Form1},
  RestMethodsInterfaceUnit in 'RestMethodsInterfaceUnit.pas',
  RestClientUnit in 'RestClientUnit.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Turquoise Gray');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
