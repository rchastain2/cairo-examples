
program Demo;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils,
  ptcCrt,
  ptcGraph,
  ptcMouse,
{$IFDEF USE_CAIRO}
  Image,
  Cairo,
{$ENDIF}
  Eye;

(* ========================================================================== *)

const
  RADIUS = 32;
  SPACE = 50;

var
  eyes: array[0..1] of TEye;

(* ========================================================================== *)

{$IFDEF USE_CAIRO}
function CreateStaticCairoSurface(const AWidth, AHeight: integer): pcairo_surface_t;
var
  cr: pcairo_t;
  i: integer;
begin
  result := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, AWidth, AHeight);
  cr := cairo_create(result);
  
  (* Fond de l'image *)
  
  cairo_set_source_rgb(cr, 0.2, 0.2, 0.2);
  cairo_paint(cr);
  
  (* Visage *)
  
  cairo_arc(cr, AWidth / 2, AHeight / 2, 4 * RADIUS, 0, 2 * PI);
  cairo_set_source_rgb(cr, 232 / 255, 209 / 255, 171 / 255);
  cairo_fill(cr);
  
  (* Blanc des yeux *)
  
  for i := 0 to 1 do
  begin
    cairo_arc(cr, eyes[i].x, eyes[i].y, eyes[i].radius, 0, 2 * PI);
    cairo_set_source_rgb(cr, 1.0, 1.0, 1.0);
    cairo_fill(cr);
  end;
  
  (* Bouche *)
  
  cairo_save(cr);
  cairo_translate(cr, AWidth / 2, AHeight * 0.62);
  cairo_scale(cr, RADIUS, RADIUS / 2);
  cairo_arc(cr, 0.0, 0.0, 1.0, 0, 2 * PI);
  cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
  cairo_fill(cr);
  cairo_restore(cr);
  
  cairo_destroy(cr);
end;

procedure CairoDraw(var AImage: TImage; const AStaticCairoSurface: pcairo_surface_t; const MouseX, MouseY: integer);
var
  sf: pcairo_surface_t;
  cr: pcairo_t;
  sv: integer; // stride value
  i: integer;
begin
  sv := cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, AImage.Header.Width);
  sf := cairo_image_surface_create_for_data(@AImage.Data[0], CAIRO_FORMAT_ARGB32, AImage.Header.Width, AImage.Header.Height, sv);
  cr := cairo_create(sf);
  
  cairo_set_source_surface(cr, AStaticCairoSurface, 0, 0);
  cairo_paint(cr);
  
  for i := 0 to 1 do
  begin
    cairo_arc(cr, eyes[i].dix, eyes[i].diy, eyes[i].irisRadius, 0, 2 * PI);
    with eyes[i].irisColor do cairo_set_source_rgb(cr, r, g, b);
    cairo_fill(cr);
    
    cairo_arc(cr, eyes[i].dix, eyes[i].diy, eyes[i].irisRadius * eyes[i].pupilDilation, 0, 2 * PI);
    cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
    cairo_fill(cr);
  end;
  
  cairo_set_source_rgb(cr, 1, 0, 0);
  cairo_arc(cr, MouseX, MouseY, 5, 0, 2 * PI);
  cairo_fill(cr);
  
  cairo_destroy(cr);
  cairo_surface_destroy(sf);
end;
{$ENDIF}

(* ========================================================================== *)

const
  SURFACE_WIDTH = 800;
  SURFACE_HEIGHT = 600;
  
  CSkinColor = 232 shl 16 or 209 shl 8 or 171;
  
var
  LDriver, LMode, LResult: smallint;
{$IFDEF USE_CAIRO}
  LImage: PImage;
  LStaticCairoSurface: pcairo_surface_t;
{$ENDIF}
  MouseX, MouseY, Button: integer;
  LKey: char;
  LExit: boolean;
  LTime, LOldTime: qword;
  LColor: TColor;
  LIrisColor: longword;
  LPage: integer;
  i: integer;
  
