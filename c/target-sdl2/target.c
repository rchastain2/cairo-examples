
#ifndef RES_PATH
#define RES_PATH "resources/"
#endif

#define WIDTH 800
#define HEIGHT 600

#include <time.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>

#include <SDL2/SDL.h>
#include <cairo/cairo.h>

int W = WIDTH, H = HEIGHT;
int TS = 50 * (WIDTH / 800.0); /* Target size */

SDL_Window* window = NULL;
SDL_Renderer* renderer;
SDL_Texture* texture;

SDL_Surface* screen;
SDL_Surface* img;
SDL_Surface* cursor;
SDL_Surface* shot;
SDL_Surface* shot_blood;
SDL_Surface* rabbit;
SDL_Surface* rabbit_values;

cairo_t* img_ctx;

SDL_Rect target;
SDL_Rect rect_cur;

double average = 0, count_10_value = 0;
int count = 0, count_10_first_shot = 0;
bool headshot, no_rabbit = false;

typedef struct
{
  Uint8* data;
  Uint32 length;
} Wave;

Wave* wav;
int wav_pos;

void draw_rabbit(cairo_t* ctx, double size);

double rnd(double max)
{
  return  max * rand() / RAND_MAX;
}

double get_time_ms()
{
  struct timespec ts;
  clock_gettime(CLOCK_MONOTONIC, &ts);
  double t = ts.tv_sec * 1000.0 + ts.tv_nsec / 1.0e6;
  return t;
}

void draw_text(char* text, double font_size, double dy, double r, double g, double b)
{
  cairo_set_font_size(img_ctx, font_size);
  cairo_set_source_rgb(img_ctx, r, g, b);

  cairo_text_extents_t te;
  cairo_text_extents(img_ctx, text, &te);

  cairo_move_to(img_ctx, W / 2 - te.width / 2 - te.x_bearing, H / 2 - te.height / 2 - te.y_bearing + dy);
  cairo_show_text(img_ctx, text);

  SDL_Rect rect = {W / 2 - te.width / 2 - 1, H / 2 - te.height / 2 + dy - 1, te.width + 3, te.height + 3};
  SDL_BlitSurface(img, &rect, screen, &rect);
}

void draw_value(double r, double t)
{
  double Vr = 1 - 2 * r / TS;
  double Vt = (t - 500.0) / 1000;
  double V = (1200 + 200 * headshot) * Vr * pow(0.1, 2 * Vt);
  count_10_value += V;

  char str[32];

  sprintf(str, "%i", (int)V);
  draw_text(str, W / 5.33, 0, 1, 0.55, 0);

  if (headshot)
  {
    sprintf(str, "HEADSHOT! %i ms", (int)t);
  }
  else
  {
    sprintf(str, "%i ms", (int)t);
  }

  draw_text(str, W / 40.0, W / 11.0, 0, 0.55, 1);

  if (t < 400)
  {
    draw_text("Amazing reaction!", W / 80.0, 1.25 * W / 11.0, 1, 1, 1);
  }
}

void draw_sum()
{
  char str[32];

  sprintf(str, "Sum of 10: %i", (int)count_10_value);
  draw_text(str, W / 10.0, 0, 0, 0.55, 1);

  sprintf(str, "First shot accuracy: %i/10", count_10_first_shot);
  draw_text(str, W / 40.0, W / 15.0, 1, 1, 1);

  count_10_value = 0;
  count_10_first_shot = 0;
}

void draw_percentage()
{
  int cnt = (count % 10) + 1;
  cairo_set_source_rgb(img_ctx, 0, 0.5, 1);
  cairo_rectangle(img_ctx, 0, H - 1, W / 10.0 * cnt, 1);
  cairo_fill(img_ctx);
}

