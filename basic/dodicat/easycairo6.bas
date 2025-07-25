
' Cairo examples by dodicat
' http://www.freebasic.net/forum

#include once "cairo\cairo.bi"

#include "easycairo.bas"

#define normal CAIRO_FONT_SLANT_NORMAL
#define italic CAIRO_FONT_SLANT_ITALIC

dim as integer xres=800,yres=600
dim shared as cairo_t ptr c
c=SetScreen(xres,yres)
SetBackgroundColour((c,1,1,1,1))
InitFonts(c)

type d2
  as single x,y,z
  #define vct type<d2>
  #define dot *
  #define cross ^
end type

operator +(v1 as d2,v2 as d2) as d2
  return type<d2>(v1.x+v2.x,v1.y+v2.y,v1.z+v2.z)
end operator

operator -(v1 as d2,v2 as d2) as d2
  return type<d2>(v1.x-v2.x,v1.y-v2.y,v1.z-v2.z)
end operator

operator *(f as single,v1 as d2) as d2 
  return vct(f*v1.x,f*v1.y,f*v1.z)
end operator

operator *(v1 as d2,v2 as d2) as single 
  return v1.x*v2.x+v1.y*v2.y+v1.z*v2.z
end operator

operator ^(v1 as d2,v2 as d2) as d2
  return type<d2>(v1.y*v2.z-v2.y*v1.z,-(v1.x*v2.z-v2.x*v1.z),v1.x*v2.y-v2.x*v1.y)
end operator

function Length(v as d2) as single
  return Sqr(v.x*v.x+v.y*v.y+v.z*v.z)
end function

function Normalize(v as d2) as d2
  dim n as single=Length(v)
  return type<d2>(v.x/n,v.y/n,v.z/n)
end function

function Pendulum(cx as integer,cy as integer,lngth as integer,radius as integer,diff as single,rate as single,col as uinteger,damper as single=0) as integer
  dim as d2 ctr=vct(cx,cy)
  static ang as single
  static damp as single
  #define Red(c) ((c) shr 16 and 255)
  #define Green(c) ((c) shr 8 and 255)
  #define Blue(c) ((c) and 255)
  #define Alph(c) ((c) shr 24)
  dim as single rd=Red(col)/255,gr=Green(col)/255,bl=Blue(col)/255,al=Alph(col)/255
  damp=damp+damper
  dim as single lrate=Sqr(lngth),pie2=6.283185307179586
  ang=ang+rate
  dim as single Lang=ang/lrate
  var x=cx+lngth*Cos(Lang)
  var y=cy+lngth+damp
  dim as d2 rod=vct(x,y)-ctr
  rod=Normalize(rod)
  rod=lngth*rod
  dim as d2 bobpos=ctr+rod
  CLine8(c,ctr.x,ctr.y,bobpos.x,bobpos.y,.01*lngth,(c,rd/2,gr/2,bl/2,al),1)
  var a=atan2(ctr.y-bobpos.y,ctr.x-bobpos.x):a=a+pie2/4
  CCircle9(c,bobpos.x,bobpos.y,radius,a,pie2/2+a,1.5*radius,(c,rd,gr,bl,al),0)
  ang=ang-diff
  CCircle9(c,cx,cy,500,pie2/4-.8,pie2/4+.8,20,(c,0,0,100,.1),1)
  return 0
end function

dim as single baserate=.5
dim as integer fps

windowtitle "Cairo Test"

dim as string fname1="Verdana"
dim as string fname2="Times New Roman"
dim as string fname3="Arial Black"

do 
  var snoozer=Regulate(60,fps)
  ScreenLock
  Cls

  SetBackgroundColour((c,.9,.9,.9,1))

  CPrint8(c,150,300,"CAIRO PENDULUMS",50,(c,0,1,0,.8),fname1,italic)
  CPrint8(c,10,50,"Framerate " & fps,30,(c,1,.4,0,1),fname3,normal)

  CRectangle(c,5,70,150,25,3,(c,1,0,0,2))

  CPrint8(c,10,90,"Cairo-Version " & *Cairo_version_string,15,(c,0,0,0,1),fname2,normal)
  CPrint8(c,150,400,"FB-version " & __fb_version__,20,(c,0,0,0,1),fname2,normal)
  CPrint8(c,160,570,"Comic Sans MS fonts",40,(c,0,0,0,1),"Comic Sans MS",normal)

  Pendulum(400,10,500,20,0,baserate,rgba(200,0,0,255),.5)

  for z as integer=450 to 50 step-100
    var newradius=Map(500,50,z,15,2)
    var newred=Map(450,50,z,0,255)
    var newgreen=Map(450,50,z,255,0)
    var newblue=Map(450,50,z,255,0)
    Pendulum(400,10,z,newradius,baserate,baserate,rgba(newred,newgreen,newblue,255),0)
  next z
  
  ScreenUnlock
  
  Sleep snoozer,1
loop until Len(Inkey)
