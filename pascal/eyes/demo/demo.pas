
program Demo;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils,
  ptcCrt,
  ptcGraph,
  ptcMouse,
  Color,
{$IFDEF USE_CAIRO}
  Image,
  Cairo,
{$ENDIF}
  Eye;

{$IFDEF USE_CAIRO}
function StaticSurface(const AWidth, AHeight: integer): pcairo_surface_t;
var
  cr: pcairo_t;
  i: integer;
begin
  result := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, AWidth, AHeight);
  cr := cairo_create(result);
  
  cairo_set_source_rgb(cr, 0.2, 0.2, 0.2);
  cairo_paint(cr);
  
  (* Visage *)
  
  cairo_arc(cr, AWidth / 2, AHeight / 2, 4 * RADIUS, 0, 2 * PI);
  cairo_set_source_rgb(cr, rSkin, gSkin, bSkin);
  cairo_fill(cr);
  
  (* Blanc des yeux *)
  
  for i := 0 to 1 do
  begin
    cairo_arc(cr, eyes[i].x, eyes[i].y, eyes[i].radius, 0, 2 * PI);
    cairo_set_source_rgb(cr, 1.0, 1.0, 1.0);
    cairo_fill(cr);
  end;
  
  cairo_destroy(cr);
end;

procedure CairoDraw(var AImage: TImage; const AStatic: pcairo_surface_t; const AMouseX, AMouseY: integer; const AMood: TMood; const ABlink: double);
var
  sf: pcairo_surface_t;
  cr: pcairo_t;
  stride: integer;
  i, w, h: integer;
begin
  w := AImage.Header.Width;
  h := AImage.Header.Height;
  
  stride := cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, w);
  
  sf := cairo_image_surface_create_for_data(@AImage.Data[0], CAIRO_FORMAT_ARGB32, w, h, stride);
  cr := cairo_create(sf);
  
  (* Fond *)
  
  cairo_set_source_surface(cr, AStatic, 0, 0);
  cairo_paint(cr);
  
  (* Yeux *)
  
  for i := 0 to 1 do
  begin
    (* Iris *)
    cairo_arc(cr, eyes[i].dix, eyes[i].diy, eyes[i].irisRadius, 0, 2 * PI);
    with eyes[i].irisColor do cairo_set_source_rgb(cr, r, g, b);
    cairo_fill(cr);
    (* Pupille *)
    cairo_arc(cr, eyes[i].dix, eyes[i].diy, eyes[i].irisRadius * eyes[i].pupilDilation, 0, 2 * PI);
    cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
    cairo_fill(cr);
  end;
  
  (* Clignement *)
  
  cairo_rectangle(cr, w / 2 - SPACE - RADIUS, h / 2 - RADIUS, (RADIUS + SPACE) * 2, RADIUS * 3 * ABlink);
  cairo_set_source_rgb(cr, rSkin, gSkin, bSkin);
  cairo_fill(cr);
  
  (* Bouche *)
  
  cairo_save(cr);
  
  case AMood of
    mHappy:
      begin
        cairo_translate(cr, w / 2, h * 0.58);
        cairo_scale(cr, RADIUS, RADIUS * 1.5);
        cairo_arc(cr, 0.0, 0.0, 1.0, 0, PI);
      end;
    mConcerned:
      begin
        cairo_translate(cr, w / 2, h * 0.62);
        cairo_scale(cr, RADIUS, RADIUS / 2);
        cairo_arc(cr, 0.0, 0.0, 1.0, 0, 2 * PI);
      end;
    mSad:
      begin
        cairo_translate(cr, w / 2, h * 0.65);
        cairo_scale(cr, RADIUS, RADIUS * 1.5);
        cairo_arc(cr, 0.0, 0.0, 1.0, PI, 2 * PI);
      end;
  end;
  
  cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
  cairo_fill(cr);
  cairo_restore(cr);
  
  (* Objet *)
  
  cairo_set_source_rgb(cr, 1, 0, 0);
  cairo_arc(cr, AMouseX, AMouseY, 5, 0, 2 * PI);
  cairo_fill(cr);
  
  cairo_destroy(cr);
  cairo_surface_destroy(sf);
end;
{$ELSE}
procedure Draw(const MouseX, MouseY: integer; const AIrisColor: longword);
const
  CSkinColor = 232 shl 16 or 209 shl 8 or 171;
var
  i: integer;
