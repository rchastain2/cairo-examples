
uses
  SysUtils, Cairo;

const
  SURF_W = 400;
  SURF_H = SURF_W;

const
  R1 = 0.37;
  R2 = 0.47;
  R3 = 0.72;
  R4 = 0.90;
  R5 = 0.20;
  R6 = 0.32;
  A1 = PI + 1.398977;
  A2 = PI + 1.742615;
  
var 
  ctx: pcairo_t;
  sfc: pcairo_surface_t;
  i: integer;

begin
  sfc := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURF_W, SURF_H);
  ctx := cairo_create(sfc);
  
  cairo_scale(ctx, SURF_W div 2, SURF_H div 2);
  cairo_translate(ctx, 1.0, 1.0);
  
  cairo_set_source_rgb(ctx, 1.0, 1.0, 1.0);
  cairo_paint(ctx);
  
  cairo_set_line_width(ctx, 1 / 300);
  cairo_set_source_rgb(ctx, 0.6, 0.6, 0.6);
  
  cairo_move_to(ctx, -0.95, -0.00);
  cairo_line_to(ctx,  0.95,  0.00);
  cairo_move_to(ctx,  0.00, -0.95);
  cairo_line_to(ctx,  0.00,  0.95);
  
  cairo_move_to(ctx, -0.75, -0.75);
  cairo_line_to(ctx,  0.75,  0.75);
  cairo_move_to(ctx, -0.75,  0.75);
  cairo_line_to(ctx,  0.75, -0.75);
  
  cairo_stroke(ctx);
  
  cairo_arc(ctx, 0.0, 0.0, R1, 0, 2 * PI); cairo_stroke(ctx);
  cairo_arc(ctx, 0.0, 0.0, R2, 0, 2 * PI); cairo_stroke(ctx);
  cairo_arc(ctx, 0.0, 0.0, R3, 0, 2 * PI); cairo_stroke(ctx);
  cairo_arc(ctx, 0.0, 0.0, R4, 0, 2 * PI); cairo_stroke(ctx);
  
  cairo_set_line_width(ctx, 1 / 200);
  cairo_set_source_rgb(ctx, 0.0, 0.0, 0.0);
  
  cairo_rotate(ctx, PI / 4);
  
  for i := 1 to 4 do
  begin
    cairo_arc(ctx, 0.0, R1, R5, 0, 2 * PI); cairo_stroke(ctx);
    cairo_rotate(ctx, PI / 2);
  end;
  
  for i := 1 to 4 do
  begin
    cairo_arc(ctx, 0.0, R1, R6, A1, A2); cairo_stroke(ctx);
    cairo_rotate(ctx, PI / 2);
  end;
  
  cairo_surface_write_to_png(sfc, pchar('image.png'));
  
  cairo_destroy(ctx);
  cairo_surface_destroy(sfc);
end.
