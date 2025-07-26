program pendule;

{$MODE Delphi}

uses
  Forms, Interfaces,
  mainform {fMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
