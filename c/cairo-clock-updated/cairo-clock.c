
/*
 * cairo-clock.c
 *
 * Author: Mirco "MacSlow" Mueller <macslow@bangang.de>
 *
 * https://gitlab.com/cairo/cairo-demos/-/tree/master/cairo-candy
 *
 */

#include <gdk/gdkkeysyms.h>
#include <gtk/gtk.h>
#include <time.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <librsvg/rsvg.h>

#define SECOND_INTERVAL 1000
#define MINUTE_INTERVAL 60000
#define MIN_WIDTH 32
#define MIN_HEIGHT 32
#define MAX_WIDTH 512
#define MAX_HEIGHT 512

enum
{
  CLOCK_DROP_SHADOW = 0,
  CLOCK_FACE,
  CLOCK_MARKS,
  CLOCK_HOUR_HAND_SHADOW,
  CLOCK_MINUTE_HAND_SHADOW,
  CLOCK_SECOND_HAND_SHADOW,
  CLOCK_HOUR_HAND,
  CLOCK_MINUTE_HAND,
  CLOCK_SECOND_HAND,
  CLOCK_FACE_SHADOW,
  CLOCK_GLASS,
  CLOCK_FRAME,
  CLOCK_ELEMENTS
};

cairo_t* g_pCairoContext;
RsvgHandle* g_pSvgHandles[CLOCK_ELEMENTS];
char g_cFileNames[CLOCK_ELEMENTS][30] =
{
  "clock-drop-shadow.svg",
  "clock-face.svg",
  "clock-marks.svg",
  "clock-hour-hand-shadow.svg",
  "clock-minute-hand-shadow.svg",
  "clock-second-hand-shadow.svg",
  "clock-hour-hand.svg",
  "clock-minute-hand.svg",
  "clock-second-hand.svg",
  "clock-face-shadow.svg",
  "clock-glass.svg",
  "clock-frame.svg"
};
GError* g_pError  = NULL;
GFile* g_pFile = NULL;
RsvgDimensionData g_DimensionData;
RsvgRectangle g_Rectangle =
{
  .x = 0.0,
  .y = 0.0,
  .width = 128,
  .height = 128,
};
int g_iSeconds;
int g_iMinutes;
int g_iHours;
static time_t g_timeOfDay;
struct tm* g_pTime;
int g_iEverySecond   =   0; /* 1/0 - draw/don't draw seconds */
int g_iDefaultWidth  = 128; /* window opens with this width  */
int g_iDefaultHeight = 128; /* ... and with this height      */

void render(int width, int height);

static gboolean time_handler(GtkWidget* pWidget)
{
  gtk_widget_queue_draw(pWidget);
  return TRUE;
}

static gboolean on_alpha_window_expose(GtkWidget* pWidget, GdkEventExpose* pExpose)
{
  static gint iWidth;
  static gint iHeight;
  g_pCairoContext = gdk_cairo_create(pWidget->window);
  cairo_set_operator(g_pCairoContext, CAIRO_OPERATOR_SOURCE);
  gtk_window_get_size(GTK_WINDOW(pWidget), &iWidth, &iHeight);
  render(iWidth, iHeight);
  cairo_destroy(g_pCairoContext);
  return FALSE;
}

static void on_alpha_screen_changed(GtkWidget* pWidget, GdkScreen* pOldScreen, GtkWidget* pLabel)
{
  GdkScreen* pScreen = gtk_widget_get_screen(pWidget);
  GdkColormap* pColormap = gdk_screen_get_rgba_colormap(pScreen);
  if (!pColormap)
    pColormap = gdk_screen_get_rgb_colormap(pScreen);
  gtk_widget_set_colormap(pWidget, pColormap);
}

gboolean on_key_press(GtkWidget* pWidget, GdkEventKey* pKey, gpointer userData)
{
  if (pKey->type == GDK_KEY_PRESS)
  {
    switch (pKey->keyval)
    {
    case GDK_Escape :
      gtk_main_quit();
      break;
    }
  }
  return FALSE;
}

gboolean on_button_press(GtkWidget* pWidget, GdkEventButton* pButton, GdkWindowEdge edge)
{
  if (pButton->type == GDK_BUTTON_PRESS)
  {
    if (pButton->button == 1)
      gtk_window_begin_move_drag(GTK_WINDOW(gtk_widget_get_toplevel(pWidget)), pButton->button, pButton->x_root, pButton->y_root, pButton->time);
    if (pButton->button == 2)
      gtk_window_begin_resize_drag(GTK_WINDOW(gtk_widget_get_toplevel(pWidget)), edge, pButton->button, pButton->x_root, pButton->y_root, pButton->time);
  }
  return TRUE;
}

