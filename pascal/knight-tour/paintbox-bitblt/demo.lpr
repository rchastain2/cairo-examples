program demo;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, demo_u;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

