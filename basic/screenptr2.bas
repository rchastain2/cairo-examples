const SCREEN_WIDTH = 256, SCREEN_HEIGHT = 256
dim as long w, h, bypp, pitch

'' Make 32-bit screen.
screenres SCREEN_WIDTH, SCREEN_HEIGHT, 32

'' Get screen info (w and h should match the constants above, bypp should be 4)
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
   
    '' Set row address to the start of the buffer
    dim as any ptr row = buffer
   
    '' Iterate over all the pixels in the screen:
   
    for y as integer = 0 to h - 1
       
        '' Set pixel address to the start of the row
        '' It's a 32-bit pixel, so use a ULong Ptr
        dim as ulong ptr pixel = row
       
        for x as integer = 0 to w - 1
           
            '' Set the pixel value
            *pixel = rgb(x, x xor y, y)
           
            '' Get the next pixel address
            '' (ULong Ptr will increment by 4 bytes)
            pixel += 1
           
        next x
       
        '' Go to the next row
        row += pitch
       
    next y

'' Unlock the screen.
screenunlock()

'' Wait for the user to press a key before closing the program
sleep
