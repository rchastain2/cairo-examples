
program CairoTest;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils,
  ptcCrt,
  ptcGraph,
  Cairo;

const
  COLOR_WIDTH = 4;

type
  THeader = packed record
    Width, Height, Reserved: longint;
  end;
 
  TImage = packed record
    Header: THeader;
    Data: array[0..0] of byte;
  end;
  
  PImage = ^TImage;

function CreateImage(const AWidth, AHeight: integer): PImage;
begin
  result := PImage(GetMem(SizeOf(THeader) + COLOR_WIDTH * AWidth * AHeight));
  result^.Header.Width  := AWidth;
  result^.Header.Height := AHeight;
end;

procedure FreeImage(const AImage: PImage; const AWidth, AHeight: integer);
begin
  FreeMem(AImage, SizeOf(THeader) + COLOR_WIDTH * AWidth * AHeight);
end;

var
  fe: cairo_font_extents_t;

procedure InitFonts(surf: pcairo_t; fonttype: pchar);
begin
  cairo_select_font_face(surf, fonttype, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);
  cairo_font_extents(surf, @fe);
end;

procedure Print(surf: pcairo_t; x, y: single; text: pchar; size, rd, gr, bl: single);
var
  te: cairo_text_extents_t;
begin
  cairo_set_font_size(surf, size);
  cairo_text_extents(surf, text, @te);
  cairo_move_to(surf, x - te.width / 2 + te.x_bearing, y + te.height / 2 - fe.descent);
  cairo_set_source_rgb(surf, rd, gr, bl);
  cairo_show_text(surf, text);
  cairo_stroke(surf);
end;

procedure CairoDraw(var AImage: TImage);
var
  sfc: pcairo_surface_t;
  ctx: pcairo_t;
  str: integer;
begin
  str := cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, AImage.Header.Width);
  sfc := cairo_image_surface_create_for_data(@AImage.Data[0], CAIRO_FORMAT_ARGB32, AImage.Header.Width, AImage.Header.Height, str);
  ctx := cairo_create(sfc);
  cairo_set_source_rgb(ctx, 1.0, 1.0, 0.0);
  cairo_paint(ctx);

  InitFonts(ctx, {$IFDEF windows}'Georgia'{$ELSE}'Cantarell'{$ENDIF});
  Print(ctx, 200, 50, 'Hello', 35, 0, 0.5, 1);
  Print(ctx, 200, 150, 'Press any key to quit!', 20, 1, 0, 0);

  cairo_scale(ctx, AImage.Header.Width, AImage.Header.Height);
  cairo_set_line_width(ctx, 0.1);
  cairo_arc_negative(ctx, 0.5, 0.5, 0.4, PI / 2, 3 * PI / 2);
  cairo_set_source_rgb(ctx, 0.0, 1.0, 0.0);
  cairo_stroke(ctx);
  cairo_destroy(ctx);
  //cairo_surface_write_to_png(sfc, pchar('image.png'));
  cairo_surface_destroy(sfc);
end;

var
  gd, gm, err: smallint;
  img: PImage;
  iw, ih: integer;
  
begin
  WindowTitle := 'How to draw with Cairo in a ptcGraph window';
  //FullScreenGraph := TRUE;
  DetectGraph(gd, gm);
  InitGraph(gd, gm, '');
  err := GraphResult;
  
  if err = grOK then
  begin
    iw := Succ(GetMaxX);
    ih := Succ(GetMaxY);
    img := CreateImage(iw, ih);
    CairoDraw(img^);
    PutImage(0, 0, img^, NormalPut);
    ReadKey;
    CloseGraph;
    FreeImage(img, iw, ih);
  end;
end.
