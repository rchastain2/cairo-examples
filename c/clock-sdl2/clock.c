
/*
  Horloge SDL2 + Cairo
  
  Compilation : gcc clock.c -o clock -lSDL2 -lcairo -lm
                                                                      */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#include <SDL2/SDL.h>
#include <cairo/cairo.h>

#define WIDTH  240
#define HEIGHT 240
#define OFFSET  16

SDL_Window*   g_wind = NULL;
SDL_Renderer* g_rend = NULL;
SDL_Surface*  g_surf = NULL;
SDL_Texture*  g_text = NULL;

int g_radius;
int g_center_x;
int g_center_y;
int g_window_w = WIDTH;
int g_window_h = HEIGHT;

void SetValues(int w, int h);
void DrawClock(SDL_Surface* sf, int h, int m, int s);
void Init();
void Loop();
void Close();

int main()
{
  Init();
  Loop();
  Close();
  
  return 0;
}

void Init()
{
  if (SDL_Init(SDL_INIT_VIDEO) != 0)
  {
    fprintf(stderr, "SDL_Init error: %s\n", SDL_GetError());
    exit(EXIT_FAILURE);
  }
  
/*const Uint32 flags1 = SDL_WINDOW_RESIZABLE;*/
  const Uint32 flags1 = 0;
  
  g_wind = SDL_CreateWindow("Clock", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, g_window_w, g_window_h, flags1);

  if (g_wind == NULL)
  {
    fprintf(stderr, "SDL_CreateWindow error: %s\n", SDL_GetError());
    SDL_Quit();
    exit(EXIT_FAILURE);
  }

  const Uint32 flags2 = SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC;
  
  g_rend = SDL_CreateRenderer(g_wind, -1, flags2);

  if (g_rend == NULL)
  {
    fprintf(stderr, "SDL_CreateRenderer error: %s\n", SDL_GetError());
    SDL_DestroyWindow(g_wind);
    SDL_Quit();
    exit(EXIT_FAILURE);
  }

  g_surf = SDL_CreateRGBSurface(0, g_window_w, g_window_h, 32, 0x00ff0000, 0x0000ff00, 0x000000ff, 0);
  
  g_text = SDL_CreateTextureFromSurface(g_rend, g_surf);
}

void Loop()
{
  SDL_bool done = SDL_FALSE;
  SDL_Event e;
  
  time_t raw;
  struct tm* tm_p = NULL;
  
  SetValues(WIDTH, HEIGHT);
  Uint32 windowID = SDL_GetWindowID(g_wind);

  while (!done)
  {
    while (SDL_PollEvent(&e))
    {
      switch (e.type)
      {
        case SDL_WINDOWEVENT:
          if (e.window.windowID == windowID && e.window.event == SDL_WINDOWEVENT_SIZE_CHANGED)
          {
            SetValues(e.window.data1, e.window.data2);
          }
          break;

        case SDL_KEYDOWN:
          switch (e.key.keysym.sym)
          {
            case SDLK_ESCAPE:
            case SDLK_q:
              done = SDL_TRUE;
              break;
          }
          break;

        case SDL_QUIT:
          done = SDL_TRUE;
          break;
      }
    }
    
    time(&raw);
    tm_p = localtime(&raw);
    
    DrawClock(g_surf, tm_p->tm_hour, tm_p->tm_min, tm_p->tm_sec);
    
    SDL_UpdateTexture(g_text, NULL, g_surf->pixels, g_surf->pitch);
    SDL_SetRenderDrawColor(g_rend, 0, 0, 0, SDL_ALPHA_OPAQUE);
    SDL_RenderClear(g_rend);
    SDL_RenderCopy(g_rend, g_text, NULL, NULL);
    SDL_RenderPresent(g_rend);
    
    SDL_Delay(100);
  }
}

