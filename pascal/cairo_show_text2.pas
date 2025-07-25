
uses
  SysUtils, Cairo;

type
  TData = array[0..5] of record
    scale, value: integer;
  end;
  
const
  CData: TData = (
    (scale: 100; value: 0),
    (scale: 100; value: 0),
    (scale: 100; value: 0),
    (scale: 100; value: 0),
    (scale: 100; value: 0),
    (scale: 100; value: 0)
  );

procedure DrawBackground(c: pcairo_t; r, g, b, a: double);
var
  i: integer;
begin
  cairo_set_source_rgba(c, r, g, b, a);
  for i := 0 to 5 do
  begin
    cairo_move_to(c, 0.0, 0.0);
    cairo_line_to(c, 3 / 8, 0.0);
    cairo_rotate(c, PI / 3);
  end;
  cairo_stroke(c);
end;

procedure DrawLegend(c: pcairo_t; r, g, b, a: double);
function X(i: integer; r: double): double; begin result := 0.0 + ({3 / 8}7 / 16) * cos(i * (PI / 3)) * r; end;
function Y(i: integer; r: double): double; begin result := 0.0 + ({3 / 8}7 / 16) * sin(i * (PI / 3)) * r; end;
var
  i: integer;
  e: cairo_text_extents_t;
begin
  cairo_set_source_rgba(c, r, g, b, a); 
  for i := 0 to 5 do
  begin
    cairo_text_extents(c, pchar(Format('%.2d', [i])), @e);
    cairo_move_to(c, X(i, 1.0) - e.width / 2, Y(i, 1.0));
    cairo_show_text(c, pchar(Format('%.2d', [i])));
  end;
  
  cairo_stroke(c);
end;

procedure DrawData(c: pcairo_t; aData: TData; r, g, b, a: double);
function X(i: integer; r: double): double; begin result := 0.0 + (3 / 8) * cos(i * (PI / 3)) * r; end;
function Y(i: integer; r: double): double; begin result := 0.0 + (3 / 8) * sin(i * (PI / 3)) * r; end;
var
  i: integer;
begin
  cairo_set_source_rgba(c, r, g, b, a); 
  
  i := 5;
  cairo_move_to(
    c,
    X(i, aData[i].value / aData[i].scale),
    Y(i, aData[i].value / aData[i].scale)
  );
  
  for i := 0 to 5 do
    cairo_line_to(
      c,
      X(i, aData[i].value / aData[i].scale),
      Y(i, aData[i].value / aData[i].scale)
    );
  
  cairo_stroke(c);
end;

var
  data: TData;
  
const
  WIDTH = 512;
  
var
  c: pcairo_t;
  s: pcairo_surface_t;
  i: integer;
  
begin
  Randomize;
  
  data := CData;
  
  s := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, WIDTH, WIDTH);
  c := cairo_create(s);
  
  cairo_scale(c, WIDTH, WIDTH);
  cairo_translate(c, 1 / 2, 1 / 2);
	cairo_set_source_rgb(c, 1.0, 1.0, 1.0);
  cairo_paint(c);
  
  cairo_set_line_width(c, 1 / 1000);
  DrawBackground(c, 0.0, 0.0, 0.0, 1.0);
  
  cairo_select_font_face(c, 'Courier New', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size(c, 1 / 24);
  DrawLegend(c, 0.0, 0.0, 0.0, 1.0);
  
  cairo_set_line_width(c, 1 / 200);
  for i := Low(data) to High(data) do data[i].value := Random(data[i].scale div 3) + data[i].scale div 3;
  DrawData(c, data, 1.0, 0.0, 0.0, 1.0);
  for i := Low(data) to High(data) do data[i].value := data[i].value + (Random(3) - 1) * data[i].scale div 9;
  DrawData(c, data, 0.0, 1.0, 0.0, 1.0);
  for i := Low(data) to High(data) do data[i].value := data[i].value + (Random(3) - 1) * data[i].scale div 9;
  DrawData(c, data, 0.0, 0.0, 1.0, 1.0);
  
  cairo_surface_write_to_png(s, pchar('image.png'));
  
  cairo_destroy(c);
  cairo_surface_destroy(s);
end.
