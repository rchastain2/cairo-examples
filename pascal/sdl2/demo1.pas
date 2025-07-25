
program demo1;

uses
  SysUtils, SDL2, Cairo;

const
  SURFACE_WIDTH  = 480;
  SURFACE_HEIGHT = 480;
  
var
  wnd: pSDL_Window;
  rnd: pSDL_Renderer;
  srf: pSDL_Surface;
  txt: pSDL_Texture;
  evt: pSDL_Event;
  pixelFormat: pSDL_PixelFormat;
  pixelFormatEnum: Uint32;
  
  csrf: pcairo_surface_t;
  ctx: pcairo_t;
  
  window_width, window_height: integer;
  renderer_width, renderer_height: integer;
  cairo_x_multiplier, cairo_y_multiplier: integer;
  i: integer;
  loop: boolean = TRUE;
  
begin
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
    Halt;

  wnd := SDL_CreateWindow('SDL2 Cairo example', SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SURFACE_WIDTH, SURFACE_HEIGHT, SDL_WINDOW_SHOWN);
  if wnd = nil then
    Halt;

  SDL_GetWindowSize(wnd, @window_width, @window_height);
  WriteLn(Format('window_width=%d window_height=%d', [window_width, window_height]));
  
  rnd := SDL_CreateRenderer(wnd, -1, 0);
  if rnd = nil then
    Halt;
  
  SDL_GetRendererOutputSize(rnd, @renderer_width, @renderer_height);
  WriteLn(Format('renderer_width=%d renderer_height=%d', [renderer_width, renderer_height]));
  
  cairo_x_multiplier := renderer_width div window_width;
  cairo_y_multiplier := renderer_height div window_height;
  
  SDL_Delay(50);
  
  SDL_SetRenderDrawColor(rnd, 0, 0, 0, 0);
  SDL_RenderClear(rnd);
  
  srf := SDL_CreateRGBSurface(0, renderer_width, renderer_height, 32, $00FF0000, $0000FF00, $000000FF, 0);
  
  WriteLn(Format('srf^.w=%d srf^.h=%d srf^.pitch=%d', [srf^.w, srf^.h, srf^.pitch]));
  WriteLn(Format('srf^.format.format=%s', [SDL_GetPixelFormatName(srf^.format^.format)]));
  
  pixelFormat := srf^.format;
  pixelFormatEnum := pixelFormat^.format;
  WriteLn(Format('srf^.format.format=%s', [SDL_GetPixelFormatName(pixelFormatEnum)]));
  
  csrf := cairo_image_surface_create_for_data(
    srf^.pixels,
    CAIRO_FORMAT_RGB24,
    srf^.w,
    srf^.h,
    srf^.pitch
  );
  (*
  cairo_surface_set_device_scale(csrf, cairo_x_multiplier, cairo_y_multiplier);
  *)
  ctx := cairo_create(csrf);
  
  cairo_set_source_rgb(ctx, 1.0, 1.0, 1.0);
  cairo_paint(ctx);
  
  cairo_scale(ctx, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_translate(ctx, 1 / 2, 1 / 2);
  
  cairo_set_source_rgba(ctx, 0.0, 0.0, 1.0, 0.3);
  cairo_set_line_width(ctx, 4 / SURFACE_WIDTH);
  
  cairo_arc(ctx, 0, 0, 1 / 3, 0, 2 * PI);
  cairo_stroke(ctx);
  
  for i := 0 to 5 do
  begin
    cairo_arc(ctx, 0, -1 / 3, 1 / 3, PI / 6, 5 * (PI / 6));
    cairo_stroke(ctx);
    cairo_rotate(ctx, PI / 3);
  end;
  
  cairo_destroy(ctx);
  cairo_surface_destroy(csrf);
  
  txt := SDL_CreateTextureFromSurface(rnd, srf);
  
  SDL_FreeSurface(srf);

  SDL_RenderCopy(rnd, txt, nil, nil);
  SDL_RenderPresent(rnd);
  
  New(evt);
  
  while loop do
  begin
    while SDL_PollEvent(evt) = 1 do
      case evt^.type_ of
        SDL_KEYDOWN:
          case evt^.key.keysym.sym of
            SDLK_ESCAPE: loop := FALSE; // exit on pressing ESC key
          end;
        SDL_QUITEV:
          loop := FALSE;
      end;
    SDL_Delay(20);
  end;
  
  Dispose(evt);
  
  SDL_DestroyRenderer(rnd);
  SDL_DestroyWindow(wnd);

  SDL_Quit;
end.
