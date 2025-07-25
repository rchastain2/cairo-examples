
uses
  sysutils, cairo, knight;

procedure DrawPath(const aPath: TVectorArray);

  function F(const i: integer): double; inline;
  begin
    result := i / 8 - 1 / 16;
  end;

var 
  cr: pcairo_t;
  surface: pcairo_surface_t;
  x, y, i: integer;
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 256, 256);
  cr := cairo_create(surface);
  
  cairo_translate(cr, 0, 256);
  cairo_scale(cr, 256, -256);
  
  cairo_set_source_rgb(cr, 1.00, 0.65, 0.00);
  cairo_paint(cr);
  
  for x := 1 to 8 do for y := 1 to 8 do
    if (x + y) mod 2 = 0 then
    begin
      cairo_set_source_rgb(cr, 1.00, 0.55, 0.00);
      cairo_rectangle(cr, Pred(x) / 8, Pred(y) / 8, 1 / 8, 1 / 8);
      cairo_fill(cr);
    end;
  
  cairo_set_line_width(cr, 1 / 100);
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND);
  cairo_set_source_rgb(cr, 1.00, 1.00, 0.00);
  cairo_move_to(
    cr,
    F(aPath[0].x),
    F(aPath[0].y)
  );
  for i := 1 to High(aPath) do
    cairo_line_to(
      cr,
      F(aPath[i].x),
      F(aPath[i].y)
    );
  cairo_stroke(cr);  
  
  cairo_surface_write_to_png(surface, pchar(ChangeFileExt(ParamStr(0), '.png')));
  
  cairo_destroy(cr);
  cairo_surface_destroy(surface);
end;

var
  path: TVectorArray;

begin
  SetLength(path, 0);
  SearchPath(6, 5, path); // Recherche d'un chemin partant de la case F5
  if Length(path) > 0 then
    DrawPath(path);
  SetLength(path, 0);
end.