void render(int width, int height)
{
  double fHalfX = g_DimensionData.width / 2.0f;
  double fHalfY = g_DimensionData.height / 2.0f;
  double fShadowOffsetX = -0.75f;
  double fShadowOffsetY = 0.75f;
  time(&g_timeOfDay);
  g_pTime = localtime(&g_timeOfDay);
  g_iSeconds = g_pTime->tm_sec;
  g_iMinutes = g_pTime->tm_min;
  g_iHours = g_pTime->tm_hour;
  g_iHours = g_iHours >= 12 ? g_iHours - 12 : g_iHours;
  cairo_save(g_pCairoContext);
  cairo_scale(g_pCairoContext, (double)width / (double)g_DimensionData.width, (double)height / (double)g_DimensionData.height);
  cairo_set_source_rgba(g_pCairoContext, 1.0f, 1.0f, 1.0f, 0.0f);
  cairo_set_operator(g_pCairoContext, CAIRO_OPERATOR_SOURCE);
  cairo_paint(g_pCairoContext);
  cairo_save(g_pCairoContext);
  cairo_set_operator(g_pCairoContext, CAIRO_OPERATOR_OVER);

  rsvg_handle_render_document(g_pSvgHandles[CLOCK_DROP_SHADOW], g_pCairoContext, &g_Rectangle, &g_pError);
  rsvg_handle_render_document(g_pSvgHandles[CLOCK_FACE], g_pCairoContext, &g_Rectangle, &g_pError);
  rsvg_handle_render_document(g_pSvgHandles[CLOCK_MARKS], g_pCairoContext, &g_Rectangle, &g_pError);
  
  cairo_save(g_pCairoContext);
  cairo_translate(g_pCairoContext, fHalfX, fHalfY);
  cairo_rotate(g_pCairoContext, -M_PI / 2.0f);
  cairo_save(g_pCairoContext);
  cairo_translate(g_pCairoContext, fShadowOffsetX, fShadowOffsetY);
  cairo_rotate(g_pCairoContext, (M_PI / 6.0f) * g_iHours);
  
  rsvg_handle_render_document(g_pSvgHandles[CLOCK_HOUR_HAND_SHADOW], g_pCairoContext, &g_Rectangle, &g_pError);
  
  cairo_restore(g_pCairoContext);
  cairo_save(g_pCairoContext);
  cairo_translate(g_pCairoContext, fShadowOffsetX, fShadowOffsetY);
  cairo_rotate(g_pCairoContext, (M_PI / 30.0f) * g_iMinutes);
  
  rsvg_handle_render_document(g_pSvgHandles[CLOCK_MINUTE_HAND_SHADOW], g_pCairoContext, &g_Rectangle, &g_pError);
  
  cairo_restore(g_pCairoContext);
  if (g_iEverySecond)
  {
    cairo_save(g_pCairoContext);
    cairo_translate(g_pCairoContext, fShadowOffsetX, fShadowOffsetY);
    cairo_rotate(g_pCairoContext, (M_PI / 30.0f) * g_iSeconds);
    
    rsvg_handle_render_document(g_pSvgHandles[CLOCK_SECOND_HAND_SHADOW], g_pCairoContext, &g_Rectangle, &g_pError);
    
    cairo_restore(g_pCairoContext);
  }
  cairo_save(g_pCairoContext);
  cairo_rotate(g_pCairoContext, (M_PI / 6.0f) * g_iHours);
  
  rsvg_handle_render_document(g_pSvgHandles[CLOCK_HOUR_HAND], g_pCairoContext, &g_Rectangle, &g_pError);
  
  cairo_restore(g_pCairoContext);
  cairo_save(g_pCairoContext);
  cairo_rotate(g_pCairoContext, (M_PI / 30.0f) * g_iMinutes);
  
  rsvg_handle_render_document(g_pSvgHandles[CLOCK_MINUTE_HAND], g_pCairoContext, &g_Rectangle, &g_pError);
  
  cairo_restore(g_pCairoContext);
  if (g_iEverySecond)
  {
    cairo_save(g_pCairoContext);
    cairo_rotate(g_pCairoContext, (M_PI / 30.0f) * g_iSeconds);
    
    rsvg_handle_render_document(g_pSvgHandles[CLOCK_SECOND_HAND], g_pCairoContext, &g_Rectangle, &g_pError);
    
    cairo_restore(g_pCairoContext);
  }
  cairo_restore(g_pCairoContext);
  
  rsvg_handle_render_document(g_pSvgHandles[CLOCK_FACE_SHADOW], g_pCairoContext, &g_Rectangle, &g_pError);
  rsvg_handle_render_document(g_pSvgHandles[CLOCK_GLASS], g_pCairoContext, &g_Rectangle, &g_pError);
  rsvg_handle_render_document(g_pSvgHandles[CLOCK_FRAME], g_pCairoContext, &g_Rectangle, &g_pError);
  
  cairo_restore(g_pCairoContext);
}

