
program CairoTest;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt,
  ptcGraph,
  Cairo;

const
  IMAGE_WIDTH = 800;
  IMAGE_HEIGHT = 600;
  COLOR_WIDTH = 4;

type
  TImage = packed record
    width, height, reserved: longint;
    data: array[0..IMAGE_WIDTH * IMAGE_HEIGHT * COLOR_WIDTH - 1] of byte;
  end;

var
  gd, gm: smallint;
  err: smallint;
  surface: pcairo_surface_t;
  context: pcairo_t;
  image: TImage;
  stride: integer;

  // font stuff------------------
var
  _fonts: cairo_font_extents_t;
  _text: cairo_text_extents_t;

procedure InitFonts(surf: pcairo_t; fonttype: pchar);
begin
  cairo_select_font_face(surf, fonttype, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);
  cairo_font_extents(surf, @_fonts);
end;

procedure print(surf: pcairo_t; x, y: single; text: pchar; size, rd, gr, bl: single);
begin
  cairo_set_font_size(surf, (size));
  cairo_move_to(surf, //                lower left corner of text
    (x) - (_text.width / 2 + _text.x_bearing),
    (y) + (_text.height / 2) - _fonts.descent);
  cairo_set_source_rgb(surf, rd, gr, bl);
  cairo_show_text(surf, text);
  cairo_stroke(surf);
end;
//--------------------------------------

begin
  image.width := IMAGE_WIDTH;
  image.height := IMAGE_HEIGHT;
  stride := cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, IMAGE_WIDTH);
  surface := cairo_image_surface_create_for_data(image.data, CAIRO_FORMAT_ARGB32, IMAGE_WIDTH, IMAGE_HEIGHT, stride);
  context := cairo_create(surface);
  cairo_set_source_rgb(context, 1.0, 1.0, 0.0);
  cairo_paint(context);

  initfonts(context, 'georgia');
  print(context, 50, 50, 'Thank you Roland', 35, 0, 0.5, 1);
  print(context, 50, 150, 'Finally got it running in Geany ide.', 20, 1, 0, 0);

  cairo_scale(context, IMAGE_WIDTH, IMAGE_HEIGHT);
  cairo_set_line_width(context, 0.1);
  cairo_arc_negative(context, 0.5, 0.5, 0.4, PI / 2, 3 * PI / 2);
  cairo_set_source_rgb(context, 0.0, 1.0, 0.0);
  cairo_stroke(context);
  cairo_destroy(context);
  //cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_surface_destroy(surface);

  gd := VESA;
  gm := m800x600x16m;
  InitGraph(gd, gm, '');
  SetBkColor(White);
  err := GraphResult;
  if err = grOK then
  begin
    PutImage(0, 0, image, NormalPut);
    ReadKey;
    CloseGraph;
  end;
end.
