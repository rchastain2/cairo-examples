
uses
  SDL2, Cairo, SysUtils;
  
var
  window: pSDL_Window;
  renderer: pSDL_Renderer;
  surface: pSDL_Surface;
  texture: pSDL_Texture;
  event: pSDL_Event;
  pixelFormat: pSDL_PixelFormat;
  pixelFormatEnum: uint32;
  
  cairo_surface: pcairo_surface_t;
  cairo_context: pcairo_t;
  
  window_width, window_height: integer;
  renderer_width, renderer_height: integer;
  cairo_x_multiplier, cairo_y_multiplier: integer;
  
  i: integer;
  loop: boolean = TRUE;

(* -------------------------------------------------------------------------- *)

const
  SURFACE_WIDTH = 480;
  SURFACE_HEIGHT = 480;

const
  R = 0.15;
  X = -R;
  Y = 0;
  
var
  //context: pcairo_t;
  //surface: pcairo_surface_t;
  a,
  xx, yy,
  rr: double;

const
  D = 0.3;
  R2 = 1 / 250;
  
var
  dx, dy: double;
  xx1, yy1, xx2, yy2: double;

(* -------------------------------------------------------------------------- *)

begin
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
    Halt;

  window := SDL_CreateWindow(
    'SDL2 Cairo example',
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    SURFACE_WIDTH,
    SURFACE_HEIGHT,
    SDL_WINDOW_SHOWN
  );
  if window = nil then
    Halt;

  SDL_GetWindowSize(window, @window_width, @window_height);
  WriteLn(Format('window_width=%d window_height=%d', [window_width, window_height]));
  
  renderer := SDL_CreateRenderer(window, -1, 0);
  if renderer = nil then
    Halt;
  
  SDL_GetRendererOutputSize(renderer, @renderer_width, @renderer_height);
  WriteLn(Format('renderer_width=%d renderer_height=%d', [renderer_width, renderer_height]));
  
  cairo_x_multiplier := renderer_width div window_width;
  cairo_y_multiplier := renderer_height div window_height;
  
{$IFDEF LINUX}
  SDL_Delay(50);
{$ENDIF}

  SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0);
  SDL_RenderClear(renderer);
  
  surface := SDL_CreateRGBSurface(0, renderer_width, renderer_height, 32, $00FF0000, $0000FF00, $000000FF, 0);
  
  WriteLn(Format('surface^.w=%d surface^.h=%d surface^.pitch=%d', [surface^.w, surface^.h, surface^.pitch]));
  WriteLn(Format('surface^.format.format=%s', [SDL_GetPixelFormatName(surface^.format^.format)]));
  
  pixelFormat := surface^.format;
  pixelFormatEnum := pixelFormat^.format;
  WriteLn(Format('surface^.format.format=%s', [SDL_GetPixelFormatName(pixelFormatEnum)]));
  
  cairo_surface := cairo_image_surface_create_for_data(
    surface^.pixels,
    CAIRO_FORMAT_RGB24,
    surface^.w,
    surface^.h,
    surface^.pitch
  );
  (*
  cairo_surface_set_device_scale(cairo_surface, cairo_x_multiplier, cairo_y_multiplier);
  *)
  
  cairo_context := cairo_create(cairo_surface);
  
  cairo_set_source_rgb(cairo_context, 1, 1, 1);
  cairo_paint(cairo_context);

  cairo_scale(cairo_context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_translate(cairo_context, 1 / 2, 1 / 2);
  
  cairo_set_line_width(cairo_context, 1 / 500);
  cairo_set_line_cap(cairo_context, CAIRO_LINE_CAP_ROUND);
  cairo_set_line_join(cairo_context, CAIRO_LINE_JOIN_ROUND);
  
  (*
  cairo_set_source_rgb(context, 0, 0, 1);
  cairo_arc(context, 0, 0, R, 0, 2 * PI);
  cairo_stroke(context);
  *)
  
  cairo_set_source_rgb(cairo_context, 0, 0, 0);
  cairo_arc(cairo_context, X, Y, R2, 0, 2 * PI);
  cairo_fill(cairo_context);
  
  a := 0;
  
  while a < 2 * PI - PI / 72 do
  begin
    xx := R * Cos(a);
    yy := R * Sin(a);
    
    dx := xx - X;
    dy := yy - Y;
    rr := Sqrt(dx * dx + dy * dy);
    
    xx1 := xx - (D / rr) * dx;
    yy1 := yy - (D / rr) * dy;
    xx2 := xx + (D / rr) * dx;
    yy2 := yy + (D / rr) * dy;
    
    cairo_set_source_rgb(cairo_context, 0.5, 0.5, 0.5);
    cairo_move_to(cairo_context, xx1, yy1);
    cairo_line_to(cairo_context, xx2, yy2);
    cairo_stroke(cairo_context);
    
    cairo_set_source_rgb(cairo_context, 0, 0, 0);
    cairo_arc(cairo_context, xx, yy, R2, 0, 2 * PI);
    cairo_arc(cairo_context, xx1, yy1, R2, 0, 2 * PI);
    cairo_arc(cairo_context, xx2, yy2, R2, 0, 2 * PI);
    cairo_fill(cairo_context);
    
    a := a + PI / 18;
  end;
  
  texture := SDL_CreateTextureFromSurface(renderer, surface);
  
  cairo_destroy(cairo_context);
  cairo_surface_destroy(cairo_surface);
  
  SDL_FreeSurface(surface);

  SDL_RenderCopy(renderer, texture, nil, nil);
  SDL_RenderPresent(renderer);
  
  New(event);
  
  while loop do
  begin
    while SDL_PollEvent(event) = 1 do
      case event^.type_ of
        SDL_KEYDOWN:
          case event^.key.keysym.sym of
            SDLK_ESCAPE: loop := FALSE; // exit on pressing ESC key
          end;
      end;
    SDL_Delay(20);
  end;
  
  Dispose(event);
  
  SDL_DestroyRenderer(renderer);
  SDL_DestroyWindow(window);

  SDL_Quit;
end.
