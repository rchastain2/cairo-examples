
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
procedure Draw(var AImage: TImage; const AStatic: pcairo_surface_t; const AMouseX, AMouseY: integer; const AMood: TMood; const ABlink: double);
var
  sf: pcairo_surface_t;
  cr: pcairo_t;
  stride: integer;
  i: integer;
begin
  stride := cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, AImage.Header.Width);
  
  sf := cairo_image_surface_create_for_data(@AImage.Data[0], CAIRO_FORMAT_ARGB32, AImage.Header.Width, AImage.Header.Height, stride);
  cr := cairo_create(sf);
  
  Draw_(cr, AStatic, AMouseX, AMouseY, AMood, ABlink);
  
  cairo_destroy(cr);
  cairo_surface_destroy(sf);
end;
{$ELSE}
procedure Draw(const MouseX, MouseY: integer; const AIrisColor: longword; const AMood: TMood; const ABlink: double);
const
  CSkinColor = 232 shl 16 or 209 shl 8 or 171;
var
  i: integer;
begin
  ClearDevice;
  
  (* Visage *)
  
  SetColor(CSkinColor);
  SetFillStyle(SolidFill, CSkinColor);
  FillEllipse(SURFACE_WIDTH div 2, SURFACE_HEIGHT div 2, 4 * RADIUS, 4 * RADIUS);
  
  (* Yeux *)
  
  for i := 0 to 1 do
  begin
    (* Blanc *)
    SetColor($FFFFFF);
    SetFillStyle(SolidFill, $FFFFFF);
    FillEllipse(Round(eyes[i].x), Round(eyes[i].y), Round(eyes[i].radius), Round(eyes[i].radius));
    
    (* Iris *)
    SetColor(AIrisColor);
    SetFillStyle(SolidFill, AIrisColor);
    FillEllipse(Round(eyes[i].dix), Round(eyes[i].diy), Round(eyes[i].irisRadius), Round(eyes[i].irisRadius));
    
    (* Pupille *)
    SetColor(0);
    SetFillStyle(SolidFill, 0);
    FillEllipse(Round(eyes[i].dix), Round(eyes[i].diy), Round(eyes[i].irisRadius * eyes[i].pupilDilation), Round(eyes[i].irisRadius * eyes[i].pupilDilation));
  end;
  
  (* Clignement *)
  
  SetFillStyle(SolidFill, CSkinColor);
  Bar(SURFACE_WIDTH div 2 - SPACE - RADIUS, SURFACE_HEIGHT div 2 - RADIUS, SURFACE_WIDTH div 2 + RADIUS + SPACE, SURFACE_HEIGHT div 2 - RADIUS + Round(RADIUS * 3 * ABlink));
  
  (* Bouche *)
  
  SetColor($000000);
  SetFillStyle(SolidFill, $000000);
  case AMood of
    mHappy:
      Sector(SURFACE_WIDTH div 2, Round(SURFACE_HEIGHT * 0.58), 180, 360, Round(RADIUS * 1.5), Round(RADIUS * 1.5));
    mConcerned:
      Sector(SURFACE_WIDTH div 2, Round(SURFACE_HEIGHT * 0.62), 0, 360, RADIUS, RADIUS div 2);
    mSad:
      Sector(SURFACE_WIDTH div 2, Round(SURFACE_HEIGHT * 0.65), 0, 180, Round(RADIUS * 1.5), Round(RADIUS * 1.5));
  end;
  
  (* Objet *)
  
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
{$IFNDEF USE_CAIRO}
  LIrisColor: longword;
{$ENDIF}
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
  
{$IFNDEF USE_CAIRO}
  with eyes[0].irisColor do LIrisColor := Round(255 * r) shl 16 or Round(255 * g) shl 8 or Round(255 * r);
{$ENDIF}
  
{$IFDEF USE_CAIRO}
  LStatic := StaticSurface;
  LImage  := CreateImage(SURFACE_WIDTH, SURFACE_HEIGHT);
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
    Draw(LImage^, LStatic, MouseX, MouseY, LMood, LBlink);
    PutImage(0, 0, LImage^, NormalPut);
{$ELSE}
    SetActivePage(LPage);
    Draw(MouseX, MouseY, LIrisColor, LMood, LBlink);
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
 {FreeImage(LImage, SURFACE_WIDTH, SURFACE_HEIGHT);}
  FreeImage(LImage);
  cairo_surface_destroy(LStatic);
{$ENDIF}
end.
