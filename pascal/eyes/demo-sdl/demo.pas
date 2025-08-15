
program DemoSDL;

uses
  SysUtils,
  SDL2,
{$IFDEF USE_CAIRO}
  Cairo,
{$ELSE}
  SDL2_gfx,
{$ENDIF}
  Eye,
  Color;

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

procedure CairoDraw(const ATexture: pSDL_Texture; const AStatic: pcairo_surface_t; const AWidth, AHeight, AMouseX, AMouseY: integer; const AMood: TMood; const ABlink: double);
var
  sf: pcairo_surface_t;
  cr: pcairo_t;
  LPixels: pointer;
  LPitch: integer;
  i, w, h: integer;
begin
  w := AWidth;
  h := AHeight;
  
  SDL_LockTexture(ATexture, nil, @LPixels, @LPitch);
  
  sf := cairo_image_surface_create_for_data(LPixels, CAIRO_FORMAT_ARGB32, AWidth, AHeight, LPitch);
  
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
  
  SDL_UnlockTexture(ATexture);
end;
{$ELSE}
procedure Draw(const ARenderer: pSDL_Renderer; const AMouseX, AMouseY: integer);
begin
  SDL_SetRenderDrawColor(ARenderer, 51, 51, 51, 255);
  SDL_RenderClear(ARenderer);
  
  filledCircleRGBA(ARenderer, AMouseX, AMouseY, 3, 255, 0, 0, 255);
  aacircleRGBA(ARenderer, AMouseX, AMouseY, 3, 255, 0, 0, 255);
end;
{$ENDIF}

var
  LWindow: pSDL_Window;
  LRenderer: pSDL_Renderer;
  LTexture: pSDL_Texture;
  LEvent: pSDL_Event;
  
  LWindowWidth, LWindowHeight: integer;
  LRendererWidth, LRendererHeight: integer;
  LLoop: boolean = TRUE;
  
  LMouseX, LMouseY: integer;
{$IFDEF USE_CAIRO}
  LStaticSurface: pcairo_surface_t;
{$ENDIF}
  LMood: TMood;
  LBlink: double;
  LDist: double;
  LTime, LOldTime: qword;
  dt: double;
  i: integer;
  
begin
  LBlink := 0.0;
  
{$IFDEF USE_CAIRO}
  LStaticSurface := StaticSurface(SURFACE_WIDTH, SURFACE_HEIGHT);
{$ENDIF}
  
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
    Halt;
  
  LWindow := SDL_CreateWindow(
{$IFDEF USE_CAIRO}
    'Eyes SDL2 & Cairo',
{$ELSE}
    'Eyes SDL2',
{$ENDIF}
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    SURFACE_WIDTH,
    SURFACE_HEIGHT,
    SDL_WINDOW_SHOWN or SDL_WINDOW_RESIZABLE or SDL_WINDOW_ALLOW_HIGHDPI
  );
  if LWindow = nil then
    Halt;

  SDL_GetWindowSize(LWindow, @LWindowWidth, @LWindowHeight);
  SDL_Log('LWindowWidth %d LWindowHeight %d', [LWindowWidth, LWindowHeight]);
  
  LRenderer := SDL_CreateRenderer(LWindow, -1, SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC);
  if LRenderer = nil then
    Halt;
  
  SDL_GetRendererOutputSize(LRenderer, @LRendererWidth, @LRendererHeight);
  SDL_Log('LRendererWidth %d LRendererHeight %d', [LRendererWidth, LRendererHeight]);
  
  SDL_SetRenderDrawColor(LRenderer, 0, 0, 0, 0);
  SDL_RenderClear(LRenderer);
  
  LTexture := SDL_CreateTexture(LRenderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, LRendererWidth, LRendererHeight);
  
  SDL_ShowCursor(SDL_DISABLE);
  
  New(LEvent);
  
  LOldTime := GetTickCount64;
  
  while LLoop do
  begin
    while SDL_PollEvent(LEvent) = 1 do
      case LEvent^.type_ of
        SDL_KEYDOWN:
          case LEvent^.key.keysym.sym of
            SDLK_ESCAPE, SDLK_q: LLoop := FALSE;
            SDLK_B: LBlink := 1.0;
          end;
        SDL_QUITEV:
          LLoop := FALSE;
        SDL_WINDOWEVENT:
          begin
            case LEvent^.window.event of
              SDL_WINDOWEVENT_SHOWN,
              SDL_WINDOWEVENT_MOVED,
              SDL_WINDOWEVENT_MINIMIZED,
              SDL_WINDOWEVENT_MAXIMIZED: SDL_Log('Event %d', [LEvent^.window.event]);
              SDL_WINDOWEVENT_SIZE_CHANGED,
              SDL_WINDOWEVENT_RESIZED:
              begin
                SDL_Log('Event %s', ['SDL_WINDOWEVENT_RESIZED']);
                SDL_DestroyTexture(LTexture);
                SDL_GetRendererOutputSize(LRenderer, @LRendererWidth, @LRendererHeight);
                LTexture := SDL_CreateTexture(LRenderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, LRendererWidth, LRendererHeight);
              end;
            end;
          end;
      end;
    
    SDL_GetMouseState(@LMouseX, @LMouseY);
    
    LDist := Distance(LMouseX, LMouseY, SURFACE_WIDTH / 2, SURFACE_HEIGHT / 2);
    
    if LDist > RADIUS * 8 then
      LMood := mHappy else
    if LDist > RADIUS * 4 then
      LMood := mConcerned else
      LMood := mSad;
    
    LTime := GetTickCount64;
    dt := (LTime - LOldTime) / 1000;
    
    LBlink := LBlink - LBlink * 16 * dt;
    
    for i := 0 to 1 do
    begin
      eyes[i].Look(LMouseX, LMouseY);
      eyes[i].Update(dt);
    end;
    
    LOldTime := LTime;
    
{$IFDEF USE_CAIRO}
    CairoDraw(LTexture, LStaticSurface, LRendererWidth, LRendererHeight, LMouseX, LMouseY, LMood, LBlink);
    SDL_RenderCopy(LRenderer, LTexture, nil, nil);
{$ELSE}
    Draw(LRenderer, LMouseX, LMouseY);
{$ENDIF}
    
    SDL_RenderPresent(LRenderer);
    
    SDL_Delay(40);
  end;
  
  Dispose(LEvent);
  
  SDL_DestroyTexture(LTexture);
  SDL_DestroyRenderer(LRenderer);
  SDL_DestroyWindow(LWindow);
  SDL_Quit;
  
{$IFDEF USE_CAIRO}
  cairo_surface_destroy(LStaticSurface);
{$ENDIF}
end.
