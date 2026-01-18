program bouncingballs;

uses
  Forms,
  Interfaces,
  Main in 'main.pas' {Form1},
  Ball in 'ball.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