begin
  ClearDevice;
  
  SetColor(CSkinColor);
  SetFillStyle(SolidFill, CSkinColor);
  FillEllipse(SURFACE_WIDTH div 2, SURFACE_HEIGHT div 2, 4 * RADIUS, 4 * RADIUS);
  
  for i := 0 to 1 do
  begin
    SetColor($FFFFFF);
    SetFillStyle(SolidFill, $FFFFFF);
    FillEllipse(Round(eyes[i].x), Round(eyes[i].y), Round(eyes[i].radius), Round(eyes[i].radius));
    
    SetColor(AIrisColor);
    SetFillStyle(SolidFill, AIrisColor);
    FillEllipse(Round(eyes[i].dix), Round(eyes[i].diy), Round(eyes[i].irisRadius), Round(eyes[i].irisRadius));
    
    SetColor(0);
    SetFillStyle(SolidFill, 0);
    FillEllipse(Round(eyes[i].dix), Round(eyes[i].diy), Round(eyes[i].irisRadius * eyes[i].pupilDilation), Round(eyes[i].irisRadius * eyes[i].pupilDilation));
  end;
  
  SetColor($FF0000);
  SetFillStyle(SolidFill, $FF0000);
  FillEllipse(MouseX, MouseY, 5, 5);
end;
{$ENDIF}

(* ========================================================================== *)
  
var
  LDriver, LMode, LResult: smallint;
{$IFDEF USE_CAIRO}
  LImage: PImage;
  LStatic: pcairo_surface_t;
{$ENDIF}
  MouseX, MouseY, Button: integer;
  LKey: char;
  LExit: boolean;
  LTime, LOldTime: qword;
  //LColor: TColor;
  LIrisColor: longword;
  LMood: TMood;
  LBlink: double;
  LDist: double;
  LPage: integer;
  dt: double;
  i: integer;
  
begin
  Randomize;
  WindowTitle :=
{$IFDEF USE_CAIRO}
    'Eyes ptcGraph & Cairo';
{$ELSE}
    'Eyes ptcGraph';
{$ENDIF}
  LPage := 0;
  LDriver := VESA;
  LMode := m800x600x16m;
  InitGraph(LDriver, LMode, '');
  LResult := GraphResult;
  
  if LResult <> grOK then
  begin
    WriteLn(GraphErrorMsg(LResult));
    Halt;
  end;
  
  SetBkColor($333333);
  LBlink := 0.0;
  
  (* ======================================================================== *)
  
  with eyes[0].irisColor do LIrisColor := Round(255 * r) shl 16 or Round(255 * g) shl 8 or Round(255 * r);
  
  (* ======================================================================== *)
  
{$IFDEF USE_CAIRO}
  LStatic := StaticSurface(SURFACE_WIDTH, SURFACE_HEIGHT);
  LImage := CreateImage(SURFACE_WIDTH, SURFACE_HEIGHT);
{$ENDIF}
  
  MouseX := -1;
  MouseY := -1;
  
  HideMouse;
  
  LExit := FALSE;
  LOldTime := GetTickCount64;
  
  while not LExit do
  begin
    GetMouseState(MouseX, MouseY, Button);
    
    (* Update *)
    
    LTime := GetTickCount64;
    dt := (LTime - LOldTime) / 1000;
    
    LDist := Distance(MouseX, MouseY, SURFACE_WIDTH / 2, SURFACE_HEIGHT / 2);
    
    if LDist > RADIUS * 8 then
      LMood := mHappy else
    if LDist > RADIUS * 4 then
      LMood := mConcerned else
      LMood := mSad;
    
    LBlink := LBlink - LBlink * 16 * dt;
    
    for i := 0 to 1 do
    begin
      eyes[i].Look(MouseX, MouseY);
      eyes[i].Update(dt);
    end;
    
    LOldTime := LTime;
    
    (* Redraw *)
    
{$IFDEF USE_CAIRO}
    CairoDraw(LImage^, LStatic, MouseX, MouseY, LMood, LBlink);
    PutImage(0, 0, LImage^, NormalPut);
{$ELSE}
    SetActivePage(LPage);
    Draw(MouseX, MouseY, LIrisColor);
    SetVisualPage(LPage);
    LPage := 1 - LPage;
{$ENDIF}
    
    (* KeyPressed *)
    
    if KeyPressed then
    begin
      LKey := ReadKey;
      if LKey in [#3, #27, 'q', 'Q'] then
        LExit := TRUE;
      if LKey in ['b', 'B'] then
        LBlink := 1.0;
     {if LKey = #0 then
      begin
        LKey := ReadKey;
        // ...
      end;}
    end;
    
    Delay(40);
  end;
  
  CloseGraph;
  
{$IFDEF USE_CAIRO}
  FreeImage(LImage, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_surface_destroy(LStatic);
{$ENDIF}
  
end.
