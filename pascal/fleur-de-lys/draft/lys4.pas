
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
  cairo_line_to(context, 44.94, 198.13);
  cairo_line_to(context, 6.81, 217.74);
  cairo_line_to(context, 6.94, 261.64);
  cairo_line_to(context, 7.69, 311.78);
  cairo_line_to(context, 52.46, 335.25);
  cairo_line_to(context, 88.90, 299.42);
  cairo_line_to(context, 75.40, 299.44);
  cairo_line_to(context, 69.02, 291.82);
  cairo_line_to(context, 68.94, 279.00);
  cairo_line_to(context, 68.85, 266.96);
  cairo_line_to(context, 79.11, 249.17);
  cairo_line_to(context, 97.56, 249.25);
  cairo_line_to(context, 133.72, 249.42);
  cairo_line_to(context, 168.43, 284.61);
  cairo_line_to(context, 168.31, 323.63);
  cairo_line_to(context, 168.26, 343.07);
  cairo_line_to(context, 164.23, 369.57);
  cairo_line_to(context, 141.56, 370.01);
  cairo_line_to(context, 130.80, 370.22);
  cairo_line_to(context, 114.74, 366.55);
  cairo_line_to(context, 106.81, 353.63);
  cairo_line_to(context, 97.21, 381.05);
  cairo_line_to(context, 115.38, 399.77);
  cairo_line_to(context, 140.31, 399.51);
  cairo_line_to(context, 173.47, 399.15);
  cairo_line_to(context, 195.11, 363.85);
  cairo_line_to(context, 195.43, 323.51);
  cairo_line_to(context, 195.93, 261.72);
  cairo_line_to(context, 136.63, 198.14);
  cairo_line_to(context, 79.69, 198.14);
  cairo_close_path(context);
  
  cairo_move_to(context, 360.31, 198.14);
  cairo_line_to(context, 395.06, 198.13);
  cairo_line_to(context, 433.19, 217.74);
  cairo_line_to(context, 433.06, 261.64);
  cairo_line_to(context, 432.31, 311.78);
  cairo_line_to(context, 387.55, 335.25);
  cairo_line_to(context, 351.10, 299.42);
  cairo_line_to(context, 364.60, 299.44);
  cairo_line_to(context, 370.98, 291.82);
  cairo_line_to(context, 371.06, 279.00);
  cairo_line_to(context, 371.15, 266.96);
  cairo_line_to(context, 360.89, 249.17);
  cairo_line_to(context, 342.44, 249.25);
  cairo_line_to(context, 306.28, 249.42);
  cairo_line_to(context, 271.57, 284.61);
  cairo_line_to(context, 271.69, 323.63);
  cairo_line_to(context, 271.74, 343.07);
  cairo_line_to(context, 275.77, 369.57);
  cairo_line_to(context, 298.44, 370.01);
  cairo_line_to(context, 309.20, 370.22);
  cairo_line_to(context, 325.26, 366.55);
  cairo_line_to(context, 333.19, 353.63);
  cairo_line_to(context, 342.79, 381.05);
  cairo_line_to(context, 324.62, 399.77);
  cairo_line_to(context, 299.69, 399.51);
  cairo_line_to(context, 266.53, 399.15);
  cairo_line_to(context, 244.89, 363.85);
  cairo_line_to(context, 244.57, 323.51);
  cairo_line_to(context, 244.06, 261.72);
  cairo_line_to(context, 303.37, 198.14);
  cairo_line_to(context, 360.31, 198.14);
  cairo_close_path(context);
  
  cairo_move_to(context, 220.00, 9.29);
  cairo_line_to(context, 187.19, 35.66);
  cairo_line_to(context, 142.47, 78.12);
  cairo_line_to(context, 142.83, 114.61);
  cairo_line_to(context, 143.55, 187.36);
  cairo_line_to(context, 203.74, 262.31);
  cairo_line_to(context, 203.16, 307.75);
  cairo_line_to(context, 202.46, 363.25);
  cairo_line_to(context, 187.19, 403.80);
  cairo_line_to(context, 152.98, 404.02);
  cairo_line_to(context, 187.19, 422.60);
  cairo_line_to(context, 187.19, 422.60);
  cairo_line_to(context, 220.00, 470.71);
  cairo_line_to(context, 250.16, 422.60);
  cairo_line_to(context, 250.16, 422.60);
  cairo_line_to(context, 285.57, 405.47);
  cairo_line_to(context, 250.16, 403.78);
  cairo_line_to(context, 236.60, 363.38);
  cairo_line_to(context, 236.11, 307.02);
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
  cairo_line_to(context, 147.51, 311.47);
  cairo_line_to(context, 146.04, 333.28);
  cairo_line_to(context, 160.26, 333.29);
  cairo_line_to(context, 221.00, 332.94);
  cairo_line_to(context, 221.00, 332.97);
  cairo_line_to(context, 279.06, 333.29);
  cairo_line_to(context, 294.32, 333.68);
  cairo_line_to(context, 292.54, 311.47);
  cairo_line_to(context, 279.06, 312.20);
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
