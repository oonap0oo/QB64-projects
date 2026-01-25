' QuadrupTwo fractal
' ---------------------
OPTION _EXPLICIT

CONST XMAX = 900 ' image dimensions
CONST YMAX = 900
CONST a = 10.0 ' constants fractal
CONST b = 2.0
CONST c = 2.0
CONST x0 = 0.0, y0 = 0.0 ' initial values
CONST N = 1E7 ' number of iterations

DIM AS LONG co, handle, pr, pg, pb, counter
DIM AS INTEGER xscr, yscr
DIM AS DOUBLE x, y, xold, xsq, z

handle = _NEWIMAGE(XMAX, YMAX, 32) ' generate window
SCREEN handle
_TITLE "QuadrupTwo  a=" + STR$(a) + " b=" + STR$(b) + _
+ " c=" + STR$(c)+" x0=" + STR$(x0) + " y0=" + STR$(y0)
CLS
x = x0: y = y0
FOR counter = 1 TO N
    xold = x ' x will be overwritten; old value syill needed
    z = (c * xold - b) ' part of equation, allows to use z*z iso. z^2 for speed
    x = y - SGN(xold) * SIN(LOG(ABS(b * xold - c))) * ATN(z * z)
    y = a - xold
    xscr = XMAX * (x + 250) / 500 ' scaling and convert x,y to integers xscr,yscr
    yscr = YMAX * (y + 250) / 500
    co = POINT(xscr, yscr) ' sampling color value of point
    pr = _RED(co): pg = _GREEN(co): pb = _BLUE(co) ' color value into r,g,b
    pr = pr - 7 * (counter > (N / 3)) ' increase r,g,b depending loop counter
    pg = pg - 3 * (counter < (N / 2))
    pb = pb - 14 * (counter > (2 * N / 3))
    co = _RGB32(pr, pg, pb) ' restore r,g,b into color value and draw point
    PSET (xscr, yscr), co
NEXT counter
SLEEP


