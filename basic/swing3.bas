
' https://www.freebasic.net/forum/viewtopic.php?p=302813#p302813
' Eight swinging sticks kinetic energy using arrays by neil
' Cairo version

#include once "cairo/cairo.bi"

const W as integer = 640
const H as integer = 640
const as double g = 9.81 ' acceleration due to gravity
const as double dt = 0.16 ' time step

screenres W, H, 32
dim as double x1, x2, y1, y2, b
dim as double L = 290 ' length of sticks

dim as integer colr(8), i
dim as double accel(8), angle(8), vel(8)
dim as long fps

x1 = W / 2
y1 = H / 2

' put starting velocities in an array
for i = 0 to 7
  vel(i) = 0.02
next

' this sets the starting positions of pendulums
' regular numbers positions them on the right side of the screen
' negative numbers positions them on the left side of the screen

' right side
angle(0) = 3
angle(1) = 2.6
angle(2) = 2.2
angle(3) = 1.9

'left side
angle(4) = -2.9
angle(5) = -2.5
angle(6) = -2.1
angle(7) = -1.8

for i = 0 to 7
  angle(i) = -3
next i

' colors stored in an array
colr(0) = rgb(&HFF, &HFF, &H00)
colr(1) = rgb(&H4B, &HB0, &HFF)
colr(2) = rgb(&HFF, &HB3, &H00)
colr(3) = rgb(&HFF, &H00, &H00)
colr(4) = rgb(&HFF, &H00, &HFF)
colr(5) = rgb(&H00, &HFF, &H00)
colr(6) = rgb(&HFF, &HFF, &HFF)
colr(7) = rgb(&H00, &HFF, &HFF)

function Regulate(byval MyFps as long, byref fps as long) as long
  static as double timervalue, _lastsleeptime, t3, frames
  frames += 1
  if (timer - t3) >= 1 then t3 = timer : fps = frames : frames = 0
  var sleeptime = _lastsleeptime + ((1 / myfps) - timer + timervalue) * 1000
  if sleeptime < 1 then sleeptime = 1
  _lastsleeptime = sleeptime
  timervalue = timer
  return sleeptime
end function

dim as any ptr image = imagecreate(W, H)
dim as any ptr pixels

imageinfo(image, W, H,,, pixels)

dim as long stride = cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, W) ' https://www.freebasic.net/forum/viewtopic.php?p=215065#p215065
dim as cairo_surface_t ptr cs = cairo_image_surface_create_for_data(pixels, CAIRO_FORMAT_ARGB32, W, H, stride)

dim as cairo_t ptr cr = cairo_create(cs)

const PI = 3.1415926535897932

#define CAIRO_COLOR(c) (c and &hFF0000) / &hFF0000, (c and &h00FF00) / &h00FF00, (c and &h0000FF) / &h0000FF

dim as integer skip = 7
dim as integer count = 0

do
' Paint image black
  cairo_set_source_rgb(cr, 0, 0, 0)
  cairo_paint(cr)
  
  for i as integer = 0 to 7 - skip
    
  ' Calculate acceleration
    accel(i) = -g / L * sin(angle(i))
  
  ' Update velocities
    vel(i) += accel(i) * dt
    
  ' Update angles  
    angle(i) += vel(i) * dt
  next
  
  for i as integer = 0 to 7
  ' Update stick positions
    x2 = x1 + L * sin(angle(i))
    y2 = y1 + L * cos(angle(i))
  
  ' Draw sticks
    cairo_set_source_rgba(cr, CAIRO_COLOR(colr(i)), 0.5)
    cairo_move_to(cr, x1, y1)
    cairo_line_to(cr, x2, y2)
    cairo_stroke(cr)
    cairo_arc(cr, x2, y2, 20, 0, 2 * PI)
    cairo_fill(cr)
  next
  
' Circle for pivot
  cairo_arc(cr, x1, y1, 10, 0, 2 * PI)
  cairo_set_source_rgba(cr, 0.5, 0.5, 0.5, 0.5)
  cairo_fill(cr)
  
  screenlock
  put (0, 0), image, pset
  screenunlock
  
  sleep regulate(60, fps), 1
  
  count += 1
  if count = 6 then
    if skip > 0 then
      skip -= 1
    end if
    count = 0
  end if
loop until len(inkey)

cairo_destroy(cr)
cairo_surface_destroy(cs)

imagedestroy image

sleep
