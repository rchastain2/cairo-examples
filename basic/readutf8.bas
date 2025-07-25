
' Cairo can render graphics to pdf, jpg, png, svg , the screen (hwnd), (printer) etc.....
' Cairo expects text to be in the UTF8 format. Some simple (non error checking) code to read an UTF8
' file (replace t3.utf8 with a unicode file ((utf8 encoded)) of your own).

dim bom(0 to 2) as ubyte = {&hef, &hbb, &hbf}
dim fh as integer = freefile()
open "t3.utf8" for binary access read  as #fh

var err_ = err()
if (err_) then
  print "file not found (t3.utf8)"
end if
var flen = lof(fh)
dim bom_(0 to 2) as ubyte
get #fh,, bom_()
for i as integer = 0 to 2
  if (bom_(i) <> bom(i)) then
    print "not an UTF8 file (no BOM found)"
    end
  end if
next i

dim bytesread as uinteger
dim utf8_content as ubyte ptr = callocate(sizeof(ubyte), flen)
get #fh,, *utf8_content, flen - 3, bytesread
for i as integer = 0 to bytesread - 1
  print hex(utf8_content[i]);" ";
next i
deallocate(utf8_content)
close

' The cairo function that does the rendering does not use a length parameter so I'm guessing the
' routine will stop parsing the UTF8 at the first 0 it finds (there are a couple at the end of
' utf8_content).
