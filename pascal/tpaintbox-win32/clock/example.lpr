program example;

{$MODE Delphi}

uses
  Forms, Interfaces,
  main in 'main.pas' {fMain};

{$r *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