void SetValues(int w, int h)
{
  g_window_w = w;
  g_window_h = h;
  g_radius = (g_window_w < g_window_h ? g_window_w : g_window_h) / 2 - OFFSET;
  g_center_x = g_window_w / 2;
  g_center_y = g_window_h / 2;
  
  if (g_surf)
  {
    SDL_FreeSurface(g_surf);
    g_surf = SDL_CreateRGBSurface(0, g_window_w, g_window_h, 32, 0x00ff0000, 0x0000ff00, 0x000000ff, 0);
  }
  if (g_text)
  {
    SDL_DestroyTexture(g_text);
    g_text = SDL_CreateTextureFromSurface(g_rend, g_surf);
  }
}

#define COLOR1 0.945, 0.890, 0.867
#define COLOR2 0.737, 0.792, 0.839
#define COLOR3 0.553, 0.616, 0.714
#define COLOR4 0.400, 0.447, 0.573

void DrawClock(SDL_Surface* sf, int h, int m, int s)
{
  SDL_LockSurface(sf);
  
  cairo_surface_t* cs = cairo_image_surface_create_for_data((unsigned char*)sf->pixels, CAIRO_FORMAT_RGB24, sf->w, sf->h, sf->pitch);
  cairo_t* cr = cairo_create(cs);
  
  cairo_set_source_rgb(cr, COLOR1); /* Couleur fond */
  cairo_paint(cr);
  
  cairo_set_source_rgb(cr, COLOR3); /* Couleur points */

  for (int u = 0; u < 360; u += 6)
  {
    double a = u * M_PI / 180;
    double x = g_center_x + g_radius * cos(a);
    double y = g_center_y + g_radius * sin(a);
    double r = (u % 30) ? 2.0 : 3.5;
    
    cairo_arc(cr, x, y, r, 0, 2 * M_PI);
    cairo_fill(cr);
  }
  
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND);
  cairo_set_source_rgb(cr, COLOR4); /* Couleur aiguilles heure et minute */
  
  double radians_sec, radians_min, radians_h;
  double x, y;
  
  radians_sec = s * M_PI / 30;
  radians_min = (m + s / 60.0) * M_PI / 30;
  radians_h = (h + m / 60.0) * M_PI / 6;
  
  x = g_center_x + (g_radius / 2) * cos(radians_h + 3 * M_PI / 2);
  y = g_center_y + (g_radius / 2) * sin(radians_h + 3 * M_PI / 2);
  
  cairo_move_to(cr, g_center_x, g_center_y);
  cairo_line_to(cr, x, y);
  cairo_set_line_width(cr, 8.0);
  cairo_stroke(cr);
  
  x = g_center_x + (3 * g_radius / 4) * cos(radians_min + 3 * M_PI / 2);
  y = g_center_y + (3 * g_radius / 4) * sin(radians_min + 3 * M_PI / 2);
  
  cairo_move_to(cr, g_center_x, g_center_y);
  cairo_line_to(cr, x, y);
  cairo_set_line_width(cr, 5.0);
  cairo_stroke(cr);
  
  cairo_set_source_rgb(cr, COLOR2); /* Couleur aiguille seconde */
  
  x = g_center_x + (7 * g_radius / 8) * cos(radians_sec + 3 * M_PI / 2);
  y = g_center_y + (7 * g_radius / 8) * sin(radians_sec + 3 * M_PI / 2);
  
  cairo_move_to(cr, g_center_x, g_center_y);
  cairo_line_to(cr, x, y);
  cairo_set_line_width(cr, 2.0);
  
  cairo_stroke(cr);
  cairo_destroy(cr);
  cairo_surface_destroy(cs);
  
  SDL_UnlockSurface(sf);
}

void Close()
{
  if (g_text) SDL_DestroyTexture(g_text);
  if (g_surf) SDL_FreeSurface(g_surf);
  if (g_rend) SDL_DestroyRenderer(g_rend);
  if (g_wind) SDL_DestroyWindow(g_wind);
  
  SDL_Quit();
}
