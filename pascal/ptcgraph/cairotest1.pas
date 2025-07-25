
program CairoTest;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt, ptcGraph, Cairo;

const
  IMAGE_WIDTH  = 800;
  IMAGE_HEIGHT = 600;
  COLOR_WIDTH  =   4;

type
  TImage = packed record
    width, height, reserved: longint;
    data: array[0..IMAGE_WIDTH * IMAGE_HEIGHT * COLOR_WIDTH - 1] of byte;
  end;
  
var 
  gd, gm, err: smallint;
  surface: pcairo_surface_t;
  context: pcairo_t;
  image: TImage;
  stride: integer;
  
begin
  image.width := IMAGE_WIDTH;
  image.height := IMAGE_HEIGHT;
  
  stride := cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, IMAGE_WIDTH);
  surface := cairo_image_surface_create_for_data(image.data, CAIRO_FORMAT_ARGB32, IMAGE_WIDTH, IMAGE_HEIGHT, stride);
  context := cairo_create(surface);
  cairo_set_source_rgb(context, 1.0, 1.0, 0.0);
  cairo_paint(context);
  cairo_scale(context, IMAGE_WIDTH, IMAGE_HEIGHT);
  cairo_set_line_width(context, 0.1);
  cairo_arc_negative(context, 0.5, 0.5, 0.4, PI / 2, 3 * PI / 2);
  cairo_set_source_rgb(context, 0.0, 1.0, 0.0);
  cairo_stroke(context);
  cairo_destroy(context);
  cairo_surface_write_to_png(surface, pchar('image.png'));
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