void draw_cursor(cairo_t* cursor_ctx) // 19x19 px
{
  cairo_move_to(cursor_ctx, 0, 9.5);
  cairo_line_to(cursor_ctx, 7, 9.5);
  cairo_move_to(cursor_ctx, 12, 9.5);
  cairo_line_to(cursor_ctx, 19, 9.5);

  cairo_move_to(cursor_ctx, 9.5, 0);
  cairo_line_to(cursor_ctx, 9.5, 7);
  cairo_move_to(cursor_ctx, 9.5, 12);
  cairo_line_to(cursor_ctx, 9.5, 19);

  cairo_new_sub_path(cursor_ctx);
  cairo_arc(cursor_ctx, 9.5, 9.5, 7, 0, 2 * M_PI);

  cairo_set_source_rgb(cursor_ctx, 0, 0, 0);
  cairo_set_line_width(cursor_ctx, 2);
  cairo_stroke_preserve(cursor_ctx);

  cairo_set_source_rgb(cursor_ctx, 1, 1, 1);
  cairo_set_line_width(cursor_ctx, 1);
  cairo_stroke(cursor_ctx);

  cairo_set_source_rgb(cursor_ctx, 1, 1, 1);
  cairo_rectangle(cursor_ctx, 9, 9, 1, 1);
  cairo_fill(cursor_ctx);
}

void draw_target()
{
  int cx = TS / 2 + rnd(W - TS);
  int cy = TS / 2 + rnd(H - TS);

  target = (SDL_Rect)
  {
    cx - TS / 2, cy - TS / 2, TS, TS
  };

  if (no_rabbit)
  {
    cairo_set_source_rgb(img_ctx, 1, 0.3, 0);
    cairo_arc(img_ctx, cx, cy, TS / 2, 0, 2 * M_PI);
    cairo_fill(img_ctx);

    cairo_set_source_rgb(img_ctx, 1, 0.8, 0);
    cairo_set_line_width(img_ctx, TS / 7.0);
    cairo_arc(img_ctx, cx, cy, TS / 2.0 / 7.0 * 4, 0, 2 * M_PI);
    cairo_stroke(img_ctx);
    cairo_arc(img_ctx, cx, cy, TS / 2.0 / 7.0, 0, 2 * M_PI);
    cairo_fill(img_ctx);
  }
  else
  {
    SDL_BlitSurface(rabbit, NULL, img, &target);
  }
}

double check_round_target(int cx, int cy)
{
  double r = hypot(cx - (target.x + TS / 2.0),
                   cy - (target.y + TS / 2.0));

  if (r <= TS / 2.0)
  {
    return r;
  }
  else
  {
    return -1;
  }
}

double check_rabbit(int cx, int cy)
{
  int dx = (cx - target.x) * 520.0 / TS;
  int dy = (cy - target.y) * 520.0 / TS;

  headshot = false;

  if (dx < 0 || dy < 0 || dx >= rabbit_values->w || dy >= rabbit_values->h)
  {
    return -1;
  }

  unsigned char* p = (unsigned char*)((int*)rabbit_values->pixels + dy * rabbit_values->w + dx);
  int bv = p[2];
  int hs = p[1];  /* Headshot if pixel has only red component */

  if (bv == 0)
  {
    return -1;
  }

  double r = (255 - bv) / 255.0 * TS / 2;

  if (hs == 0)
  {
    headshot = true;
  }

  return r;
}

double check_target(int cx, int cy)
{
  if (no_rabbit)
  {
    return check_round_target(cx, cy);
  }
  else
  {
    return check_rabbit(cx, cy);
  }
}

void audio_callback(void* userdata, Uint8* buffer, int buffer_len)
{
  int wav_length = wav->length;
  Uint8* wav_data = wav->data;

  if (buffer_len > wav_length - wav_pos)
  {
    buffer_len = wav_length - wav_pos;
  }

  memcpy(buffer, wav_data + wav_pos, buffer_len);
  wav_pos += buffer_len;

  if (wav_pos == wav_length)
  {
    SDL_PauseAudio(1);
  }
}

void play(Wave* w)
{
  wav = w;
  wav_pos = 0;
  SDL_PauseAudio(0);
}

Uint32 timer_callback(Uint32 interval, void* param)
{
  SDL_Event e;
  e.type = SDL_USEREVENT;
  SDL_PushEvent(&e);
  return 0;
}

