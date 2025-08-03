
program DemoSDL;

uses
  SysUtils,
  SDL2,
{$IFDEF USE_CAIRO}
  Cairo
{$ELSE}
  SDL2_gfx
{$ENDIF}
  ;

{$IFDEF USE_CAIRO}
function CreateStaticCairoSurface(const AWidth, AHeight: integer): pcairo_surface_t;
var
  ctx: pcairo_t;
begin
  result := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, AWidth, AHeight);
  ctx := cairo_create(result);
  cairo_set_source_rgb(ctx, 1.0, 1.0, 1.0);
  cairo_paint(ctx);
  (*
  cairo_scale(ctx, AWidth, AHeight);
  cairo_translate(ctx, 1 / 2, 1 / 2);
  cairo_move_to(ctx, xx, yy)
  cairo_line_to(ctx, xx, yy);
  cairo_set_line_width(ctx, 1 / 300);
  cairo_set_source_rgb(ctx, 1, 0, 0);
  cairo_stroke(ctx);
  *)
  cairo_destroy(ctx);
end;

procedure CairoDraw(const ATexture: pSDL_Texture; const ABackground: pcairo_surface_t; const AWidth, AHeight, AMouseX, AMouseY: integer);
var
  LSurface: pcairo_surface_t;
  LContext: pcairo_t;
  LPixels: pointer;
  LPitch: integer;
begin
  SDL_LockTexture(ATexture, nil, @LPixels, @LPitch);
  
  LSurface := cairo_image_surface_create_for_data(LPixels, CAIRO_FORMAT_ARGB32, AWidth, AHeight, LPitch);
  
  LContext := cairo_create(LSurface);
  (*
  cairo_set_source_rgb(LContext, 1.0, 1.0, 1.0);
  *)
  cairo_set_source_surface(LContext, ABackground, 0, 0);
  cairo_paint(LContext);
  (*
  cairo_scale(LContext, AWidth, AHeight);
  cairo_translate(LContext, 1 / 2, 1 / 2);
  cairo_set_line_width(LContext, 1 / 500);
  *)
  cairo_set_source_rgb(LContext, 1, 0, 0);
  cairo_arc(LContext, AMouseX, AMouseY, 4, 0, 2 * PI);
  cairo_fill(LContext);
  
  cairo_destroy(LContext);
  cairo_surface_destroy(LSurface);
  
  SDL_UnlockTexture(ATexture);
end;
{$ENDIF}

const
  SURFACE_WIDTH  = 480;
  SURFACE_HEIGHT = 480;
  
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
begin
{$IFDEF USE_CAIRO}
  LStaticSurface := CreateStaticCairoSurface(SURFACE_WIDTH, SURFACE_HEIGHT);
{$ENDIF}
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
    Halt;

  LWindow := SDL_CreateWindow(
    'Exemple SDL2 Cairo',
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    SURFACE_WIDTH,
    SURFACE_HEIGHT,
    SDL_WINDOW_SHOWN or SDL_WINDOW_RESIZABLE or SDL_WINDOW_ALLOW_HIGHDPI
  );
  if LWindow = nil then
    Halt;

  SDL_GetWindowSize(LWindow, @LWindowWidth, @LWindowHeight);
  //WriteLn(Format('LWindowWidth=%d LWindowHeight=%d', [LWindowWidth, LWindowHeight]));
  
  LRenderer := SDL_CreateRenderer(LWindow, -1, SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC);
  if LRenderer = nil then
    Halt;
  
  SDL_GetRendererOutputSize(LRenderer, @LRendererWidth, @LRendererHeight);
  //WriteLn(Format('LRendererWidth=%d LRendererHeight=%d', [LRendererWidth, LRendererHeight]));
  
  SDL_SetRenderDrawColor(LRenderer, 0, 0, 0, 0);
  SDL_RenderClear(LRenderer);
  
  LTexture := SDL_CreateTexture(LRenderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, LRendererWidth, LRendererHeight);
  
  SDL_ShowCursor(SDL_DISABLE);
  
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
              SDL_WINDOWEVENT_SHOWN: WriteLn('W. shown');
              SDL_WINDOWEVENT_MOVED: WriteLn('W. moved');
              SDL_WINDOWEVENT_MINIMIZED: WriteLn('W. minimized');
              SDL_WINDOWEVENT_MAXIMIZED: WriteLn('W. maximized');
              SDL_WINDOWEVENT_SIZE_CHANGED,
              SDL_WINDOWEVENT_RESIZED:
              begin
                WriteLn('W. resized');
                SDL_DestroyTexture(LTexture);
                SDL_GetRendererOutputSize(LRenderer, @LRendererWidth, @LRendererHeight);
                LTexture := SDL_CreateTexture(LRenderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, LRendererWidth, LRendererHeight);
              end;
            end;
          end;
      end;
    
    SDL_SetRenderDrawColor(LRenderer, $FF, $FF, $FF, 255);
    SDL_RenderClear(LRenderer);
    
    SDL_GetMouseState(@LMouseX, @LMouseY);
    
{$IFDEF USE_CAIRO}
    CairoDraw(LTexture, LStaticSurface, LRendererWidth, LRendererHeight, LMouseX, LMouseY);
    SDL_RenderCopy(LRenderer, LTexture, nil, nil);
{$ELSE}
    filledCircleRGBA(LRenderer, LMouseX, LMouseY, 3, 255, 0, 0, 255);
    aacircleRGBA(LRenderer, LMouseX, LMouseY, 3, 255, 0, 0, 255);
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
