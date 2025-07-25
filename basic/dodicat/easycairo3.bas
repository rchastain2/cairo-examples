
' Cairo examples by dodicat
' http://www.freebasic.net/forum

#include once "cairo\cairo.bi"

#include "easycairo.bas"

type segment
  as integer x,y,lngth
  as single a,inc,th
  as double rd,gr,bl,alph
end type

const PI=3.14159265358979323846

#macro DrawSegment(surf,x,y,angle,Length,th,col,opt)
CLine8(surf,x,y,(x+Length*Cos(angle)),(y-Length*Sin(angle)),th,col,opt)
CLine8(surf,x,y,(x+Length*Cos(angle+pi)),(y-Length*Sin(angle+pi)),th,col,opt)
#endmacro

dim as integer xres=800,yres=600
dim as cairo_t ptr c=SetScreen(xres,yres)

const numsegments=100
dim as segment s(1 to numsegments)

for n as integer=1 to numsegments
  dim as integer i
  with s(n)
    .x=IntRange(0,xres)
    .y=IntRange(0,yres)
    .a=IntRange(0,2*pi)
    .th=FloatRange(1,8)
    .lngth=IntRange(5,200)
    .rd=FloatRange(0,1)
    .gr=FloatRange(0,1)
    .bl=FloatRange(0,1)
    .alph=FloatRange(.75,1)
    do
      i=IntRange(-1,1)
    loop until i <> 0
    .inc=i*FloatRange(.001,.009)
  end with
next n

do
  ScreenLock
  Cls
  SetBackgroundColour((c,1,1,1,1))
  for n as integer=LBound(s) to UBound(s)
    s(n).a=s(n).a+s(n).inc
    DrawSegment(c,s(n).x,s(n).y,(s(n).a),s(n).lngth,s(n).th,(c,s(n).rd,s(n).gr,s(n).bl,s(n).alph),1) 
  next n
  ScreenUnlock
  Sleep 1,1
loop until Len(Inkey)
