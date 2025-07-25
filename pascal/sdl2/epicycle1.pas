
program Epicycle1;

uses
  SysUtils, SDL2, Cairo, Math;

const
  SURFACE_WIDTH  = 640;
  SURFACE_HEIGHT = SURFACE_WIDTH;
  SW2 = SURFACE_WIDTH / 2;
  SH2 = SURFACE_HEIGHT / 2;
  
  RADIUS1 = 240;
  RADIUS2 =  64;
  
var
  LSurface0, LSurface2: pcairo_surface_t;
  LContext2: pcairo_t;

procedure DrawSurface0(s: pcairo_surface_t);
var
  c: pcairo_t;
begin
  c := cairo_create(s);
  
  cairo_set_source_rgb(c, 0.9, 0.9, 0.9);
  cairo_paint(c);
  
  cairo_translate(c, SW2, SH2);
  cairo_set_source_rgb(c, 0.7, 0.7, 0.7);
  cairo_move_to(c, -SW2, 0.0);
  cairo_line_to(c, +SW2, 0.0);
  cairo_stroke(c);
  cairo_move_to(c, 0.0, -SH2);
  cairo_line_to(c, 0.0, +SH2);
  cairo_stroke(c);
  
  cairo_destroy(c);
end;

procedure DrawTexture(const ATexture: pSDL_Texture; const AAngle1, AAngle2: double);
var
  LSurface1: pcairo_surface_t;
  LContext1: pcairo_t;
  LPixels: pointer;
  LPitch: integer;
var
  x, y, x2, y2: double;
const
  RADIUS3 = 1;
begin
  SDL_LockTexture(ATexture, nil, @LPixels, @LPitch);
  
  LSurface1 := cairo_image_surface_create_for_data(LPixels, CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT, LPitch);
  
  LContext1 := cairo_create(LSurface1);
  
  cairo_translate(LContext1, SW2, SH2);
  
  cairo_set_source_surface(LContext1, LSurface0, -SW2, -SH2);
  cairo_paint(LContext1);
  
  cairo_set_source_rgba(LContext1, 0.7, 0.7, 0.7, 0.8);
  
  cairo_arc(LContext1, 0, 0, RADIUS1, 0, 2 * PI);
  cairo_stroke(LContext1);
  
  x := RADIUS1 * Cos(AAngle1);
  y := RADIUS1 * Sin(AAngle1);
  
  cairo_move_to(LContext1, 0.0, 0.0);
  cairo_line_to(LContext1, x, y);
  cairo_stroke(LContext1);
  
  cairo_arc(LContext1, x, y, RADIUS2, 0, 2 * PI);
  cairo_stroke(LContext1);
  
  x2 := RADIUS2 * Cos(AAngle2) + x;
  y2 := RADIUS2 * Sin(AAngle2) + y;
  
  cairo_move_to(LContext1, x, y);
  cairo_line_to(LContext1, x2, y2);
  cairo_stroke(LContext1);
  
  cairo_arc(LContext2, x2, y2, RADIUS3, 0, 2 * PI);
  cairo_fill(LContext2);
  
  cairo_set_source_surface(LContext1, LSurface2, -SW2, -SH2);
  cairo_paint(LContext1);
  
  cairo_destroy(LContext1);
  cairo_surface_destroy(LSurface1);
  
  SDL_UnlockTexture(ATexture);
end;
  
var
  LWindow: pSDL_Window;
  LRenderer: pSDL_Renderer;
  LTexture: pSDL_Texture;
  LEvent: pSDL_Event;
  
  LWindowWidth, LWindowHeight: integer;
  LRendererWidth, LRendererHeight: integer;
  LLoop: boolean = TRUE;
  LAngle1, LAngle2: double;
  
begin
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
    Halt;

  LWindow := SDL_CreateWindow(
    'Epicycle SDL2 Cairo',
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    SURFACE_WIDTH,
    SURFACE_HEIGHT,
    SDL_WINDOW_SHOWN or SDL_WINDOW_ALLOW_HIGHDPI
  );
  if LWindow = nil then
    Halt;
  
  SDL_GetWindowSize(LWindow, @LWindowWidth, @LWindowHeight);
  WriteLn(Format('INFO LWindowWidth=%d LWindowHeight=%d', [LWindowWidth, LWindowHeight]));
  
  LRenderer := SDL_CreateRenderer(LWindow, -1, SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC);
  if LRenderer = nil then
    Halt;
  
  SDL_GetRendererOutputSize(LRenderer, @LRendererWidth, @LRendererHeight);
  WriteLn(Format('INFO LRendererWidth=%d LRendererHeight=%d', [LRendererWidth, LRendererHeight]));
  
  SDL_SetRenderDrawColor(LRenderer, 0, 0, 0, 0);
  SDL_RenderClear(LRenderer);
  
  LTexture := SDL_CreateTexture(LRenderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, LRendererWidth, LRendererHeight);
  
(* -------------------------------------------------------------------------- *)
  LSurface0 := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  DrawSurface0(LSurface0);
  
  LSurface2 := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  LContext2 := cairo_create(LSurface2);
  
  cairo_translate(LContext2, SURFACE_WIDTH / 2, SURFACE_HEIGHT / 2);
  cairo_set_source_rgba(LContext2, 1.0, 0, 0, 0.6);
(* -------------------------------------------------------------------------- *)
  
  New(LEvent);
  
  while LLoop do
  begin
    while SDL_PollEvent(LEvent) = 1 do
      case LEvent^.type_ of
        SDL_KEYDOWN:
          case LEvent^.key.keysym.sym of
            SDLK_ESCAPE, SDLK_q: LLoop := FALSE;
          end;
        SDL_QUITEV:
          LLoop := FALSE;
        SDL_WINDOWEVENT:
          begin
            case LEvent^.window.event of
              SDL_WINDOWEVENT_SHOWN: WriteLn('INFO Window shown');
              SDL_WINDOWEVENT_MOVED: WriteLn('INFO Window moved');
              SDL_WINDOWEVENT_MINIMIZED: WriteLn('INFO Window minimized');
              SDL_WINDOWEVENT_MAXIMIZED: WriteLn('INFO Window maximized');
            end;
          end;
      end;
    
    SDL_SetRenderDrawColor(LRenderer, 0, 0, 0, 255);
    SDL_RenderClear(LRenderer);
    
    LAngle1 := DegToRad((GetTickCount64 / 1000) * 12);
    LAngle2 := LAngle1 * 4;
    
    DrawTexture(LTexture, LAngle1, LAngle2);
    
    SDL_RenderCopy(LRenderer, LTexture, nil, nil);
    SDL_RenderPresent(LRenderer);
    
    SDL_Delay(50);
  end;
  
  Dispose(LEvent);
  
(* -------------------------------------------------------------------------- *)
  cairo_destroy(LContext2);
 {cairo_surface_write_to_png(LSurface2, pchar('image.png'));}
  cairo_surface_destroy(LSurface2);
  cairo_surface_destroy(LSurface0);
(* -------------------------------------------------------------------------- *)
  
  SDL_DestroyTexture(LTexture);
  SDL_DestroyRenderer(LRenderer);
  SDL_DestroyWindow(LWindow);
  SDL_Quit;
end.
