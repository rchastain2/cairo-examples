
uses
  SysUtils, Cairo;

const
  W = 4 * 120;
  H = 4 * 120;

var
  context: pcairo_t;
  surface: pcairo_surface_t;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, W, H);
  context := cairo_create(surface);
  {
  cairo_set_source_rgb(context, 1.0, 1.0, 1.0);
  cairo_paint(context);
  }
  cairo_set_line_cap(context, CAIRO_LINE_CAP_ROUND);
  cairo_set_line_join(context, CAIRO_LINE_JOIN_ROUND);
  cairo_set_line_width(context, 1.0);
  
  cairo_translate (context, 20, 0);
  
  cairo_move_to(context, 79.69, 198.14);
  cairo_rel_line_to(context, -34.74, 0.00);
  cairo_rel_line_to(context, -38.14, 19.61);
  cairo_rel_line_to(context, 0.13, 43.89);
  cairo_rel_line_to(context, 0.76, 50.14);
  cairo_rel_line_to(context, 44.76, 23.47);
  cairo_rel_line_to(context, 36.44, -35.83);
  cairo_rel_line_to(context, -13.50, 0.02);
  cairo_rel_line_to(context, -6.38, -7.61);
  cairo_rel_line_to(context, -0.08, -12.82);
  cairo_rel_line_to(context, -0.08, -12.05);
  cairo_rel_line_to(context, 10.26, -17.79);
  cairo_rel_line_to(context, 18.45, 0.08);
  cairo_rel_line_to(context, 36.16, 0.17);
  cairo_rel_line_to(context, 34.70, 35.19);
  cairo_rel_line_to(context, -0.12, 39.02);
  cairo_rel_line_to(context, -0.06, 19.44);
  cairo_rel_line_to(context, -4.03, 26.50);
  cairo_rel_line_to(context, -22.67, 0.44);
  cairo_rel_line_to(context, -10.76, 0.21);
  cairo_rel_line_to(context, -16.06, -3.67);
  cairo_rel_line_to(context, -7.93, -12.92);
  cairo_rel_line_to(context, -9.60, 27.42);
  cairo_rel_line_to(context, 18.17, 18.72);
  cairo_rel_line_to(context, 24.93, -0.26);
  cairo_rel_line_to(context, 33.16, -0.36);
  cairo_rel_line_to(context, 21.64, -35.30);
  cairo_rel_line_to(context, 0.32, -40.34);
  cairo_line_to(context, 195.93, 261.72);
  cairo_line_to(context, 136.63, 198.14);
  cairo_line_to(context, 79.69, 198.14);
  cairo_close_path(context);
  
  cairo_move_to(context, 360.31, 198.14);
  cairo_rel_line_to(context, 34.74, 0.00);
  cairo_rel_line_to(context, 38.13, 19.61);
  cairo_rel_line_to(context, -0.12, 43.89);
  cairo_rel_line_to(context, -0.76, 50.14);
  cairo_rel_line_to(context, -44.76, 23.47);
  cairo_rel_line_to(context, -36.44, -35.83);
  cairo_rel_line_to(context, 13.50, 0.02);
  cairo_rel_line_to(context, 6.38, -7.61);
  cairo_rel_line_to(context, 0.08, -12.82);
  cairo_rel_line_to(context, 0.08, -12.05);
  cairo_rel_line_to(context, -10.26, -17.79);
  cairo_rel_line_to(context, -18.45, 0.08);
  cairo_rel_line_to(context, -36.16, 0.17);
  cairo_rel_line_to(context, -34.70, 35.19);
  cairo_rel_line_to(context, 0.12, 39.02);
  cairo_rel_line_to(context, 0.06, 19.44);
  cairo_rel_line_to(context, 4.03, 26.50);
  cairo_rel_line_to(context, 22.67, 0.44);
  cairo_rel_line_to(context, 10.76, 0.21);
  cairo_rel_line_to(context, 16.06, -3.67);
  cairo_rel_line_to(context, 7.93, -12.92);
  cairo_rel_line_to(context, 9.60, 27.42);
  cairo_rel_line_to(context, -18.16, 18.72);
  cairo_rel_line_to(context, -24.93, -0.26);
  cairo_rel_line_to(context, -33.16, -0.36);
  cairo_rel_line_to(context, -21.64, -35.30);
  cairo_rel_line_to(context, -0.32, -40.34);
  cairo_line_to(context, 244.06, 261.72);
  cairo_line_to(context, 303.37, 198.14);
  cairo_line_to(context, 360.31, 198.14);
  cairo_close_path(context);
  
  cairo_move_to(context, 220.00, 9.29);
  cairo_rel_line_to(context, -32.81, 26.37);
  cairo_rel_line_to(context, -44.72, 42.46);
  cairo_rel_line_to(context, 0.36, 36.49);
  cairo_rel_line_to(context, 0.72, 72.75);
  cairo_rel_line_to(context, 60.20, 74.95);
  cairo_rel_line_to(context, -0.58, 45.44);
  cairo_rel_line_to(context, -0.70, 55.50);
  cairo_rel_line_to(context, -15.28, 40.56);
  cairo_rel_line_to(context, -34.21, 0.21);
  cairo_rel_line_to(context, 34.21, 18.58);
  cairo_rel_line_to(context, 0.00, 0.00);
  cairo_rel_line_to(context, 32.81, 48.11);
  cairo_rel_line_to(context, 30.16, -48.11);
  cairo_rel_line_to(context, 0.00, 0.00);
  cairo_rel_line_to(context, 35.41, -17.13);
  cairo_rel_line_to(context, -35.41, -1.68);
  cairo_rel_line_to(context, -13.56, -40.40);
  cairo_rel_line_to(context, -0.48, -56.36);
  cairo_line_to(context, 235.72, 261.68);
  cairo_line_to(context, 297.73, 187.36);
  cairo_line_to(context, 297.17, 114.61);
  cairo_line_to(context, 296.89, 78.05);
  cairo_line_to(context, 250.16, 35.36);
  cairo_line_to(context, 220.00, 9.29);
  cairo_close_path(context);
  
  cairo_set_source_rgb(context, 0.8, 0.8, 0.8);
  cairo_fill_preserve(context);
  cairo_set_source_rgb(context, 0.4, 0.4, 0.4);
  cairo_stroke(context);
  
  cairo_move_to(context, 160.26, 312.20);
  cairo_rel_line_to(context, -12.75, -0.73);
  cairo_rel_line_to(context, -1.46, 21.81);
  cairo_rel_line_to(context, 14.22, 0.01);
  cairo_rel_line_to(context, 60.74, -0.35);
  cairo_rel_line_to(context, 0.00, 0.04);
  cairo_rel_line_to(context, 58.06, 0.32);
  cairo_rel_line_to(context, 15.26, 0.39);
  cairo_rel_line_to(context, -1.78, -22.21);
  cairo_rel_line_to(context, -13.48, 0.73);
  cairo_line_to(context, 221.00, 311.47);
  cairo_line_to(context, 221.00, 311.47);
  cairo_line_to(context, 160.26, 312.20);
  cairo_close_path(context);
  
  cairo_set_source_rgb(context, 0.8, 0.8, 0.8);
  cairo_fill_preserve(context);
  cairo_set_source_rgb(context, 0.4, 0.4, 0.4);
  cairo_stroke(context);
  
  cairo_surface_write_to_png(surface, pchar(ChangeFileExt({$I %FILE%}, '.png')));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