int main(int argc, char** argv)
{
  GtkWidget* pWindow = NULL;
  GdkGeometry hints;
  
  int iElement;
  int i;
  int iTmp;

  for (i = 1; i < argc ; i++)
  {
    if (!strcmp(argv[i], "--seconds"))
    {
      g_iEverySecond = 1;
      continue;
    }
    if (!strcmp(argv[i], "--width"))
    {
      iTmp = atoi(argv[++i]);
      if (iTmp <= MAX_WIDTH && iTmp >= MIN_WIDTH)
        g_iDefaultWidth = iTmp;
      continue;
    }
    if (!strcmp(argv[i], "--height"))
    {
      iTmp = atoi(argv[++i]);
      if (iTmp <= MAX_HEIGHT && iTmp >= MIN_HEIGHT)
        g_iDefaultHeight = iTmp;
      continue;
    }
    if (!strcmp(argv[i], "--help"))
    {
      printf("Usage: %s\n", argv[0]);
      printf("\t--seconds (refresh every second and draw second-hand)\n");
      printf("\t--width <int> (open window with this width)\n");
      printf("\t--height <int> (open window with this height)\n");
      printf("\t--help (this usage-description)\n");
      exit(0);
    }
  }
  gtk_init(&argc, &argv);
  
  for (iElement = 0; iElement < CLOCK_ELEMENTS; iElement++)
  {
    g_pFile = g_file_new_for_path(g_cFileNames[iElement]);
    g_pSvgHandles[iElement] = rsvg_handle_new_from_gfile_sync(g_pFile, RSVG_HANDLE_FLAGS_NONE, NULL, &g_pError);
    g_object_unref(g_pFile);
  };
  
  rsvg_handle_get_dimensions(g_pSvgHandles[CLOCK_DROP_SHADOW], &g_DimensionData);
  g_Rectangle.x = 0.0;
  g_Rectangle.y = 0.0;
  g_Rectangle.width = g_DimensionData.width;
  g_Rectangle.height = g_DimensionData.height;
  pWindow = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_decorated(GTK_WINDOW(pWindow), FALSE);
  gtk_window_set_resizable(GTK_WINDOW(pWindow), TRUE);
  gtk_widget_set_app_paintable(pWindow, TRUE);
  gtk_window_set_icon_from_file(GTK_WINDOW(pWindow), "cairo-clock-icon.png", NULL);
  gtk_window_set_title(GTK_WINDOW(pWindow), "MacSlow's Cairo-Clock");
  gtk_window_set_default_size(GTK_WINDOW(pWindow), g_iDefaultWidth, g_iDefaultHeight);
  hints.min_width = MIN_WIDTH;
  hints.min_height = MIN_HEIGHT;
  hints.max_width = MAX_WIDTH;
  hints.max_height = MAX_HEIGHT;
  hints.min_aspect = (double)g_iDefaultWidth / (double)g_iDefaultHeight;
  hints.max_aspect = (double)g_iDefaultWidth / (double)g_iDefaultHeight;
  gtk_window_set_geometry_hints(GTK_WINDOW(pWindow), pWindow, &hints, GDK_HINT_MIN_SIZE | GDK_HINT_MAX_SIZE | GDK_HINT_ASPECT);
  on_alpha_screen_changed(pWindow, NULL, NULL);
  gtk_widget_add_events(pWindow, GDK_BUTTON_PRESS_MASK);
  g_signal_connect(G_OBJECT(pWindow), "expose-event", G_CALLBACK(on_alpha_window_expose), NULL);
  g_signal_connect(G_OBJECT(pWindow), "key-press-event", G_CALLBACK(on_key_press), NULL);
  g_signal_connect(G_OBJECT(pWindow), "button-press-event", G_CALLBACK(on_button_press), NULL);
  if (!GTK_WIDGET_VISIBLE(pWindow))
    gtk_widget_show_all(pWindow);
  if (g_iEverySecond)
    gtk_timeout_add(SECOND_INTERVAL, (GtkFunction)time_handler, pWindow);
  else
    gtk_timeout_add(MINUTE_INTERVAL, (GtkFunction)time_handler, pWindow);
  g_pCairoContext = gdk_cairo_create(pWindow->window);
  gtk_main();
  
  for (iElement = 0; iElement < CLOCK_ELEMENTS; iElement++)
    g_object_unref(g_pSvgHandles[iElement]);
  
  return 0;
}
