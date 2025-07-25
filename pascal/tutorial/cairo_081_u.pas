
unit cairo_081_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, CairoLCL;

(* https://github.com/blikblum/luipack *)

type

  { TForm1 }

  TForm1 = class(TForm)
    CairoPaintBox1: TCairoPaintBox;
    procedure CairoPaintBox1Draw(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.CairoPaintBox1Draw(Sender: TObject);
begin
  with CairoPaintBox1, Context do
  begin
    Scale(Width, Height);
    SetSourceRGBA(1.0, 1.0, 1.0, 1.0);
    Paint;
    SetSourceRGBA(0.0, 0.0, 1.0, 0.5);
    LineWidth := 0.1;
    MoveTo(0.1, 0.1);
    LineTo(0.9, 0.9);
    Stroke;
  end;
end;

end.
