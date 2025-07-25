
program cardioid1;

uses
  SysUtils, SDL3, Cairo;
  
procedure CairoDraw(const ATexture: PSDL_Texture; const AWidth, AHeight: integer);
var
  LSurface: pcairo_surface_t;
  LContext: pcairo_t;
  LPixels: pointer;
  LPitch: integer;
const
  R = 0.15;
  X = -R;
  Y = 0;
  D = 0.3;
  R2 = 1 / 250;
var
  a, xx, yy, rr: double;
begin
  SDL_LockTexture(ATexture, nil, @LPixels, @LPitch);
  
  LSurface := cairo_image_surface_create_for_data(LPixels, CAIRO_FORMAT_ARGB32, AWidth, AHeight, LPitch);
  
  LContext := cairo_create(LSurface);
  
  cairo_set_source_rgb(LContext, 1.0, 1.0, 1.0);
  cairo_paint(LContext);
  cairo_scale(LContext, AWidth, AHeight);
  cairo_translate(LContext, 1 / 2, 1 / 2);
  cairo_set_line_width(LContext, 1 / 500);
  cairo_set_source_rgba(LContext, 0, 0, 1, 0.3);
  
{ Dessin d'une cardioïde par la méthode de l'enveloppe : https://mathimages.swarthmore.edu/index.php/Cardioid }
  
  a := 0;
  while a < 2 * PI - PI / 72 do
  begin
    xx := R * Cos(a);
    yy := R * Sin(a);
    rr := Sqrt((xx - X) * (xx - X) + (yy - Y) * (yy - Y));
    cairo_arc(LContext, xx, yy, rr, 0, 2 * PI);
    cairo_stroke(LContext);
    a := a + PI / 36;
  end;
  
  cairo_destroy(LContext);
  cairo_surface_destroy(LSurface);
  
  SDL_UnlockTexture(ATexture);
end;

const
  SURFACE_WIDTH  = 480;
  SURFACE_HEIGHT = 480;
  
var
  LWindow: PSDL_Window;
  LRenderer: PSDL_Renderer;
  LTexture: PSDL_Texture;
  LEvent: PSDL_Event;
  
  LWindowWidth, LWindowHeight: integer;
  LRendererWidth, LRendererHeight: integer;
  LLoop: boolean = TRUE;
  
begin
  SDL_Init(SDL_INIT_VIDEO);

  LWindow := SDL_CreateWindow(
    'SDL3 + Cairo',
    SURFACE_WIDTH,
    SURFACE_HEIGHT,
    SDL_WINDOW_RESIZABLE
  );
  
  SDL_GetWindowSize(LWindow, @LWindowWidth, @LWindowHeight);
  SDL_Log('%ix%i', LWindowWidth, LWindowHeight);
  
  LRenderer := SDL_CreateRenderer(LWindow, nil, SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC);
  
  SDL_GetCurrentRenderOutputSize(LRenderer, @LRendererWidth, @LRendererHeight);
  SDL_Log('%ix%i', LRendererWidth, LRendererHeight);
  
  SDL_SetRenderDrawColor(LRenderer, 0, 0, 0, 0);
  SDL_RenderClear(LRenderer);
  
  LTexture := SDL_CreateTexture(LRenderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, LRendererWidth, LRendererHeight);                                      
  New(LEvent);
  
  while LLoop do
  begin
    while SDL_PollEvent(LEvent) <> 0 do
    begin
      SDL_Log('event: %i', LEvent^.type_);
      case LEvent^.type_ of
        SDL_EVENT_KEY_DOWN:
          case LEvent^.key.keysym.sym of
            SDLK_ESCAPE, SDLK_Q: LLoop := FALSE;
          end;
        SDL_EVENT_QUIT:
          LLoop := FALSE;
      end;
    end;
    SDL_SetRenderDrawColor(LRenderer, 0, 0, 0, 255);
    SDL_RenderClear(LRenderer);
    
    CairoDraw(LTexture, LRendererWidth, LRendererHeight);
    
    SDL_RenderTexture(LRenderer, LTexture, nil, nil);
    SDL_RenderPresent(LRenderer);
    SDL_Delay(100);
  end;
  
  Dispose(LEvent);
  
  SDL_DestroyTexture(LTexture);
  SDL_DestroyRenderer(LRenderer);
  SDL_DestroyWindow(LWindow);
  SDL_Quit;
end.
