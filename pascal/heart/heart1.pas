
{ https://www.dil.univ-mrs.fr/~regis/CM-CAIRO/ }

uses
  SysUtils, Math, Cairo;

{
  Voici comment dessiner un cœur avec 4 cubiques de Bézier.
  Dans MakeHeart(), on se contente de tracer le chemin dans le masque.
  Différentes procédures exploitent ensuite ce chemin pour obtenir des résultats différents.
  Le cœur est paramétré par la position de son centre (x, y), un pseudo-rayon r, et un écart horizontal d contrôlant son creux et sa pointe.
}

procedure MakeHeart(c: pcairo_t; x, y, r, d: double);
var
  y1, y2, y3, y4, x1, x2, x3, x4: double;
begin
  y1 := y - r;
  y2 := y - r / 3;
  y3 := y + r / 3;
  y4 := y + r;
  x1 := x - r;
  x2 := x - d;
  x3 := x + d;
  x4 := x + r;
  cairo_move_to (c, x,  y4);
  cairo_curve_to(c, x2, y3, x1, y3, x1, y2);
  cairo_curve_to(c, x1, y1, x2, y1, x,  y2);
  cairo_curve_to(c, x3, y1, x4, y1, x4, y2);
  cairo_curve_to(c, x4, y3, x3, y3, x,  y4);
end;

const
  SURFACE_WIDTH = 128;
  SURFACE_HEIGHT = 128;
  
var
  context: pcairo_t;
  surface: pcairo_surface_t;
  dw, dh: integer;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  dw := SURFACE_WIDTH;
  dh := SURFACE_HEIGHT;
  
  MakeHeart(context, dw / 2, dh / 2, Min(dw, dh) / 3, 0);
{
  La première procédure exploite le chemin avec un simple fill sur une source de couleur rouge mi-transparente.
}
  cairo_set_source_rgba(context, 1.0, 0.0, 0.0, 1.0);
  cairo_fill(context);
  
  cairo_surface_write_to_png(surface, pchar(ChangeFileExt({$I %FILE%}, '.png')));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
