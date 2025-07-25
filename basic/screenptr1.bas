const SCREEN_WIDTH = 640, SCREEN_HEIGHT = 480
dim as long w, h, bypp, pitch

'' Make 8-bit screen.
screenres SCREEN_WIDTH, SCREEN_HEIGHT, 8

'' Get screen info (w and h should match the constants above, bypp should be 1)
screeninfo w, h, , bypp, pitch

'' Get the address of the frame buffer. An Any Ptr
'' is used here to allow simple pointer arithmetic
dim buffer as any ptr = screenptr()
if (buffer = 0) then
    print "Error: graphics screen not initialized."
    sleep
    end -1
end if

'' Lock the screen to allow direct frame buffer access
screenlock()
   
    '' Find the address of the pixel in the centre of the screen
    '' It's an 8-bit pixel, so use a UByte Ptr.
    dim as integer x = w \ 2, y = h \ 2
    dim as ubyte ptr pixel = buffer + (y * pitch) + (x * bypp)
   
   
    '' Set the center pixel color to 10 (light green).
    *pixel = 10

'' Unlock the screen.
screenunlock()

'' Wait for the user to press a key before closing the program
sleep