SDL_Surface* surface_from_image(char* png, int ox, int oy)
{
  cairo_surface_t* png_cs = cairo_image_surface_create_from_png(png);
  int w = cairo_image_surface_get_width(png_cs) + ox + 1;
  int h = cairo_image_surface_get_height(png_cs) + oy + 1;

  SDL_Surface* surf = SDL_CreateRGBSurface(SDL_SWSURFACE, w, h, 32, 0X00FF0000, 0X0000FF00, 0X000000FF, 0XFF000000);
  cairo_surface_t* cs = cairo_image_surface_create_for_data(surf->pixels, CAIRO_FORMAT_ARGB32, w, h, surf->pitch);

  cairo_t* ctx = cairo_create(cs);
  cairo_set_source_surface(ctx, png_cs, ox, oy);
  cairo_paint(ctx);

  cairo_destroy(ctx);
  cairo_surface_destroy(cs);
  cairo_surface_destroy(png_cs);

  return surf;
}

int main (int argc, char* argv[])
{
  no_rabbit = argc > 1;

  SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_AUDIO);
  SDL_ShowCursor(0);

  window = SDL_CreateWindow("Target SDL2", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, W, H, SDL_WINDOW_SHOWN);
  if (window == NULL)
  {
    fprintf(stderr, "Window could not be created: %s\n", SDL_GetError());
    return 1;
  }

  screen = SDL_CreateRGBSurface(0, W, H, 32, 0x00FF0000, 0x0000FF00, 0x000000FF, 0xFF000000);
  renderer = SDL_CreateRenderer(window, -1, 0);
  texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, W, H);
  
  img = SDL_CreateRGBSurface(SDL_SWSURFACE, W, H, 32, 0X00FF0000, 0X0000FF00, 0X000000FF, 0X00000000);
  
  cairo_surface_t* img_s;
  img_s = cairo_image_surface_create_for_data(img->pixels, CAIRO_FORMAT_ARGB32, W, H, img->pitch);
  img_ctx = cairo_create(img_s);

  cursor = SDL_CreateRGBSurface(SDL_SWSURFACE, 19, 19, 32, 0X00FF0000, 0X0000FF00, 0X000000FF, 0XFF000000);
  {
    cairo_surface_t* cursor_s;
    cursor_s = cairo_image_surface_create_for_data(cursor->pixels, CAIRO_FORMAT_ARGB32, 19, 19, cursor->pitch);
    cairo_t* cursor_ctx = cairo_create(cursor_s);
    draw_cursor(cursor_ctx);
    cairo_destroy(cursor_ctx);
    cairo_surface_destroy(cursor_s);
  }

  shot = surface_from_image(RES_PATH "shot.png", 2, 2);

  if (no_rabbit)
  {
    shot_blood = shot;
  }
  else
  {
    shot_blood = SDL_CreateRGBSurfaceFrom(shot->pixels, shot->w, shot->h, 32, shot->pitch, 0X00FF0000, 0, 0, 0XFF000000);
  }

  rabbit = SDL_CreateRGBSurface(SDL_SWSURFACE, TS, TS, 32, 0X00FF0000, 0X0000FF00, 0X000000FF, 0XFF000000);
  {
    cairo_surface_t* rabbit_s;
    rabbit_s = cairo_image_surface_create_for_data(rabbit->pixels, CAIRO_FORMAT_ARGB32, TS, TS, rabbit->pitch);
    cairo_t* rabbit_ctx = cairo_create(rabbit_s);
    draw_rabbit(rabbit_ctx, TS);
    cairo_destroy(rabbit_ctx);
    cairo_surface_destroy(rabbit_s);
  }

  /*
  Image describing rabbit vulnerability values. If a pixel has only red channel, it is treated as rabbit head pixel.
  */
  rabbit_values = surface_from_image(RES_PATH "rabbit_values.png", 0, 0);

  cairo_select_font_face(img_ctx, "Troika", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size(img_ctx, W / 5.33);
  draw_text("Target", W / 5.33, 0, 0, 0.55, 1);

  Wave sniper, blood, rabbit, reload;
  SDL_AudioSpec spec;
  SDL_LoadWAV(RES_PATH "sniper.wav", &spec, &sniper.data, &sniper.length);

  if (no_rabbit)
  {
    SDL_LoadWAV(RES_PATH "hit.wav", &spec, &blood.data, &blood.length);
    SDL_LoadWAV(RES_PATH "pop.wav", &spec, &rabbit.data, &rabbit.length);
  }
  else
  {
    SDL_LoadWAV(RES_PATH "blood.wav", &spec, &blood.data, &blood.length);
    SDL_LoadWAV(RES_PATH "rabbit.wav", &spec, &rabbit.data, &rabbit.length);
  }

  SDL_LoadWAV(RES_PATH "reload.wav", &spec, &reload.data, &reload.length);
  spec.callback = audio_callback;
  spec.samples = 512;
  SDL_OpenAudio(&spec, &spec);

  srand(time(NULL));

  bool wait = true,
       wipe_cursor = false,
       count_10 = true,
       first_shot = true;

  double total_time;

  SDL_Event event;
  {
    int x, y;
    SDL_GetMouseState(&x, &y);
    rect_cur = (SDL_Rect)
    {
      x - 9, y - 9, 19, 19
    };
  }

  while (true)
  {
    SDL_WaitEvent(&event);

    do
    {
      switch (event.type)
      {
      case SDL_QUIT:
        goto exit;

      case SDL_KEYDOWN:
        switch (event.key.keysym.sym)
        {
        case SDLK_ESCAPE:
        case SDLK_q:
          goto exit;
        }

        break;

      case SDL_MOUSEMOTION:
        if (wipe_cursor)
        {
          SDL_BlitSurface(img, &rect_cur, screen, &rect_cur);
          wipe_cursor = false;
        }

        rect_cur.x = event.motion.x - 9;
        rect_cur.y = event.motion.y - 9;
        break;

      case SDL_MOUSEBUTTONDOWN:
      {
        double r = check_target(event.button.x, event.button.y);

        if (wait && count_10 && count_10_value == 0)
        {
          play(&reload);
          count_10 = false;
          SDL_AddTimer(1000, timer_callback, NULL);
        }
        else
        {
          if (r >= 0)
          {
            play(&blood);
            
            if (first_shot)
            {
              count_10_first_shot += 1;
            }

            SDL_BlitSurface(shot_blood, NULL, img, &rect_cur);
          }
          else
          {
            play(&sniper);
            
            SDL_BlitSurface(shot, NULL, img, &rect_cur);
          }

          first_shot = false;
          
          SDL_BlitSurface(img, &rect_cur, screen, &rect_cur);
        }

        if (!wait)
        {
          wait = (r >= 0);

          if (wait)
          {
            total_time = get_time_ms() - total_time;
            average += total_time;
            count += 1;

            if (count % 10 == 0)
            {
              count_10 = true;
              SDL_AddTimer(2000, timer_callback, NULL);
            }
            else
            {
              SDL_AddTimer(500 + rnd(6000), timer_callback, NULL);
            }

            draw_value(r, total_time);
          }
        }
        break;
      }

      case SDL_USEREVENT:
        cairo_set_source_rgb(img_ctx, 0, 0, 0);
        cairo_paint(img_ctx);

        if (!count_10) draw_percentage();

        SDL_BlitSurface(img, NULL, screen, NULL);

        if (count_10)
        {
          draw_sum();
        }
        else
        {
          play(&rabbit);

          draw_target();
          SDL_BlitSurface(img, &target, screen, &target);

          wait = false;
          total_time = get_time_ms();
          first_shot = true;
        }
        break;
      }
    }
    while (SDL_PollEvent(&event));

    SDL_BlitSurface(cursor, NULL, screen, &rect_cur);
    wipe_cursor = true;

    SDL_UpdateTexture(texture, NULL, screen->pixels, screen->pitch);
    SDL_RenderClear(renderer);
    SDL_RenderCopy(renderer, texture, NULL, NULL);
    SDL_RenderPresent(renderer);
  }

exit:
  SDL_FreeWAV(reload.data);
  SDL_FreeWAV(rabbit.data);
  SDL_FreeWAV(blood.data);
  SDL_FreeWAV(sniper.data);

  cairo_destroy(img_ctx);
  cairo_surface_destroy(img_s);

  if (!no_rabbit)
  {
    SDL_FreeSurface(shot_blood);
  }

  SDL_FreeSurface(shot);
  SDL_FreeSurface(cursor);
  SDL_FreeSurface(img);
  SDL_FreeSurface(screen);

  SDL_Quit();

  return 0;
}
