
uses
  SysUtils, SDL3, Cairo;

const
  SURFACE_WIDTH  = 480;
  SURFACE_HEIGHT = 480;
  
var
  w1: PSDL_Window;
  r1: PSDL_Renderer;
  s1: PSDL_Surface;
  t1: PSDL_Texture;
  e1: PSDL_Event;
  
  csf: pcairo_surface_t;
  cct: pcairo_t;
  
  ww, wh, rw, rh, i: integer;
  
  loop: boolean = TRUE;
  
begin
  SDL_Init(SDL_INIT_VIDEO);
  
  w1 := SDL_CreateWindow('SDL3 + Cairo', SURFACE_WIDTH, SURFACE_HEIGHT, SDL_WINDOW_RESIZABLE);
  
  SDL_GetWindowSize(w1, @ww, @wh);
  
  r1 := SDL_CreateRenderer(w1, nil, SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC);
  
  SDL_GetCurrentRenderOutputSize(r1, @rw, @rh);
  SDL_Log('%ix%i', rw, rh);
  
  SDL_Delay(50);
  
  SDL_SetRenderDrawColor(r1, 0, 0, 0, 0);
  SDL_RenderClear(r1);
  
  s1 := SDL_CreateSurface(rw, rh, {SDL_PIXELFORMAT_RGBA32}SDL_PIXELFORMAT_ARGB32);
  
  SDL_Log('%ix%i', s1^.w, s1^.h);
  
  csf := cairo_image_surface_create_for_data(
    s1^.pixels,
    CAIRO_FORMAT_RGB24,
    s1^.w,
    s1^.h,
    s1^.pitch
  );
  
  cct := cairo_create(csf);
  
  cairo_set_source_rgb(cct, 1.0, 1.0, 1.0);
  cairo_paint(cct);
  
  cairo_scale(cct, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_translate(cct, 1 / 2, 1 / 2);
  
  cairo_set_source_rgba(cct, 0.0, 0.0, 1.0, 0.3);
  cairo_set_line_width(cct, 4 / SURFACE_WIDTH);
  
  cairo_arc(cct, 0, 0, 1 / 3, 0, 2 * PI);
  cairo_stroke(cct);
  
  for i := 0 to 5 do
  begin
    cairo_arc(cct, 0, -1 / 3, 1 / 3, PI / 6, 5 * (PI / 6));
    cairo_stroke(cct);
    cairo_rotate(cct, PI / 3);
  end;
  
  cairo_destroy(cct);
  cairo_surface_destroy(csf);
  
  t1 := SDL_CreateTextureFromSurface(r1, s1);
  
  SDL_DestroySurface(s1);
  
  New(e1);
  
  while loop do
  begin
    while SDL_PollEvent(e1) = 1 do
      case e1^.type_ of
        SDL_EVENT_KEY_DOWN:
          case e1^.key.keysym.sym of
            SDLK_ESCAPE: loop := FALSE;
          end;
        SDL_EVENT_QUIT:
          loop := FALSE;
      end;
    
    SDL_RenderTexture(r1, t1, nil, nil);
    SDL_RenderPresent(r1);
    
    SDL_Delay(20);
  end;
  
  Dispose(e1);
  
  SDL_DestroyRenderer(r1);
  SDL_DestroyWindow(w1);

  SDL_Quit;
end.
