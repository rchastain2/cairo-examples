program image;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, image_u;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  //Application.ShowMainForm := False; // Add this line, so mainform will not show at startup
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

