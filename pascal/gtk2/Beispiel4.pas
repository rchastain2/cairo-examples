
(* http://www.bildungsgueter.de/RaspberryIntro/Pages/Pascal01Seite006.htm *)

program Beispiel;

uses
  gtk2,
  gdk2,
  glib2,
  cairo;

var
  window: pGtkWidget;
  adjustment: pGtkObject;
  regler, paintArea: pGtkWidget;
  box: pGtkWidget;
  wert: gfloat;

procedure destroy(widget: pGtkWidget; data: gpointer); cdecl;
begin
  gtk_main_quit();
end;

function delete_event(widget: pGtkWidget; event: pGdkEvent; data: gpointer): gint; cdecl;
var
  dialog: pGtkWidget;
  antwort: gint;
begin
  dialog := gtk_message_dialog_new(
    GTK_WINDOW(window),
    GTK_DIALOG_DESTROY_WITH_PARENT,
    GTK_MESSAGE_QUESTION,
    GTK_BUTTONS_YES_NO,
    'Soll das Fenster nun geschlossen werden?'
  );
  gtk_window_set_title(GTK_WINDOW(dialog), 'Schliessen');
  antwort := gtk_dialog_run(GTK_DIALOG(dialog));
  gtk_widget_destroy(dialog);

  if antwort = GTK_RESPONSE_YES then
    delete_event := 0
  else
    delete_event := 1;
end;

procedure on_value_changed(scale: pGtkObject; arg: gpointer);
var
  adj: pGtkAdjustment;
begin
  adj := gtk_range_get_adjustment(GTK_RANGE(scale));
  wert := gtk_adjustment_get_value(adj);
  gtk_widget_queue_draw(paintArea);
end;

function paintStroke(widget: pGtkWidget; event: pGdkEventExpose; arg: gpointer): gint;
var
  context: Pcairo_t;
begin
  context := gdk_cairo_create(widget^.window);
  cairo_set_line_cap(context, CAIRO_LINE_CAP_ROUND); // BUTT  SQUARED
  cairo_set_source_rgb(context, 1, 0, 0);
  cairo_set_line_width(context, wert);
  cairo_move_to(context, 20, 20);
  cairo_line_to(context,
    widget^.allocation.width - 20,
    widget^.allocation.height - 20);
  if wert > 3.0 then
  begin
    cairo_stroke_preserve(context);
    cairo_set_source_rgb(context, 1, 1, 1);
    cairo_set_line_width(context, 1);
  end;
  cairo_stroke(context);
  cairo_destroy(context);
  paintStroke := 0;
end;

begin
  gtk_init(@argc, @argv);
  wert := 3.0;
  window := gtk_window_new(GTK_WINDOW_TOPLEVEL);

  gtk_container_set_border_width(GTK_CONTAINER(window), 8);
  gtk_widget_set_size_request(window, 160, 180);

  adjustment := gtk_adjustment_new(wert, 1.0, 31.0, 1.0, 1.0, 1.0);
  regler := gtk_vscale_new(GTK_ADJUSTMENT(adjustment));
  gtk_scale_set_draw_value(GTK_SCALE(regler), False);
  gtk_range_set_inverted(GTK_RANGE(regler), True);
  paintArea := gtk_drawing_area_new();

  box := gtk_hbox_new(False, 2);

  gtk_signal_connect(
    GTK_OBJECT(window),
    'delete_event',
    GTK_SIGNAL_FUNC(@delete_event),
    nil
  );
  gtk_signal_connect(
    GTK_OBJECT(window),
    'destroy',
    GTK_SIGNAL_FUNC(@destroy),
    nil
  );
  gtk_signal_connect(
    GTK_OBJECT(regler),
    'value_changed',
    GTK_SIGNAL_FUNC(@on_value_changed),
    gpointer(paintArea)
  );
  gtk_signal_connect(
    GTK_OBJECT(paintArea),
    'expose_event',
    GTK_SIGNAL_FUNC(@paintStroke),
    gpointer(adjustment)
  );

  gtk_box_pack_start(GTK_BOX(box), regler, FALSE, FALSE, 0);
  gtk_box_pack_start(GTK_BOX(box), paintArea, TRUE, TRUE, 0);
  gtk_container_add(GTK_CONTAINER(window), box);
  gtk_widget_show(paintArea);
  gtk_widget_show(regler);
  gtk_widget_show(box);
  gtk_widget_show(window);
  gtk_main();
end.
