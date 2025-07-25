
' Functions and macros by "dodicat"
' http://www.freebasic.net/forum/memberlist.php?mode=viewprofile&u=682
' http://www.freebasic.net/forum
 
function FrameCounter() as integer
  var t1=Timer,t2=t1
  static as double t3,frames,answer
  frames=frames+1
  if (t2-t3)>=1 then
  t3=t2
  answer=frames
  frames=0
  end if
  return answer
end function

function Regulate(myfps as integer,byref fps as integer) as integer
  fps=FrameCounter
  static as double timervalue
  static as double delta,lastsleeptime,sleeptime
  var k=1/myfps
  if abs(fps-myfps)>1 then
  if fps<myfps then delta=delta-k else delta=delta+k
  end if
  sleeptime=lastsleeptime+((1/myfps)-(Timer-timervalue))*(2000)+delta
  if sleeptime<1 then sleeptime=1
  lastsleeptime=sleeptime
  timervalue=Timer
  return sleeptime
end function

#include once "cairo\cairo.bi"

function SetScreen(xres as integer,yres as integer) as cairo_t ptr
  ScreenRes xres,yres,32
  var surface=cairo_image_surface_create_for_data(ScreenPtr(),CAIRO_FORMAT_ARGB32,xres,yres,xres*4)
  return cairo_create(surface)
end function

#define IntRange(f,l) Int(Rnd*((l+1)-(f))+(f))
#define FloatRange(f,l) (Rnd*((l)-(f))+(f))
#define Map(a,b,x,c,d) ((d)-(c))*((x)-(a))/((b)-(a))+(c)

#macro CCircle8(surf,cx,cy,radius,start,finish,thickness,colour)
cairo_set_line_width(surf,(thickness))
cairo_set_source_rgba colour
cairo_arc(surf,(cx),(cy),(radius),(start),(finish))
cairo_stroke(surf)
#endmacro

#macro CCircle9(surf,cx,cy,radius,start,finish,thickness,colour,capoption)
cairo_set_line_width(surf,(thickness))
cairo_set_source_rgba colour
cairo_arc(surf,(cx),(cy),(radius),(start),(finish))
if capoption then 
  cairo_set_line_cap(surf,CAIRO_LINE_CAP_ROUND)
else
  cairo_set_line_cap(surf,CAIRO_LINE_CAP_SQUARE)
end if
cairo_stroke(surf)
#endmacro

#macro CLine7(surf,x1,y1,x2,y2,thickness,colour)
cairo_set_line_width(surf,thickness)
cairo_set_source_rgba colour
cairo_move_to(surf,x1,y1)
cairo_line_to(surf,x2,y2)
cairo_stroke(surf)
#endmacro

#macro CLine8(surf,x1,y1,x2,y2,thickness,colour,capoption)
cairo_set_line_width(surf,(thickness))
cairo_set_source_rgba colour
cairo_move_to(surf,(x1),(y1))
cairo_line_to(surf,(x2),(y2))
if capoption then 
  cairo_set_line_cap(surf,CAIRO_LINE_CAP_ROUND)
else
  cairo_set_line_cap(surf,CAIRO_LINE_CAP_SQUARE)
end if
cairo_stroke(surf)
#endmacro

#macro CPrint6(surf,x,y,text,size,colour)
cairo_set_font_size (surf,(size))
cairo_move_to (surf,(x)-(_text.width/2+_text.x_bearing),(y)+(_text.height/2)-_fonts.descent)
cairo_set_source_rgba colour
cairo_show_text(surf,(text))
#endmacro

#macro CPrint8(surf,x,y,text,size,colour,fontname,style)
cairo_select_font_face (surf,fontname,style,CAIRO_FONT_WEIGHT_NORMAL)
cairo_set_font_size (surf,(size))
cairo_move_to (surf,(x)-(_text.width/2+_text.x_bearing),(y)+(_text.height/2)-_fonts.descent)
cairo_set_source_rgba colour
cairo_show_text(surf,text)
#endmacro

#macro CRectangle(surf,x,y,wide,high,thickness,colour)
cairo_set_line_width(surf,(thickness))
cairo_set_source_rgba colour
cairo_move_to(surf,(x),(y))
cairo_rectangle(surf,(x),(y),(wide),(high))
cairo_stroke(surf)
#endmacro

#macro InitFonts(surf)
dim as cairo_font_extents_t _fonts 
cairo_font_extents(surf,@_fonts)
dim as cairo_text_extents_t _text
#endmacro

#macro SetBackgroundColour(colour)
cairo_set_source_rgba colour
cairo_paint(c)
#endmacro
