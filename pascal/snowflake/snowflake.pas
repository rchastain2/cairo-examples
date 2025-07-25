
program Snowflake;

{ http://www.informatik.uni-kiel.de/~sb/WissRech/cairo3_recursion.c }

uses
  cairo;

procedure snowflake_arm(cr: pcairo_t; l: integer);
begin
  cairo_move_to(cr, 0.0, 0.0);
  cairo_line_to(cr, 0.0, 0.5);
  cairo_stroke(cr);

  if l > 0 then
  begin
    cairo_save(cr);

    cairo_translate(cr, 0.0, 0.5);
    cairo_scale(cr, 0.45, 0.45);

    snowflake_arm(cr, l - 1);

    cairo_rotate(cr, 1.2);
    snowflake_arm(cr, l - 1);

    cairo_rotate(cr, -2.4);
    snowflake_arm(cr, l - 1);

    cairo_restore(cr);
  end;
end;

const
  ZOOM = 3;
  
var 
  cr: pcairo_t;
  surface: pcairo_surface_t;
  i, l: integer;
  
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, ZOOM * 400, ZOOM * 80);

  cr := cairo_create(surface);
  (*
	cairo_set_source_rgba(cr, 1, 1, 1, 1);
	cairo_paint(cr);
  *)
  cairo_set_source_rgba(cr, 0, 0, 0, 1);
  
  for l := 0 to 4 do
  begin
    cairo_save(cr);
    cairo_translate(cr, ZOOM * 40.0 + l * ZOOM * 80.0, ZOOM * 40.0);
    cairo_scale(cr, ZOOM * 40.0, ZOOM * 40.0);
    cairo_set_line_width(cr, 0.01);

    for i := 0 to 4 do
    begin
      cairo_save(cr);
      cairo_rotate(cr, 2.0 * PI * i / 5);
      snowflake_arm(cr, l);
      cairo_restore(cr);
    end;
    
    cairo_restore(cr);
  end;
  
  cairo_surface_write_to_png(surface, 'snowflake.png');
  cairo_destroy(cr);
  cairo_surface_destroy(surface);
end.
