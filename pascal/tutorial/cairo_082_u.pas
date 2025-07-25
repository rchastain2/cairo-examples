unit cairo_082_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,

  CairoLCL; { https://github.com/blikblum/luipack }

type

  { TForm1 }

  TForm1 = class(TForm)
    CairoPaintBox1: TCairoPaintBox;
    Timer1: TTimer;
    procedure CairoPaintBox1CreateContext(Sender: TObject);
    procedure CairoPaintBox1Draw(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
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

procedure TForm1.CairoPaintBox1CreateContext(Sender: TObject);
begin
  with CairoPaintBox1.Context do
  begin
    Translate(0, Height);
    Scale(Width, -Height);
  end;
end;

procedure TForm1.CairoPaintBox1Draw(Sender: TObject);
begin
  with CairoPaintBox1.Context do
  begin
    SetSourceRgb(1.00, 0.65, Random(100) / 100);
    Paint;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := FALSE;

  CairoPaintBox1.Redraw;

  Timer1.Enabled := TRUE;
end;

end.

