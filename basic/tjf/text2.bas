
' http://www.freebasic.net/forum/viewtopic.php?p=196719#p196719

#define CAIRO_HAS_PDF_SURFACE 1
#define CAIRO_HAS_PS_SURFACE 1
#define CAIRO_HAS_SVG_SURFACE 1

#include once "cairo\cairo.bi"
#include once "cairo\cairo-pdf.bi"
#include once "cairo\cairo-ps.bi"
#include once "cairo\cairo-svg.bi"

'{612, 792},     /* HPDF_PAGE_SIZE_LETTER */
'{612, 1008},    /* HPDF_PAGE_SIZE_LEGAL */
'{841.89, 1199.551},    /* HPDF_PAGE_SIZE_A3 */
'{595.276, 841.89},     /* HPDF_PAGE_SIZE_A4 */
'{419.528, 595.276},     /* HPDF_PAGE_SIZE_A5 */
'{708.661, 1000.63},     /* HPDF_PAGE_SIZE_B4 */
'{498.898, 708.661},     /* HPDF_PAGE_SIZE_B5 */
'{522, 756},     /* HPDF_PAGE_SIZE_EXECUTIVE */
'{288, 432},     /* HPDF_PAGE_SIZE_US4x6 */
'{288, 576},     /* HPDF_PAGE_SIZE_US4x8 */
'{360, 504},     /* HPDF_PAGE_SIZE_US5x7 */
'{297, 684}      /* HPDF_PAGE_SIZE_COMM10 */

const SCR_W = 595.276
const SCR_H = 841.89

sub links(byval c as cairo_t ptr, byval x as double, byval y as double, byref t as string)
  cairo_move_to(c, x, y)
  cairo_show_text(c, t)
end sub

sub mitte(byval c as cairo_t ptr, byval x as double, byval y as double, byval b as double, byref t as string)
  dim as cairo_text_extents_t extents
  cairo_text_extents(c, t, @extents)
  cairo_move_to(c, x + b/2-(extents.width/2 + extents.x_bearing), y)
  cairo_show_text(c, t)
end sub

sub rechts(byval c as cairo_t ptr, byval x as double, byval y as double, byval b as double, byref t as string)
  dim as cairo_text_extents_t extents
  cairo_text_extents(c, t, @extents)
  cairo_move_to(c, x + b - extents.width - extents.x_bearing, y)
  cairo_show_text(c, t)
end sub

