
' Cairo examples by dodicat
' http://www.freebasic.net/forum

#include once "cairo\cairo.bi"

#include "easycairo.bas"

dim shared as integer xres=1024,yres=768
dim as cairo_t ptr c=SetScreen(xres,yres)
InitFonts(c)

dim as integer pitch
Color,RGB(0,0,50)
ScreenInfo xres,yres,,,pitch

dim as any pointer row=ScreenPtr
dim as uinteger pointer pixel

type V3
  as single x,y,z
  as uinteger col
end type

type particle
  as V3 position,velocity
  as single t
end type

#define vct type<V3>

operator +(v1 as V3,v2 as V3) as V3
  return vct(v1.x+v2.x,v1.y+v2.y,v1.z+v2.z)
end operator

operator -(v1 as V3,v2 as V3) as V3
  return vct(v1.x-v2.x,v1.y-v2.y,v1.z-v2.z)
end operator

operator *(f as single,v1 as V3) as V3 
  return vct(f*v1.x,f*v1.y,f*v1.z)
end operator

operator *(v1 as V3,f as single) as V3 
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

#define OnScreen(_x,_y) ((_x)>=0)*((_x)<xres-1)*((_y)>=0)*((_y)<yres-1)

#macro PPSet(_x,_y,colour)
pixel=row+pitch*(_y)+4*(_x)
*pixel=(colour)
#endmacro

#macro SetPoints()
num=IntRange(20,30)
redim in(1 to num)
in(1)=first
in(2)=2*first
for n as integer=3 to num-3
in(n)=type<V3>(IntRange(.3*xres,.7*xres),IntRange(.3*yres,.7*yres),IntRange(-400,400))
next n
in(num-2)=in(1)
in(num-1)=in(2)
in(num)=in(3)
redim a(0) 
FetchCatmull(in(),a(),2000)
#endmacro

function Catmull(p() as V3,t as single) as V3
  return 0.5*( (2*P(2))+_
  (-1*P(1)+P(3))*t+_
  (2*P(1)-5*P(2)+4*P(3)-P(4))*t^2+_
  (-1*P(1)+3*P(2)-3*P(3)+P(4))*t^3)
end function

sub FetchCatmull(v() as V3,outarray() as V3,arraysize as integer=1000)
  dim as V3 p(1 to 4)
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

function Rotate3D(byval pivot as v3,byval pt as v3,byval Angle as v3,byval scale as v3=type<v3>(1,1,1)) as v3
  #define cr 0.0174532925199433
  Angle=type<v3>(Angle.x*cr,Angle.y*cr,Angle.z*cr)
  #macro Rotate(a1,a2,b1,b2,d)
  temp=type<v3>((a1)*Cos(Angle.d)+(a2)*Sin(Angle.d),(b1)*Cos(Angle.d)+(b2)*Sin(Angle.d))
  #endmacro
  dim as v3 p=type<v3>(pt.x-pivot.x,pt.y-pivot.y,pt.z-pivot.z)
  dim as v3 rot,temp
  Rotate(p.y,-p.z,p.z,p.y,x)
  rot.y=temp.x:rot.z=temp.y 
  p.y=rot.y:p.z=rot.z 
  Rotate(p.z,-p.x,p.x,p.z,y)
  rot.z=temp.x:rot.x=temp.y
  p.x=rot.x
  Rotate(p.x,-p.y,p.y,p.x,z)
  rot.x=temp.x:rot.y=temp.y
  return type<v3>((scale.x*rot.x+pivot.x),(scale.y*rot.y+pivot.y),(scale.z*rot.z+pivot.z))
end function

function ApplyPerspective(p as V3,eyepoint as V3) as V3 
  dim as single w=1-(p.z/eyepoint.z)
  return type<V3>((p.x-eyepoint.x)/w+eyepoint.x,(p.y-eyepoint.y)/w+eyepoint.y,(p.z-eyepoint.z)/w+eyepoint.z)
end function

sub Ball(cx as double,cy as double,radius as double,col() as uinteger,offsetX as double=0,offsetY as double=0,e as double=0,resolution as double=32,im as any pointer=0)
  dim as integer red,green,blue,r,g,b
  dim as double ox,oy,nx,ny 
  ox=cx+offsetX*radius
  oy=cy+offsetY*radius
  red=col(1):green=col(2):blue=col(3)
  for d as double=radius to 0 step-radius/resolution
    nx=(cx-ox)*(d-radius)/radius+cx 
    ny=(cy-oy)*(d-radius)/radius+cy
    r=-red*(d/radius-1)
    g=-green*(d/radius-1)
    b=-blue*(d/radius-1)
    circle im,(nx,ny),d,RGB(r,g,b),,,e,F
  next d
end sub

sub DrawArrayPoints(a() as V3,col as uinteger,ydisp as integer=0)
  dim as V3 temp
  temp=ApplyPerspective(a(LBound(a)),type<V3>(xres/2,yres/2,600))
  pset(temp.x,temp.y+ydisp),col
  for z as integer=LBound(a)+1 to UBound(a)
    temp=ApplyPerspective(a(z),type<V3>(xres/2,yres/2,600))
    Line-(temp.x,temp.y+ydisp),col
  next z
end sub

sub SetColour(pts as V3 pointer)
  dim as integer count
  dim as integer r,g,b
  for y as integer=0 to yres-1
    for x as integer=0 to xres-1
      r=IntRange(0,255)
      g=IntRange(0,155)
      b=IntRange(0,155)
      pts[count].col=RGB(r,g,b)
      count=count+1
    next x
  next y
end sub

sub SetVelocity(p as particle pointer,numpoints as integer)
  for z as integer=0 to numpoints
    var f=FloatRange(0,2)
    p[z].velocity=f*type<V3>(FloatRange(-1,1),FloatRange(-1,1),FloatRange(-1,1))
  next z 
