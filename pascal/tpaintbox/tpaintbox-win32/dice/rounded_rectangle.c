
// https://www.cairographics.org/samples/rounded_rectangle/

/* a custom shape that could be wrapped in a function */
double x         = 25.6,        /* parameters like cairo_rectangle */
       y         = 25.6,
       width         = 204.8,
       height        = 204.8,
       aspect        = 1.0,     /* aspect ratio */
       corner_radius = height / 10.0;   /* and corner curvature radius */

double radius = corner_radius / aspect;
double degrees = M_PI / 180.0;

cairo_new_sub_path (cr);
cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees);
cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees);
cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees);
cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees);
cairo_close_path (cr);

cairo_set_source_rgb (cr, 0.5, 0.5, 1);
cairo_fill_preserve (cr);
cairo_set_source_rgba (cr, 0.5, 0, 0, 0.5);
cairo_set_line_width (cr, 10.0);
cairo_stroke (cr);
