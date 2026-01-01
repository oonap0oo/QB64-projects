' Julia fractal
' -------------

' z_new = z^2 + c  z and c are complex numbers
' z = zr + zi*j  zr and zc depend on coordinates inside image
' c = cr + ci*j  cr and ci remain constant
' z^2 = (zr+zi*j)^2 = zr^2 + 2*zr*zi*j - zi^2 = zr^2 - zi^2  + 2*zr*zi*j
' z^2 + c = (zr^2 - zi^2 + cr)  + (2*zr*zi + ci)*j ' real and imaginary part

Option _Explicit

Const XMAX = 1200 ' image dimensions
Const YMAX = 800
Dim As Long co, handle
Dim As Integer x, y, counter, r, g, b
Dim As Double cr, ci, zr, zi, zr_new, Zi_new

handle = _NewImage(XMAX, YMAX, 32)
Screen handle
_Title "Julia Fractal"
Cls
cr = -0.5125 ' constant value c
ci = 0.5213
For x = 0 To XMAX - 1
    For y = 0 To YMAX - 1
        zr = x / (XMAX - 2) * 3.0 - 1.5 ' complete fractal
        zi = y / (YMAX - 2) * 2.0 - 1.0
        'zr = x / (XMAX - 2) * 1.5 - 0.75 ' zoomed in
        'zi = y / (YMAX - 2) * 1.0 - 0.5
        counter = 0
        While (counter < 1024) And ((zr ^ 2 + zi ^ 2) < 4) ' loop measures how quick z diverges
            zr_new = zr ^ 2 - zi ^ 2 + cr
            zi = 2 * zr * zi + ci
            zr = zr_new
            counter = counter + 1
        Wend
        counter = Int(Sqr(counter) * 8) ' sqr function to show more detail in low counter values
        r = (counter Mod 33) * 8 ' retrieve red, green and blue compinents out of value counter
        If r > 255 Then r = 255
        g = (counter Mod 129) * 2
        If g > 255 Then g = 255
        b = (counter Mod 65) * 4
        If b > 255 Then b = 255
        co = _RGB32(r, g, b)
        PSet (x, y), co
    Next y
Next x
Sleep






