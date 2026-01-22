' Spirograph
' x = (R - tau) * cos(alpha + offset) + rho * cos( (R - tau) / tau * alpha )
' y = (R - tau) * sin(alpha + offset) - rho * sin( (R - tau) / tau * alpha )
' alpha: independant variable, is angle of larger wheel
' offset: inner wheel starts at offset angle for each set of turns
' R: radius outer wheel is also related to number of teeth
' tau: radius smaller inner wheel is also related to number of teeth
' rho: distance position drawing pen from center of smaller wheel

OPTION _EXPLICIT

' R: radius outer wheel is also related to number of teeth
CONST R = 144
' TAU: radius smaller inner wheel is also related to number of teeth
' interesting values: 54, 60, 64, 84, 90, 102, 112, 126
CONST TAU = 84
' N: number of points calculated per turn
CONST N = 150
' number of different positions used on smaller wheel
CONST NRHO = 18
' ratio of lowest en highest rho value and TAU
CONST RHO_TAU_L = 0.1, RHO_TAU_H = 0.9
' half of image dimensions, always square
CONST SIZEHALF = 500
' margin between drawing and image edge
CONST MARGIN = 20
' maximum offset angle
CONST MAXOFFSET = _PI / 3

DIM AS INTEGER nturns, maxt, npointstotal, k, j, xscr, yscr, red, green, blue
DIM AS SINGLE rho, alpha, x, y, max, offset
DIM AS LONG handle, co

' generate window
handle = _NEWIMAGE(SIZEHALF * 2, SIZEHALF * 2, 32)
SCREEN handle
_TITLE "Spirograph, big wheel: " + STR$(R) + ", small wheel: " + STR$(TAU)
CLS
' determine number of turns around outer big wheel
nturns = lcm(R, TAU) \ R
' maximum value parameter angle alpha
maxt = nturns * 2 * _PI
' total number of points calculated
npointstotal = N * nturns
' maximum coordinate value R-TAU+rho
' rho reaches RHO_TAU_H * TAU
max = R + (RHO_TAU_H - 1) * TAU
' outer loop for different rho, offset and color
FOR k = 1 TO NRHO
    ' rho: distance position drawing pen from center of smaller wheel
    rho = (RHO_TAU_L + (RHO_TAU_H - RHO_TAU_L) * k / NRHO) * TAU
    ' generate color for this run
    red = (k / NRHO) * 255
    green = (red MOD 128) * 2
    blue = (red MOD 65) * 4
    co = _RGB32(red, green, blue)
    ' update offset angle
    offset = k / NRHO * MAXOFFSET
    ' inner loop draws one spirograph cycle
    FOR j = 0 TO npointstotal - 1
        ' alpha: independant variable, is angle of larger wheel
        alpha = j / (npointstotal - 1) * maxt
        ' physical coordinates
        x = (R - TAU) * COS(alpha + offset) + rho * COS((R - TAU) / TAU * alpha)
        y = (R - TAU) * SIN(alpha + offset) - rho * SIN((R - TAU) / TAU * alpha)
        ' screen coordinates
        xscr = SIZEHALF + x / max * (SIZEHALF - MARGIN)
        yscr = SIZEHALF + y / max * (SIZEHALF - MARGIN)
        'drawing
        IF j = 0 THEN
            PRESET (xscr, yscr)
        ELSE
            LINE -(xscr, yscr), co
        END IF
    NEXT j
NEXT k
SLEEP
END

' greatest common divider, used in function lcm
FUNCTION gcd (a AS INTEGER, b AS INTEGER)
    DIM temp AS INTEGER
    WHILE b <> 0
        temp = b
        b = a MOD b
        a = temp
    WEND
    gcd = a
END FUNCTION

' least common multiple, used to determine number of turns around outer big wheel
FUNCTION lcm (a AS INTEGER, b AS INTEGER)
    lcm = ABS(a * b) / gcd(a, b)
END FUNCTION


