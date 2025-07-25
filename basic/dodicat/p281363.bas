
' https://www.freebasic.net/forum/viewtopic.php?p=281363#p281363

dim as integer w,h
screeninfo w,h
#include once "cairo/cairo.bi"
#define _rd_ cast(ubyte ptr,@colour)[2]/255
#define _gr_ cast(ubyte ptr,@colour)[1]/255
#define _bl_ cast(ubyte ptr,@colour)[0]/255
#define _al_ cast(ubyte ptr,@colour)[3]/255

dim shared as cairo_font_extents_t _fonts 
dim shared as cairo_text_extents_t _text
const pi=4*atn(1)

sub InitFonts(surf as cairo_t ptr,fonttype as string="times new roman")
    if len(fonttype) then
        cairo_select_font_face (surf,fonttype, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
    end if
    cairo_font_extents (surf, @_fonts)
end sub

sub Cprint(surf as cairo_t ptr,x as long,y as long,text as string,size as single,colour as ulong)
    cairo_set_font_size (surf,(size))
    cairo_move_to (surf, _ '                 lower left corner of text
    (x) - (_text.width / 2 + _text.x_bearing), _
    (y) + (_text.height / 2) - _fonts.descent)
    cairo_set_source_rgba surf,_rd_,_gr_,_bl_,_al_
    cairo_show_text(surf, text)
    cairo_stroke(surf)
end sub

'rectangle unused
sub Crectangle(surf as cairo_t ptr,x as long,y as long,wide as long,high as long,thickness as single,colour as ulong)
    cairo_set_line_width(surf, (thickness))
    cairo_set_source_rgba surf,_rd_,_gr_,_bl_,_al_
    cairo_move_to(surf, (x), (y))
    cairo_rectangle(surf,(x),(y),(wide),(high))
    cairo_stroke(surf)
end sub

sub Crectanglefill(surf as cairo_t ptr,x as long,y as long,wide as long,high as long,colour as ulong)
    cairo_set_source_rgba surf,_rd_,_gr_,_bl_,_al_
    'cairo_move_to(surf, (x), (y))
    cairo_rectangle(surf,(x),(y),(wide),(high))
    cairo_fill(surf)
    cairo_stroke(surf)
end sub

sub Ccircle(byref surf as cairo_t ptr,cx as long,cy as long,radius as long,start as single,finish as single,thickness as single,colour as ulong,Capoption as boolean)
    cairo_set_line_width(surf,(thickness))
    cairo_set_source_rgba surf,_rd_,_gr_,_bl_,_al_
    cairo_arc(surf,(cx),(cy),(radius),(start),(finish))
    if Capoption then
        cairo_set_line_cap(surf,CAIRO_LINE_CAP_ROUND)
    else
        cairo_set_line_cap(surf,CAIRO_LINE_CAP_SQUARE)
    end if
    cairo_stroke(surf)
end sub

sub Ccirclefill(byref surf as cairo_t ptr,cx as long,cy as long,radius as long,colour as ulong)
    cairo_set_line_width(surf,(1))
    cairo_set_source_rgba surf,_rd_,_gr_,_bl_,_al_
    cairo_arc(surf,(cx),(cy),(radius),(0),(2*pi))
    cairo_fill(surf)
    cairo_stroke(surf)
end sub


sub Cline(surf as cairo_t ptr,x1 as long,y1 as long,x2 as long,y2 as long,thickness as single,colour as ulong,CapOption as boolean)
    cairo_set_line_width(surf, (thickness))
    cairo_set_source_rgba surf,_rd_,_gr_,_bl_,_al_
    cairo_move_to(surf, (x1), (y1))
    cairo_line_to(surf,(x2),(y2))
    if Capoption then
        cairo_set_line_cap(surf,CAIRO_LINE_CAP_ROUND)
    else
        cairo_set_line_cap(surf,CAIRO_LINE_CAP_SQUARE)
    end if
    cairo_stroke(surf)
end sub

sub cpaint(surf as cairo_t ptr,x as long,y as long,colour as ulong)
    cairo_move_to(surf,x,y)
    cairo_set_source_rgba surf,_rd_,_gr_,_bl_,_al_
    cairo_fill(surf)
    cairo_stroke(surf)
end sub

sub SetBackgroundColour(c as cairo_t ptr,colour as ulong)
    cairo_set_source_rgba c,_rd_,_gr_,_bl_,_al_
    cairo_paint(c)
end sub

function setscreen(xres as integer,yres as integer)  as cairo_t ptr
    screenres xres,yres,32,,&h08 or &h40
    var surface = cairo_image_surface_create_for_data(screenptr(), CAIRO_FORMAT_ARGB32,xres,yres,xres*4)
    static as cairo_t ptr res
    res= cairo_create(surface)
    return res
end function

sub cflip(surf as cairo_t ptr)
    cairo_stroke(surf)
end sub

type ball
    x as single    'position x component
    y as single    'position y component
    dx as single   'velocity x component
    dy as single   'velocity y component
    a as single     'angular distance
    da as single   'angular speed
    col as ulong   'colour
    col2 as ulong  'contrast to col (for ball texture)
    as long r,m    'radius, mass
end type


sub texture3(c as cairo_t ptr,xpos as long,ypos as long,size as long,col1 as ulong,col2 as ulong,an as single,num as long=0)
    ccirclefill(c,xpos,ypos,size,col1)
    var l=2+size/2
    cairo_save(c)
    var tx=xpos-l,ty=ypos+l/1.5
    cairo_translate(c,xpos,ypos)
    cairo_rotate(c, an)
    cairo_translate(c,-xpos,-ypos)
    cprint(c,tx,ty,right("00"+str(num),2),size,col2)
    cairo_restore(c) 
end sub


sub MoveAndDraw(c as cairo_t ptr, b() as ball,byref e as long,byref ae as long,i as any ptr=0)'get energy also
    for n as long=lbound(b) to ubound(b)
        b(n).x+=b(n).dx:b(n).y+=b(n).dy
        b(n).a+=b(n).da*(1/b(n).r)
        texture3(c,b(n).x,b(n).y,b(n).r,b(n).col2,b(n).col,b(n).a,n)
        e+=.5*b(n).m*(b(n).dx*b(n).dx + b(n).dy*b(n).dy)
        ae+=b(n).da*b(n).da
    next n
end sub

sub edges(b() as ball,xres as long,yres as long,byref status as long ) 'get status also
    for n as long=lbound(b) to ubound(b)
        if(b(n).x<b(n).r) then b(n).x=b(n).r: b(n).dx=-b(n).dx:b(n).da=abs(atan2(b(n).dy,b(n).dx))*sgn(b(n).dy)
        if(b(n).x>xres-b(n).r )then b(n).x=xres-b(n).r: b(n).dx=-b(n).dx:b(n).da=-Abs(atan2(b(n).dy,b(n).dx))*sgn(b(n).dy)
       
        if(b(n).y<b(n).r)then b(n).y=b(n).r:b(n).dy=-b(n).dy:b(n).da=-Abs(atan2(b(n).dy,b(n).dx))*sgn(b(n).dx)
        if(b(n).y>yres-b(n).r)then  b(n).y=yres-b(n).r:b(n).dy=-b(n).dy:b(n).da=abs(atan2(b(n).dy,b(n).dx))*sgn(b(n).dx)
        if b(n).x<0 or b(n).x>xres then status=0
        if b(n).y<0 or b(n).y>yres then status=0
    next n
end sub

function DetectBallCollisions( B1 as ball,B2 as ball) as single 'avoid using sqr if they are well seperated
    dim as single xdiff = B2.x-B1.x
    dim as single ydiff = B2.y-B1.y
    if abs(xdiff) > (B2.r+B1.r) then return 0
    if abs(ydiff) > (B2.r+B1.r) then return 0
    var L=sqr(xdiff*xdiff+ydiff*ydiff)
    if L<=(B2.r+B1.r) then function=L else function=0
end function

sub BallCollisions(b() as ball)
    for n1 as long=lbound(b) to ubound(b)-1
        for n2 as long=n1+1 to ubound(b)
            dim as single  L= DetectBallCollisions(b(n1),b(n2))
            if L then
                dim as single  impulsex=(b(n1).x-b(n2).x)/L
                dim as single  impulsey=(b(n1).y-b(n2).y)/L
                'set one ball to nearest non overlap position
                b(n1).x=b(n2).x+(b(n2).r+b(n1).r)*impulsex
                b(n1).y=b(n2).y+(b(n2).r+b(n1).r)*impulsey
               
                dim as single  impactx=b(n1).dx-b(n2).dx
                dim as single  impacty=b(n1).dy-b(n2).dy
               
                dim as single  dot=impactx*impulsex+impacty*impulsey
                dim as single  mn2=b(n1).m/(b(n1).m+b(n2).m),mn1=b(n2).m/(b(n1).m+b(n2).m)
               
                b(n1).dx-=dot*impulsex*2*mn1
                b(n1).dy-=dot*impulsey*2*mn1
                b(n2).dx+=dot*impulsex*2*mn2
                b(n2).dy+=dot*impulsey*2*mn2
               
                dim as single at1=(atan2(b(n1).dy,b(n1).dx)),AT2=(atan2(b(n2).dy,b(n2).dx))
                at1=sgn(at1)*iif(at1<0,pi+at1,pi-at1)
                at2=sgn(at2)*iif(at2<0,pi+at2,pi-at2)
                b(n1).da=at1'-
                b(n2).da=at2'-
            end if
        next n2
    next n1
end sub

sub circles(numballs as long,OutsideRadius as long,cx as long,cy as long,a() as ball)
    redim a(1 to numballs+1)
    dim as double r,bigr,num,x,y,k=OutsideRadius
    #define rad *pi/180 
    dim as long counter
    num= (45*(2*numballs-4)/numballs) rad
    num=cos(num)
    r=num/(1+num)
    bigr=((1-r))*k  'radius to ring ball centres
    r=(r)*k -1        'radius of ring balls
    for z as double=0 to 2*pi step 2*pi/numballs
        counter+=1
        x=cx+bigr*cos(z)
        y=cy+bigr*sin(z)
        if counter>numballs then exit for
        a(counter).x=x
        a(counter).y=y
        a(counter).r=r
    next z
   
    a(ubound(a)).x=cx
    a(ubound(a)).y=cy
    a(ubound(a)).r=OutsideRadius-r*2-2
end sub

function Regulate(byval MyFps as long,byref fps as long) as long
    static as double timervalue,_lastsleeptime,t3,frames
    frames+=1
    if (Timer-t3)>=1 then t3=timer:fps=frames:frames=0
    var sleeptime=_lastsleeptime+((1/myfps)-Timer+timervalue)*1000
    if sleeptime<1 then sleeptime=1
    _lastsleeptime=sleeptime
    timervalue=timer
    return sleeptime
end function

function contrast(c as ulong) as ulong
    #define Intrange(f,l) int(rnd*((l+1)-(f))+(f))
    'get the rgb values
    dim as ubyte r=cptr(ubyte ptr,@c)[2],g=cptr(ubyte ptr,@c)[1],b=cptr(ubyte ptr,@c)[0],r2,g2,b2
    do
        r2=Intrange(0,255):g2=IntRange(0,255):b2=IntRange(0,255)
        'get at least 120 ubyte difference
    loop until abs(r-r2)>120 andalso abs(g-g2)>120 andalso abs(b-b2)>120
    return rgb(r2,g2,b2)
end function


dim as cairo_t ptr c=setscreen(1024,768)
initfonts(c,"georgia")
dim as integer xres,yres
screeninfo xres,yres

dim as long energy,angenergy,status=1,fps
redim as ball b()
circles(15,250,xres/3,yres/2,b())
randomize 3
for n as long=lbound(b) to ubound(b)
    with b(n)
        .dx=0
        .dy=0
        .col=rgb(rnd*255,rnd*255,rnd*255)
        .col2=contrast(.col)
        '.r (determined in circles sub)
        .m=.r^2
    end with
next
cprint(c,10,30,"Press a key",30,rgba(255,255,255,255))
screenlock
MoveAndDraw(c,b(),0,0)'first view (static)
screenunlock
sleep
b(1).dx=12 'set system alive

dim as integer I
screencontrol(2,I)'getwindowhandle
dim as any ptr Win = cast(any ptr,I)
dim as long mx,my,mw
#define map(a,b,x,c,d)  ((d)-(c))*((x)-(a))\((b)-(a))+(c)
var f=768/1024 'screen ratio correction
while 1
   
    getmouse mx,my,mw
    'MoveWindow(win,0,0,1024+mw*5,768+mw*5*f,1)
   
    energy=0
    AngEnergy=0
    edges(b(),xres,yres,status)
    BallCollisions(b())
   var dx=map(0,(1024+5*mw),mx,0,1024)
   var dy=map(0,(768+5*mw*f),my,0,768)
    screenlock
    cls
    MoveAndDraw(c,b(),energy,AngEnergy)
    cprint(c,50,25," Press escape key to end",25,rgba(255,255,255,255))
    cprint(c,50,55," framerate " &fps ,25,rgba(0,200,0,255))
    draw string (50,100),"Kinetic energy " &energy
    draw string (50,140),"Angular energy " & AngEnergy
    draw string (50,190),"System stauus " & iif(status,"OK","Leaks")
    cprint(c,600,50,"mouse " +str(mx) + " , " + str(my),25,rgba(0,200,0,255))
    cprint(c,600-8*7,100,"mapmouse " +str(dx) + " , " + str(dy),25,rgba(0,200,0,255))
   
    cprint(c,600,150,"wheel " +str(mw),25,rgba(0,200,0,255))
    cprint(c,600,200,"desktop " +str(w)+ " , " + str(h),25,rgba(0,200,0,255))
    screenunlock
    sleep regulate(100,fps)
    if inkey=chr(27) then exit while
wend
 
