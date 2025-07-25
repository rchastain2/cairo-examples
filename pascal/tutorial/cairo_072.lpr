program cairo_072;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, cairo_072_u;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

