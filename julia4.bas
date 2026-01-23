' Julia fractal
' -------------

' z_new = z^2 + c  z and c are complex numbers
' z = zr + zi*j  zr and zc depend on coordinates inside image
' c = cr + ci*j  cr and ci remain constant
' z^2 = (zr+zi*j)^2 = zr^2 + 2*zr*zi*j - zi^2 = zr^2 - zi^2  + 2*zr*zi*j
' z^2 + c = (zr^2 - zi^2 + cr)  + (2*zr*zi + ci)*j ' real and imaginary part

OPTION _EXPLICIT

CONST XMAX = 1200 ' image dimensions
CONST YMAX = 800
DIM AS LONG co, handle
DIM AS INTEGER x, y, counter, r, g, b
DIM AS DOUBLE cr, ci, zr, zi, zr_new, Zi_new, zrsq, zisq

handle = _NEWIMAGE(XMAX, YMAX, 32)
SCREEN handle
_TITLE "Julia Fractal"
CLS
cr = -0.5125 ' constant value c
ci = 0.5213
FOR x = 0 TO XMAX - 1
    FOR y = 0 TO YMAX - 1
        zr = x / (XMAX - 2) * 3.0 - 1.5 ' complete fractal
        zi = y / (YMAX - 2) * 2.0 - 1.0
        'zr = x / (XMAX - 2) * 1.5 - 0.75 ' zoomed in
        'zi = y / (YMAX - 2) * 1.0 - 0.5
        counter = 0
        DO ' loop measures how quick z diverges
            zrsq = zr * zr: zisq = zi * zi ' large speed increase by replacing x^2 by x*x
            zr_new = zrsq - zisq + cr
            zi = 2 * zr * zi + ci
            zr = zr_new
            counter = counter + 1
        LOOP WHILE (counter < 1025) AND ((zrsq + zisq) < 4)
        counter = INT(SQR(counter) * 8) ' sqr function to show more detail in low counter values
        r = (counter MOD 33) * 8 ' retrieve red, green and blue compinents out of value counter
        IF r > 255 THEN r = 255
        g = (counter MOD 129) * 2
        IF g > 255 THEN g = 255
        b = (counter MOD 65) * 4
        IF b > 255 THEN b = 255
        co = _RGB32(r, g, b)
        PSET (x, y), co
    NEXT y
NEXT x
SLEEP






