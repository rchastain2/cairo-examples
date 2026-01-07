unit main;

{$MODE Delphi}

interface

uses
  Classes, SysUtils, Windows, Graphics,
  Forms, Controls, StdCtrls, ExtCtrls,
  Cairo, CairoWin32;

type
  TfMain        = class(TForm)
    lVer        : TLabel;
    pb          : TPaintBox;
    tUpdate     : TTimer;
    procedure   FormCreate(Sender:TObject);
    procedure   pbPaint(Sender:TObject);
    procedure   tUpdateTimer(Sender:TObject);
  private
    procedure   PaintClock;
  end;

var
  fMain: TfMain;

implementation

{$r *.lfm}

procedure TfMain.FormCreate(Sender:TObject);
begin
  lVer.Caption := 'Cairo Version '+cairo_version_string;
end;

procedure TfMain.PaintClock;
var
  surface     : Pcairo_surface_t;
  cr          : Pcairo_t;
  hh,mm,ss,ms : Word;
  h,m,s       : Double;
begin
  DecodeTime(Now,hh,mm,ss,ms);
	h := (hh+mm/60)*pi/6;
  m := mm*pi/30;
	s := ss*pi/30;

//surface := cairo_win32_surface_create(pb.Canvas.Handle);
  surface := cairo_win32_surface_create_with_dib(CAIRO_FORMAT_ARGB32,pb.Width,pb.Height);
	cr      := cairo_create(surface);
	cairo_scale(cr,pb.Height,pb.Height);

  // Draw the entire context white
  cairo_set_source_rgba(cr,1,1,1,1);
  cairo_paint(cr);

  cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND);
  cairo_set_line_width(cr,0.1);

  // Translate to the center of the rendering context and draw a black clock outline
  cairo_set_source_rgba(cr,0,0,0,1);
  cairo_translate(cr,0.5,0.5);
  cairo_arc(cr,0,0,0.4,0,pi*2);
  cairo_stroke(cr);

  // Draw a white dot on the current second
  cairo_set_source_rgba(cr,1,1,1,0.6);
  cairo_arc(cr,Sin(s)*0.4,-Cos(s)*0.4,0.05,0,pi*2);
  cairo_fill(cr);

  // Draw the minutes indicator
  cairo_set_source_rgba(cr,0.2,0.2,1,0.6);
  cairo_move_to(cr,0, 0);
  cairo_line_to(cr,Sin(m)*0.4,-Cos(m)*0.4);
  cairo_stroke (cr);

  // Draw the hours indicator
  cairo_move_to(cr,0,0);
  cairo_line_to(cr,Sin(h)*0.2,-Cos(h)*0.2);
  cairo_stroke(cr);

  cairo_destroy(cr);
  BitBlt(pb.Canvas.Handle,0,0,pb.Width,pb.Height,cairo_win32_surface_get_dc(surface),0,0,SRCCOPY);
  cairo_surface_destroy(surface);
end;


procedure TfMain.pbPaint(Sender:TObject);
begin
  PaintClock;
end;

procedure TfMain.tUpdateTimer(Sender:TObject);
begin
  PaintClock;
end;

end.
