' cairocolor.bi

type tcairocolor
  r as double
  g as double
  b as double
  a as double
  declare constructor(as uinteger, as double = 1.0)
  declare constructor(as double, as double, as double, as double = 1.0)
end type

constructor tcairocolor(rgb_ as uinteger, a_ as double)
  r = (rgb_ and &hFF0000) / &hFF0000
  g = (rgb_ and &h00FF00) / &h00FF00
  b = (rgb_ and &h0000FF) / &h0000FF
  a = a_
end constructor

constructor tcairocolor(r_ as double, g_ as double, b_ as double, a_ as double)
  r = r_
  g = g_
  b = b_
  a = a_
end constructor

/'
dim c1 as tcairocolor = tcairocolor(rgb(&HFF, &H00, &HFF))

with c1
  print(.r)
  print(.g)
  print(.b)
  print(.a)
end with

dim c2 as tcairocolor = tcairocolor(rgb(&HFF, &H00, &HFF), 0.5)

with c2
  print(.r)
  print(.g)
  print(.b)
  print(.a)
end with

dim c3 as tcairocolor = tcairocolor(1.0, 1.0, 1.0, 0.5)

with c3
  print(.r)
  print(.g)
  print(.b)
  print(.a)
end with
'/
