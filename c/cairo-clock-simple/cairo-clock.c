
/*
 * cairo-clock.c
 *
 * Version simplifiée de cairo-clock.c par "MacSlow"
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

#define SECOND_INTERVAL 1000
#define MINUTE_INTERVAL 60000
#define MIN_WIDTH 32
#define MIN_HEIGHT 32
#define MAX_WIDTH 512
#define MAX_HEIGHT 512

int g_iSeconds;
int g_iMinutes;
int g_iHours;
static time_t g_timeOfDay;
struct tm* g_pTime;
int g_iEverySecond   =   0; /* 1/0 - draw/don't draw seconds */
int g_iDefaultWidth  = 256; /* window opens with this width  */
int g_iDefaultHeight = 256; /* ... and with this height      */

int g_iSaveImage = 0;

void render(cairo_t *a_pCairoContext, int width, int height);

static gboolean time_handler(GtkWidget* pWidget)
{
  gtk_widget_queue_draw(pWidget);
  return TRUE;
}

static gboolean on_alpha_window_expose(GtkWidget* pWidget, GdkEventExpose* pExpose)
{
  static gint iWidth;
  static gint iHeight;
  cairo_t* l_pCairoContext;
  
  l_pCairoContext = gdk_cairo_create(pWidget->window);
  cairo_set_operator(l_pCairoContext, CAIRO_OPERATOR_SOURCE);
  gtk_window_get_size(GTK_WINDOW(pWidget), &iWidth, &iHeight);
  render(l_pCairoContext, iWidth, iHeight);
  
  /* Enregistrement d'une image pour servir d'icône à l'application */
  if (g_iSaveImage)
  {
    cairo_surface_write_to_png(cairo_get_target(l_pCairoContext), "image.png");
    g_iSaveImage = 0;
  }
  
  cairo_destroy(l_pCairoContext);
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

void render(cairo_t *a_pCairoContext, int width, int height)
{
  int i;
  
  time(&g_timeOfDay);
  g_pTime = localtime(&g_timeOfDay);
  
  printf("%02d:%02d:%02d render(%d, %d)\n", g_pTime->tm_hour, g_pTime->tm_min, g_pTime->tm_sec, width, height);
  
  g_iSeconds = g_pTime->tm_sec;
  g_iMinutes = g_pTime->tm_min;
  g_iHours = g_pTime->tm_hour;
  g_iHours = g_iHours >= 12 ? g_iHours - 12 : g_iHours;
  
  cairo_save(a_pCairoContext);

  cairo_scale(a_pCairoContext, width / 28, height / 28);
  cairo_translate(a_pCairoContext, 14, 14);
  cairo_rotate(a_pCairoContext, M_PI);
  
  /* Fond transparent de l'image */
  cairo_set_source_rgba(a_pCairoContext, 1, 1, 1, 0);
  cairo_set_operator(a_pCairoContext, CAIRO_OPERATOR_SOURCE);
  cairo_paint(a_pCairoContext);
  cairo_set_operator(a_pCairoContext, CAIRO_OPERATOR_OVER);
  
  /* Dessin du cadran */
  cairo_save(a_pCairoContext);
  cairo_arc(a_pCairoContext, 0, 0, 13, 0, 2 * M_PI);
  cairo_set_source_rgb(a_pCairoContext, 0.9, 0.9, 0.9);
  cairo_fill_preserve(a_pCairoContext);
  cairo_set_source_rgb(a_pCairoContext, 0.5, 0.5, 0.5);
  cairo_set_line_width(a_pCairoContext, 1);
  cairo_stroke(a_pCairoContext);
  for (i = 0; i < 12 ; i++)
  {
    cairo_save(a_pCairoContext);
    cairo_translate(a_pCairoContext, 11, 0);
    cairo_arc(a_pCairoContext, 0, 0, 0.5, 0, 2 * M_PI);
    cairo_fill(a_pCairoContext);
    cairo_restore(a_pCairoContext);
    cairo_rotate(a_pCairoContext, M_PI / 6);
  }
  cairo_restore(a_pCairoContext);
  
  /* Aiguille des heures */
  cairo_save(a_pCairoContext);
  cairo_rotate(a_pCairoContext, (M_PI / 6) * g_iHours + (M_PI / 180) * g_iMinutes);
  cairo_set_line_cap(a_pCairoContext, CAIRO_LINE_CAP_ROUND); 
	cairo_move_to(a_pCairoContext, 0, 0);
  cairo_line_to(a_pCairoContext, 0, 9);
  cairo_set_line_width(a_pCairoContext, 1);
  cairo_set_source_rgba(a_pCairoContext, 0, 0, 1, 0.4);
	cairo_stroke(a_pCairoContext);
  cairo_restore(a_pCairoContext);
  
  /* Aiguille des minutes */
  cairo_save(a_pCairoContext);
  cairo_rotate(a_pCairoContext, (M_PI / 30) * g_iMinutes);
	cairo_move_to(a_pCairoContext, 0, 0);
  cairo_line_to(a_pCairoContext, 0, 10);
  cairo_set_line_cap(a_pCairoContext, CAIRO_LINE_CAP_ROUND);
  cairo_set_line_width(a_pCairoContext, 1);
  cairo_set_source_rgba(a_pCairoContext, 0, 0, 1, 0.4);
	cairo_stroke(a_pCairoContext);
  cairo_restore(a_pCairoContext);
  
  /* Aiguille des secondes */
  if (g_iEverySecond)
  {
    cairo_save(a_pCairoContext);
    cairo_arc(a_pCairoContext, 0, 0, 0.3, 0, 2 * M_PI);
    cairo_set_source_rgba(a_pCairoContext, 0.5, 0, 0, 1);
    cairo_fill(a_pCairoContext);
    cairo_rotate(a_pCairoContext, (M_PI / 30) * g_iSeconds);
    cairo_move_to(a_pCairoContext, 0, 0);
    cairo_line_to(a_pCairoContext, 0, 11);
    cairo_set_line_cap(a_pCairoContext, CAIRO_LINE_CAP_ROUND);
    cairo_set_line_width(a_pCairoContext, 0.3);
    cairo_stroke(a_pCairoContext);
    cairo_restore(a_pCairoContext);
  }
  
  cairo_restore(a_pCairoContext);
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

  pWindow = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_decorated(GTK_WINDOW(pWindow), FALSE);
  gtk_window_set_resizable(GTK_WINDOW(pWindow), TRUE);
  gtk_widget_set_app_paintable(pWindow, TRUE);
  gtk_window_set_icon_from_file(GTK_WINDOW(pWindow), "cairo-clock-icon.png", NULL);
  gtk_window_set_title(GTK_WINDOW(pWindow), "Simple Cairo Clock");
  gtk_window_set_default_size(GTK_WINDOW(pWindow), g_iDefaultWidth, g_iDefaultHeight);
  hints.min_width  = MIN_WIDTH;
  hints.min_height = MIN_HEIGHT;
  hints.max_width  = MAX_WIDTH;
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
  gtk_main();
  return 0;
}
