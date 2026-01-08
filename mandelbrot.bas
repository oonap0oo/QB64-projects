' mandelbrot fractal
' -------------

' z_new = z^2 + c  z and c are complex numbers
' z = zr + zi*j  zr and zc remain constant
' c = cr + ci*j  cr and ci depend on coordinates inside image
' z^2 = (zr+zi*j)^2 = zr^2 + 2*zr*zi*j - zi^2 = zr^2 - zi^2  + 2*zr*zi*j
' z^2 + c = (zr^2 - zi^2 + cr)  + (2*zr*zi + ci)*j ' real and imaginary part

Option _Explicit

Const XMAX = 1300 ' image dimensions
Const YMAX = 900

Const XL = -2.1, XU = 1.0 ' viewing area of fractal
Const YL = -1.25, YU = 1.25

'Const XL = -0.5, XU = 0.3
'Const YL = -1.3, YU = -0.5

'Const XL = -0.315, XU = 0.125
'Const YL = -1.15, YU = -0.75

Dim As Long co, handle
Dim As Integer x, y, counter, r, g, b
Dim As Double cr, ci, zr, zi, zr_new, Zi_new, yspan, xspan, zrsq, zisq

handle = _NewImage(XMAX, YMAX, 32) ' generate window
Screen handle
_Title "Mandelbrot Fractal"
Cls

xspan = XU - XL: yspan = YU - YL
For x = 0 To XMAX - 1
    cr = x / (XMAX - 2) * xspan + XL ' real part of c
    For y = 0 To YMAX - 1
        zr = 0 ' constant value z
        zi = 0
        ci = y / (YMAX - 2) * yspan + YL ' imaginary part of c
        counter = 0
        Do ' loop measures how quick z diverges
            zrsq = zr ^ 2: zisq = zi ^ 2
            zr_new = zrsq - zisq + cr
            zi = 2 * zr * zi + ci
            zr = zr_new
            counter = counter + 1
        Loop While (counter < 256) And ((zrsq + zisq) < 4)
        r = (counter Mod 64) * 4 ' retrieve red, green and blue components out of value counter
        g = (counter Mod 32) * 8
        b = (counter Mod 16) * 16
        co = _RGB32(r, g, b)
        PSet (x, y), co
    Next y
Next x
Sleep






