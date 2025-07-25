
program grgula;

{
  Adaptation d'un programme de Görbe Mihály trouvé sur la page suivante :
  https://gorbem.hu/TP/Grafika.htm
}

uses
  SysUtils, Classes, SDL2, Cairo;

const
  C = 260;
  T = 50;
  A = 10;
  QX = 15;
  QY = 11;
  N = 9;
  CS = N + 2;
  LC = 3;
  LS = 2 * N;
  
type
  Vekt = array[1..3] of single;
  Csucsok = array[1..CS] of Vekt;
  Lapok = array[1..LS, 1..LC] of byte;
  
const
  al: integer = 2;
  be: integer = 0;
  ga: integer = 1;
  
var
  kx, ky: integer;
  test: Csucsok;
  testl: Lapok;
  s: Longint;

procedure Gula;
var
  i: byte;
begin
  test[1, 1] := 0;
  test[1, 2] := 0;
  test[1, 3] := A;
  for i := 0 to N - 1 do
  begin
    test[i + 2, 1] := A * Cos(i * 360 / N * PI / 180);
    test[i + 2, 2] := A * Sin(i * 360 / N * PI / 180);
    test[i + 2, 3] := 0;
  end;
  test[N + 2, 1] := 0;
  test[N + 2, 2] := 0;
  test[N + 2, 3] := -A / 3;
  for i := 1 to N - 1 do
  begin
    testl[i, 1] := 1;
    testl[i, 2] := i + 1;
    testl[i, 3] := i + 2;
  end;
  testl[N, 1] := 1;
  testl[N, 2] := N + 1;
  testl[N, 3] := 2;
  for i := N + 1 to 2 * N - 1 do
  begin
    testl[i, 1] := N + 2;
    testl[i, 2] := i - N + 2;
    testl[i, 3] := i - N + 1;
  end;
  testl[2 * N, 1] := N + 2;
  testl[2 * N, 2] := 2;
  testl[2 * N, 3] := N + 1;
end;

procedure Forgatas;
var
  i: byte;
  px, py, pz: single;
  sinal, cosal, sinbe, cosbe, singa, cosga: single;
begin
  Inc(s);
  if s mod 100 = 0 then
  begin
    al := al + Random(2) - 1;
    be := be + Random(2) - 1;
    ga := ga + Random(2) - 1;
    if Abs(al) > 4 then al := 2;
    if Abs(be) > 2 then be := 0;
    if Abs(ga) > 3 then ga := 1;
  end;
  sinal := Sin(al * PI / 180);
  cosal := Cos(al * PI / 180);
  sinbe := Sin(be * PI / 180);
  cosbe := Cos(be * PI / 180);
  singa := Sin(ga * PI / 180);
  cosga := Cos(ga * PI / 180);
  for i := 1 to CS do
  begin
    px := test[i, 1] * cosbe * cosga - test[i, 2] * cosbe * singa + test[i, 3] * sinbe;
    py := test[i, 1] * (cosal * singa + sinal * sinbe * cosga) + test[i, 2] * (cosal * cosga - sinal * sinbe * singa) - test[i, 3] * sinal * cosbe;
    pz := test[i, 1] * (sinal * singa - cosal * sinbe * cosga) + test[i, 2] * (sinal * cosga + cosal * sinbe * singa) + test[i, 3] * cosal * cosbe;
    test[i, 1] := px;
    test[i, 2] := py;
    test[i, 3] := pz;
  end;
end;

procedure Vetites(const ATexture: pSDL_Texture; const AWidth, AHeight: integer);
  
  procedure VektSzor(a, b: Vekt; var s: Vekt);
  begin
    s[1] := a[2] * b[3] - a[3] * b[2];
    s[2] := a[3] * b[1] - a[1] * b[3];
    s[3] := a[1] * b[2] - a[2] * b[1];
  end;
  
  procedure VektKul(a, b: Vekt; var k: Vekt);
  begin
    k[1] := a[1] - b[1];
    k[2] := a[2] - b[2];
    k[3] := a[3] - b[3];
  end;

var
  kp: array[1..LC + 1] of TPoint;
  i, j, k: byte;
var
  LSurface: pcairo_surface_t;
  LContext: pcairo_t;
  LPixels: pointer;
  LPitch: integer;
begin
  SDL_LockTexture(ATexture, nil, @LPixels, @LPitch);
  
  LSurface := cairo_image_surface_create_for_data(LPixels, CAIRO_FORMAT_ARGB32, AWidth, AHeight, LPitch);
  LContext := cairo_create(LSurface);
  
  cairo_set_source_rgb(LContext, 0.0, 0.0, 0.0);
  cairo_paint(LContext);
  
  cairo_set_line_width(LContext, 0.5);
  
  for i := 1 to LS do
  begin
    for j := 1 to LC do
    begin
      if j = 1 then
      begin
        kp[LC + 1].x := Round(kx + C * test[testl[i, j], 1] * QX / (C - T - test[testl[i, j], 3]));
        kp[LC + 1].y := Round(ky - C * test[testl[i, j], 2] * QY / (C - T - test[testl[i, j], 3]));
      end;
      kp[j].x := Round(kx + C * test[testl[i, j], 1] * QX / (C - T - test[testl[i, j], 3]));
      kp[j].y := Round(ky - C * test[testl[i, j], 2] * QY / (C - T - test[testl[i, j], 3]));
    end;
    if kp[1].x * (kp[2].y - kp[3].y) + kp[2].x * (kp[3].y - kp[1].y) + kp[3].x * (kp[1].y - kp[2].y) < 0 then
    begin
      k := Low(kp);
      cairo_move_to(LContext, kp[k].x, kp[k].y);
      
      for k := Succ(Low(kp)) to High(kp) do
        cairo_line_to(LContext, kp[k].x, kp[k].y);

      cairo_set_source_rgb(LContext, 0.0, i / LS, 1.0);
      cairo_fill_preserve(LContext);
      cairo_set_source_rgb(LContext, 0.5, 0.5, 0.5);
      cairo_stroke(LContext);
    end;
  end;
  
  cairo_destroy(LContext);
  cairo_surface_destroy(LSurface);
  SDL_UnlockTexture(ATexture);
end;

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
  
begin
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
    Halt;

  LWindow := SDL_CreateWindow(
    'SDL2 Cairo',
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    SURFACE_WIDTH,
    SURFACE_HEIGHT,
    SDL_WINDOW_SHOWN or SDL_WINDOW_ALLOW_HIGHDPI
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
  
  kx := SURFACE_WIDTH div 2;
  ky := SURFACE_HEIGHT div 2;
  
  Gula;
  
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
      end;
    
    SDL_SetRenderDrawColor(LRenderer, 0, 0, 0, 255);
    SDL_RenderClear(LRenderer);
    
    Vetites(LTexture, LRendererWidth, LRendererHeight);
    Forgatas;
    
    SDL_RenderCopy(LRenderer, LTexture, nil, nil);
    SDL_RenderPresent(LRenderer);
    SDL_Delay(20);
  end;
  
  Dispose(LEvent);
  
  SDL_DestroyTexture(LTexture);
  SDL_DestroyRenderer(LRenderer);
  SDL_DestroyWindow(LWindow);
  SDL_Quit;
end.
