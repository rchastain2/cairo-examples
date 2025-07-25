
' Cairo examples by dodicat
' http://www.freebasic.net/forum

#include once "cairo\cairo.bi"

#include "easycairo.bas"

const PI=3.14159265358979323846

dim as integer xres,yres
ScreenInfo xres,yres

dim as cairo_t ptr c=SetScreen(xres,yres)
SetBackgroundColour((c,1,1,1,1))

do
  ScreenLock
  var rd=FloatRange(0,1),gr=FloatRange(0,1),bl=FloatRange(0,1)
  var th=IntRange(1,50)
  CLine8(c,IntRange(0,xres),IntRange(0,yres),IntRange(0,xres),IntRange(0,yres),th,(c,rd,gr,bl,1),1)
  CCircle8(c,IntRange(0,xres),IntRange(0,yres),IntRange(10,200),0,(2*PI),IntRange(1,10),(c,bl,gr,rd,1))
  ScreenUnlock
  Sleep 1,1
loop until Len(Inkey)

cairo_destroy(c)