' Bild aufbauen und ausgeben
sub build_page(byval cs as cairo_surface_t ptr)
  dim as cairo_t ptr c = cairo_create(cs)
  dim as string t, Page_Title = "Gedichte - ihr Wichte!"
  dim as double x = 50, y = 50, b = SCR_W - 100

  cairo_rectangle(c, 0.0, 0.0, SCR_W, SCR_H)
  cairo_set_source_rgb(c, 1.0, 1.0, 1.0)
  cairo_fill(c)

  cairo_set_source_rgb(c, 0.0, 0.0, 0.0)
  cairo_set_line_width(c, 0.5)
  cairo_rectangle(c, x, y + 10, b, SCR_H - 110)
  cairo_stroke(c)

  cairo_select_font_face(c, "Arial", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
  cairo_set_font_size(c, 24.0)
  mitte(c, x, y, b, Page_Title)

  t = "Dieser Text soll am linken Rand stehen"
  cairo_select_font_face(c, "Times", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
  cairo_set_font_size(c, 16.0)

  y = 100 : mitte(c, x, y, b, "Das Meer ist weit, das Meer ist blau,")
  y += 20 : mitte(c, x, y, b, "im Wasser schwimmt ein Kabeljau.")
  y += 20 : mitte(c, x, y, b, "Da kümmt ein Hai von ungefähr,")
  y += 20 : mitte(c, x, y, b, "ich glaub von links, ich weiß nicht mehr -")
  y += 20 : mitte(c, x, y, b, "verschlingt den Fisch mit Haut und Haar,")
  y += 20 : mitte(c, x, y, b, "das ist zwar traurig, aber wahr.")
  y += 20 : mitte(c, x, y, b, "Das Meer ist weit, das Meer ist blau,")
  y += 20 : mitte(c, x, y, b, "im Wasser schwimmt kein Kabeljau.")

  y = 400 : links(c, x, y, "Als sie den Ritter Fibs im Jahr")
  y += 20 : links(c, x, y, "elfhundertsiebenzehn gebahr,")
  y += 20 : links(c, x, y, "zog die Mama dem kleinen Mann,")
  y += 20 : links(c, x, y, "als erstes eine Rüstung an,")
  y += 20 : links(c, x, y, "die sie des nachts und oft ermüdet,")
  y += 20 : links(c, x, y, "für ihn gelötet und geschmiedet,")
  y += 20 : links(c, x, y, "damit er gegen allerlei,")
  y += 20 : links(c, x, y, "Gefahren wohl gerüstet sei.")
  cairo_select_font_face(c, "Times", CAIRO_FONT_SLANT_ITALIC, CAIRO_FONT_WEIGHT_BOLD)
  y += 30 : links(c, x, y, "Schlußfolgerung:")
  cairo_select_font_face(c, "Times", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
  y += 20 : links(c, x, y, "Die Rüstung muß, ist man noch klein,")
  y += 20 : links(c, x, y, "besonders unten rostfrei sein.")

  y = 618 : rechts(c, x, y, b, "Hinter den Gardinen sehen")
  y += 20 : rechts(c, x, y, b, "wir erstaunt Sardinen gehen.")
  cairo_select_font_face(c, "Times", CAIRO_FONT_SLANT_ITALIC, CAIRO_FONT_WEIGHT_NORMAL)
  y += 30 : rechts(c, x, y, b, "Nach dem Sturmtief")
  y += 20 : rechts(c, x, y, b, "stand der Turm schief.")
  cairo_select_font_face(c, "Times", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
  y += 30 : rechts(c, x, y, b, "Hast du zu viel Geld da liegen")
  y += 20 : rechts(c, x, y, b, "kauf dir Hühnchen, laß sie fliegen.")
  cairo_select_font_face(c, "Times", CAIRO_FONT_SLANT_ITALIC, CAIRO_FONT_WEIGHT_NORMAL)
  y += 30 : rechts(c, x, y, b, "Bist du des Lebens nicht mehr froh,")
  y += 20 : rechts(c, x, y, b, "so stürze dich in H<sub>2</sub>O.")

  cairo_show_page(c)
  cairo_destroy(c)
end sub

' Schreibt eine PDF-Datei
sub write_pdf(byref fname as string)
  dim as cairo_surface_t ptr cs = cairo_pdf_surface_create(fname, SCR_W, SCR_H)
  build_page(cs)
  cairo_surface_flush(cs)
  cairo_surface_destroy(cs)
end sub

' Schreibt eine PS-Datei
sub write_ps(byref fname as string)
  dim as cairo_surface_t ptr cs = cairo_ps_surface_create(fname, SCR_W, SCR_H)
  build_page(cs)
  cairo_surface_flush(cs)
  cairo_surface_destroy(cs)
end sub

' Schreibt eine SVG-Datei
sub write_svg(byref fname as string)
  dim as cairo_surface_t ptr cs = cairo_svg_surface_create(fname, SCR_W, SCR_H)
  build_page(cs)
  cairo_surface_flush(cs)
  cairo_surface_destroy(cs)
end sub

' Gibt Bild auf Schirm aus
sub write_screen()
  dim as integer S_W = int(SCR_W) + 1, S_H = int(SCR_H) + 1
  screenres S_W, S_H, 32
  screenlock
  dim as cairo_surface_t ptr cs = _
         cairo_image_surface_create_for_data(screenptr, _
                                             CAIRO_FORMAT_ARGB32, S_W, _
                                             S_H, S_W*len(integer))
  build_page(cs)
  screenunlock
end sub


' Hauptprogramm / main program

write_pdf("text2.pdf")
write_ps("text2.ps")
write_svg("text2.svg")
write_screen()
sleep