end sub

dim as integer max=xres*yres
dim as integer numpoints=50000
dim XY as V3 ptr=new V3[max]
dim p as particle pointer=new particle[numpoints]
dim as integer inc=1,temp,num
redim as V3 in(),a()
dim as V3 first=type<V3>(.1*xres,.2*yres,100)
dim as integer mx,my,mz,lastmx,lastmy,lastmz,flag,curveflag,lastaz
dim as string i
dim as v3 pivot=type<v3>(xres/2,yres/2,0)
dim as v3 eyepoint=type<v3>(xres/2,yres/2,900)
dim as v3 earth=type<v3>(xres/2-300,yres/2-100,0)
dim as v3 moonearth=type<v3>(2,0,0)
dim as v3 angle
dim as v3 newearth,newmoon
dim as single earthradius,moonradius,dx,dy
dim as integer flag2,colour(1 to 3)

angle.x=90
SetPoints()
SetColour(XY)
SetVelocity(p,numpoints)
dim as integer fps,stime

do
  angle.y=angle.y+.1
  angle.x=angle.x+.1
  mx=a(inc).x:my=a(inc).y:mz=a(inc).z
  var mouse=type<V3>(lastmx-mx,lastmy-my,lastmz-mz)
  temp=temp+20
  if temp>=numpoints-1 then temp=numpoints-1
  i=inkey
  if i="1" then flag=1
  if i="2" then flag=0
  if flag then stime=Regulate(33,fps) else stime=Regulate(200,fps)
  ScreenLock
  Cls
  newearth=Rotate3D(pivot,earth,angle)
  newmoon=Rotate3D(newearth,newearth+earthradius*moonearth,4.5*angle)
  if newmoon.z<newearth.z then flag2=1 else flag2=0
  earthradius=Map(-300,300,newearth.z,10,90)
  moonradius=Map(-300,300,newmoon.z,2,18)
  newearth=ApplyPerspective(newearth,eyepoint)
  newmoon=ApplyPerspective(newmoon,eyepoint)
  select case as const flag2
    case 0
      colour(1)=0:colour(2)=200:colour(3)=0
      dx=Map(0,xres,newearth.x,.8,-.8)
      Ball(newearth.x,newearth.y,earthradius,colour(),.6,-.5)
      colour(1)=100:colour(2)=100:colour(3)=0
      Ball(newmoon.x,newmoon.y,moonradius,colour(),.6,-.5)
    case 1
      colour(1)=100:colour(2)=100:colour(3)=0
      Ball(newmoon.x,newmoon.y,moonradius,colour(),.6,-.5)
      colour(1)=0:colour(2)=200:colour(3)=0
      Ball(newearth.x,newearth.y,earthradius,colour(),.6,-.5)
  end select
  colour(1)=200:colour(2)=90:colour(3)=0
  Ball(pivot.x,pivot.y,20,colour(),.6,-.5) 
  colour(1)=200:colour(2)=200:colour(3)=200
  if curveflag then DrawArrayPoints(a(),RGB(200,0,0))
  var rad=Map(-400,400,a(inc).z,3,10)
  if lastaz>a(inc).z then
    var c=a(inc)
    c=ApplyPerspective(c,type<V3>(xres/2,yres/2,600))
    Ball(c.x,c.y,rad,colour(),.6,-.5)
  end if
  for z as integer=0 to temp
    p[z].t=p[z].t+.1
    var vel=p[z].velocity+mouse
    p[z].position=p[z].position+vel
    var pzp=p[z].position+type<V3>(mx,my,mz)
    pzp=ApplyPerspective(pzp,type<V3>(xres/2,yres/2,600))
    if OnScreen((pzp.x),(pzp.y)) then
      PPSet(cint(pzp.x),cint(pzp.y),XY[z].col) 
    end if
    if p[z].t> FloatRange(5,15) then
    p[z].position=XY[IntRange(0,max)]:p[z].t=0
    end if
  next z
  if lastaz<=a(inc).z then 
    var c=a(inc)
    c=ApplyPerspective(c,type<V3>(xres/2,yres/2,600))
    Ball(c.x,c.y,rad,colour(),.6,-.5)
  end if
  if i="3" then curveflag=1
  if i="4" then curveflag=0
  CPrint6(c,10,30,"FPS " & fps,20,(c,1,0,0,1))
  CPrint6(c,10,50,"Emission state " & temp & " of " & numpoints-1,15,(c,1,1,1,1))
  CPrint6(c,10,80,"Press 1 for 33 frames/second",20,(c,0,1,0,1))
  CPrint6(c,10,110,"Press 2 for default frames/second",20,(c,0,1,0,1))
  CPrint6(c,10,150,"Press 3 for probe trajectory",15,(c,0,1,1,1))
  CPrint6(c,10,180,"Press 4 to hide trajectory",15,(c,0,1,1,1))
  CPrint6(c,10,220,"Location ANDROMIDA D outer Galaxy",20,(c,0,1,.5,1))
  CPrint6(c,10,250,"Probe type L. Mercury 3000",20,(c,0,1,.5,1))
  CPrint6(c,10,290,"Log Date: 15.58773 Eons absolute",20,(c,1,1,.5,1))
  CPrint6(c,10,330,"Comment: Dwarf system believed type Beta 3",25,(c,1,1,1,1))
  ScreenUnlock
  Sleep stime,1
  lastaz=a(inc).z
  inc=inc+1
  if inc>=UBound(a) then 
    inc=1
    SetPoints()
  end if
  lastmx=mx:lastmy=my:lastmz=mz
loop until i=chr(27)

delete[] XY
delete[] p