begin
  Randomize;
  WindowTitle := 'Eyes';
  LPage := 0;
  LDriver := VESA;
  LMode := m800x600x16m;
  InitGraph(LDriver, LMode, '');
  LResult := GraphResult;
  
  if LResult <> grOK then
  begin
    Halt;
  end;
  
  SetBkColor($333333);
  ClearDevice;
  
  (* ======================================================================== *)
  
  LColor := RandomColor;
  eyes[0] := TEye.Create(SURFACE_WIDTH div 2 - SPACE, SURFACE_HEIGHT div 2, RADIUS, RADIUS div 2, LColor, 0.4);
  eyes[1] := TEye.Create(SURFACE_WIDTH div 2 + SPACE, SURFACE_HEIGHT div 2, RADIUS, RADIUS div 2, LColor, 0.4);
  
  (* ======================================================================== *)
  
{$IFDEF USE_CAIRO}
  LStaticCairoSurface := CreateStaticCairoSurface(SURFACE_WIDTH, SURFACE_HEIGHT);
  LImage := CreateImage(SURFACE_WIDTH, SURFACE_HEIGHT);
{$ENDIF}
  
  MouseX := -1;
  MouseY := -1;
  
  HideMouse;
  
  LExit := FALSE;
  LOldTime := GetTickCount64;
  with eyes[0].irisColor do LIrisColor := Round(255 * r) shl 16 or Round(255 * g) shl 8 or Round(255 * r); 
  
  while not LExit do
  begin
    GetMouseState(MouseX, MouseY, Button);
    
    (* Update *)
    
    LTime := GetTickCount64;
    for i := 0 to 1 do
    begin
      eyes[i].Look(MouseX, MouseY);
      eyes[i].Update((LTime - LOldTime) / 1000);
    end;
    LOldTime := LTime;
    
    (* Redraw *)
    
{$IFDEF USE_CAIRO}
    CairoDraw(LImage^, LStaticCairoSurface, MouseX, MouseY);
    PutImage(0, 0, LImage^, NormalPut);
{$ELSE}
    SetActivePage(LPage);
    ClearDevice;
    
    SetColor(CSkinColor);
    SetFillStyle(SolidFill, CSkinColor);
    FillEllipse(SURFACE_WIDTH div 2, SURFACE_HEIGHT div 2, 4 * RADIUS, 4 * RADIUS);
    
    for i := 0 to 1 do
    begin
      SetColor($FFFFFF);
      SetFillStyle(SolidFill, $FFFFFF);
      FillEllipse(Round(eyes[i].x), Round(eyes[i].y), Round(eyes[i].radius), Round(eyes[i].radius));
      
      SetColor(LIrisColor);
      SetFillStyle(SolidFill, LIrisColor);
      FillEllipse(Round(eyes[i].dix), Round(eyes[i].diy), Round(eyes[i].irisRadius), Round(eyes[i].irisRadius));
      
      SetColor(0);
      SetFillStyle(SolidFill, 0);
      FillEllipse(Round(eyes[i].dix), Round(eyes[i].diy), Round(eyes[i].irisRadius * eyes[i].pupilDilation), Round(eyes[i].irisRadius * eyes[i].pupilDilation));
    end;
    
    SetColor($FF0000);
    SetFillStyle(SolidFill, $FF0000);
    FillEllipse(MouseX, MouseY, 5, 5);
    
    SetVisualPage(LPage);
    LPage := 1 - LPage;
{$ENDIF}
    
    (* KeyPressed *)
    
    if KeyPressed then
    begin
      LKey := ReadKey;
      
      if LKey in [#3, #27, 'q', 'Q'] then
        LExit := TRUE;
      
      if LKey = #0 then
      begin
        LKey := ReadKey;
      end;
    end;
    
    Delay(40);
  end;
  
  CloseGraph;
  
{$IFDEF USE_CAIRO}
  FreeImage(LImage, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_surface_destroy(LStaticCairoSurface);
{$ENDIF}
  
  (* ======================================================================== *)
  
  for i := 0 to 1 do
  begin
    eyes[i].Free;
  end;
  
  (* ======================================================================== *)
end.
