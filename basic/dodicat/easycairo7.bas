
' Cairo examples by dodicat
' http://www.freebasic.net/forum

#include once "cairo\cairo.bi"

#include "easycairo.bas"

dim shared as cairo_t ptr c
dim shared as integer xres,yres

type V3
as single x,y,z
end type

type line
s as v3
e as v3
end type

#define vct type<V3>

operator+(v1 as V3,v2 as V3) as V3
return vct(v1.x+v2.x,v1.y+v2.y,v1.z+v2.z)
end operator
operator-(v1 as V3,v2 as V3) as V3
return vct(v1.x-v2.x,v1.y-v2.y,v1.z-v2.z)
end operator
operator*(f as single,v1 as V3) as V3 
return vct(f*v1.x,f*v1.y,f*v1.z)
end operator
operator*(v1 as V3,f as single) as V3 
return f*v1
end operator

function Length(v as V3) as single
  return Sqr(v.x*v.x+v.y*v.y+v.z*v.z)
end function

function Normalize(v as V3) as V3
  dim n as single=Length(v)
  if n=0 then n=1e-20
  return vct(v.x/n,v.y/n,v.z/n)
end function

function Catmull(p() as V3,t as single) as V3
  return 0.5*( (2*P(2))+_
  (-1*P(1)+P(3))*t+_
  (2*P(1)-5*P(2)+4*P(3)-P(4))*t*t+_
  (-1*P(1)+3*P(2)-3*P(3)+P(4))*t*t*t)
end function

sub FetchCatmull(v() as V3,outarray() as V3,arraysize as integer=1000)
  dim as V3 p(1 to 4)
  redim outarray(0)
  dim as single stepsize=(UBound(v)-1)/(arraysize)
  if stepsize>1 then stepsize=1
  for n as integer=2 to UBound(v)-2
    p(1)=v(n-1):p(2)=v(n):p(3)=v(n+1):p(4)=v(n+2)
    for t as single=0 to 1 step stepsize
      var temp=Catmull(p(),t)
      redim preserve outarray(1 to UBound(outarray)+1)
      outarray(UBound(outarray))=temp
    next t
  next n
end sub

sub drawpoints(a() as V3,col as uinteger,th as single)
  for z as integer=LBound(a)+1 to UBound(a)
    CLine8(c,a(z-1).x,a(z-1).y,a(z).x,a(z).y,th,(c,1,0,0,1),0) 
  next z
end sub

function _Line(p1 as v3,p2 as v3,l as single) as V3
  return vct(p1.x+l*(p2.x-p1.x),p1.y+l*(p2.y-p1.y),p1.z+l*(p2.z-p1.z))
end function

sub BendyLine(p1 as V3,p2 as V3,b as v3,col as uinteger,th as single)
  var lngth=Length(b-p1)+Length(b-p2)
  dim as v3 a(1 to 5)
  var t=_Line(b,p1,1.25):a(1)=vct(t.x,t.y,t.z)
  a(2)=p1:a(3)=b:a(4)=p2
  t=_Line(b,p2,1.25):a(5)=vct(t.x,t.y,t.z)
  redim as v3 c(0)
  FetchCatmull(a(),c(),2*lngth) 
  Drawpoints(c(),col,th) 
end sub

sub DrawBow(L as line,col as uinteger,th as single,aspect as single=1)
  dim as v3 norm=L.e-L.s
  swap norm.x,norm.y
  norm.x=-norm.x
  norm=aspect*Normalize(norm)
  dim as single Ln=Length(L.s-L.e)
  var OffsetPoint=.5*(L.s+L.e)+(Ln/2)*norm
  BendyLine(L.s,L.e,OffsetPoint,col,th)
  CLine8(c,L.s.x,L.s.y,L.e.x,L.e.y,1,(c,1,1,1,1),0)
  var half=.5*(L.s+L.e)
  CCircle9(c,half.x,half.y,5,0,6,1,(c,1,1,1,1),0)
  CCircle9(c,offsetpoint.x,offsetpoint.y,5,0,6,1,(c,1,1,1,1),0)
  CLine8(c,0,yres,xres,0,1,(c,1,1,1,1),0)
  CLine8(c,half.x,half.y,offsetpoint.x,offsetpoint.y,3,(c,0,1,0,1),1)
end sub

xres=600
yres=600
c=SetScreen(xres,yres)
InitFonts(c)

var x1=.1*Xres,x2=.9*Xres
var y1=.1*Yres,y2=.9*Yres

dim as line bow=type<Line>(vct(x1,y1,0),vct(x2,y2,0))
dim as single a
dim as integer fps

do
  a=a+.01
  ScreenLock
  Cls
  CPrint6(c,10,30,"FPS " & fps,30,(c,1,1,1,1))
  DrawBow(bow,4,10,1.1*Sin(a))
  ScreenUnlock
  Sleep Regulate(100,fps),1
loop until Len(Inkey)
