
uses
  SysUtils, Cairo;

const
  W = 110;
  H = 120;

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
  
  cairo_move_to(context, 19.922, 49.534);
  cairo_rel_curve_to(context, -8.686, -0.001, -18.22, 4.902, -18.188, 15.875);
  cairo_rel_curve_to(context, 0.189, 12.536, 11.38, 18.403, 20.49, 9.446);
  cairo_rel_curve_to(context, -3.374, 0.004, -4.97, -1.899, -4.99, -5.104);
  cairo_rel_curve_to(context, -0.021, -3.012, 2.543, -7.459, 7.156, -7.438);
  cairo_rel_curve_to(context, 9.041, 0.042, 17.717, 8.839, 17.688, 18.595);
  cairo_rel_curve_to(context, -0.014, 4.859, -1.021, 11.484, -6.688, 11.594);
  cairo_rel_curve_to(context, -2.69, 0.053, -6.705, -0.865, -8.688, -4.094);
  cairo_rel_curve_to(context, -2.4, 6.855, 2.143, 11.535, 8.375, 11.469);
  cairo_rel_curve_to(context, 8.291, -0.089, 13.7, -8.915, 13.781, -19);
  cairo_curve_to(context, 48.983, 65.43, 34.158, 49.536, 19.922, 49.534);
  cairo_close_path(context);
  
  cairo_move_to(context, 90.078, 49.534);
  cairo_rel_curve_to(context, 8.686, -0.001, 18.219, 4.902, 18.188, 15.875);
  cairo_rel_curve_to(context, -0.189, 12.536, -11.379, 18.403, -20.49, 9.446);
  cairo_rel_curve_to(context, 3.375, 0.004, 4.97, -1.899, 4.99, -5.104);
  cairo_rel_curve_to(context, 0.021, -3.012, -2.543, -7.459, -7.156, -7.438);
  cairo_rel_curve_to(context, -9.041, 0.042, -17.717, 8.839, -17.688, 18.595);
  cairo_rel_curve_to(context, 0.014, 4.859, 1.021, 11.484, 6.688, 11.594);
  cairo_rel_curve_to(context, 2.69, 0.053, 6.705, -0.865, 8.688, -4.094);
  cairo_rel_curve_to(context, 2.399, 6.855, -2.142, 11.535, -8.375, 11.469);
  cairo_rel_curve_to(context, -8.291, -0.089, -13.7, -8.915, -13.78, -19);
  cairo_curve_to(context, 61.016, 65.43, 75.842, 49.536, 90.078, 49.534);
  cairo_close_path(context);
  
  cairo_move_to(context, 55, 2.322);
  cairo_rel_curve_to(context, -8.203, 6.593, -19.383, 17.207, -19.293, 26.33);
  cairo_rel_curve_to(context, 0.18, 18.188, 15.229, 36.926, 15.084, 48.285);
  cairo_rel_curve_to(context, -0.175, 13.875, -3.994, 24.014, -12.546, 24.067);
  cairo_rel_curve_to(context, 8.552, 4.646, 8.552, 4.646, 16.755, 16.673);
  cairo_rel_curve_to(context, 7.54, -12.027, 7.54, -12.027, 16.393, -16.31);
  cairo_rel_curve_to(context, -8.853, -0.421, -12.244, -10.522, -12.365, -24.612);
  cairo_curve_to(context, 58.93, 65.419, 74.432, 46.84, 74.293, 28.652);
  cairo_curve_to(context, 74.223, 19.512, 62.54, 8.839, 55, 2.322);
  cairo_close_path(context);
  
  cairo_set_source_rgb(context, 0.8, 0.8, 0.8);
  cairo_fill_preserve(context);
  cairo_set_source_rgb(context, 0.4, 0.4, 0.4);
  cairo_stroke(context);
  
  cairo_move_to(context, 40.065, 78.05);
  cairo_rel_curve_to(context, -3.188, -0.183, -3.554, 5.269, 0, 5.272);
  cairo_rel_curve_to(context, 15.185, -0.088, 15.185, -0.079, 29.7, 0);
  cairo_rel_curve_to(context, 3.816, 0.098, 3.371, -5.455, 0, -5.272);
  cairo_curve_to(context, 55.25, 77.867, 55.25, 77.867, 40.065, 78.05);
  cairo_close_path(context);
  
  cairo_set_source_rgb(context, 0.8, 0.8, 0.8);
  cairo_fill_preserve(context);
  cairo_set_source_rgb(context, 0.4, 0.4, 0.4);
  cairo_stroke(context);
  
  cairo_surface_write_to_png(surface, pchar(ChangeFileExt({$I %FILE%}, '.png')));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
