' Gumowski Mira fractal
' ---------------------

OPTION _EXPLICIT

CONST XMAX = 1100 ' image dimensions
CONST YMAX = 800
' constants fractal: very sensitive to value changes
CONST a = -0.7 ' The a parameter can be any floating point value between -1 and +1
CONST b = 1.0 ' The b parameter should always stay close to 1.
CONST x0 = -5.5, y0 = -5.0 ' initial values
CONST N = 8E6 ' number of iterations

DIM AS LONG co, handle, pr, pg, pb, counter
DIM AS INTEGER xscr, yscr
DIM AS DOUBLE x, y, xold, xsq

handle = _NEWIMAGE(XMAX, YMAX, 32) ' generate window
SCREEN handle
_TITLE "Gumowski Mira  a=" + STR$(a) + " b=" + STR$(b) + _
" x0=" + STR$(x0) + " y0=" + STR$(y0)
CLS
x = x0: y = y0
FOR counter = 1 TO N
    xold = x
    x = b * y + f(xold, a)
    y = f(x, a) - xold
    xscr = XMAX * (x + 15) / 30
    yscr = YMAX * (y + 12) / 24
    co = POINT(xscr, yscr)
    pr = _RED(co): pg = _GREEN(co): pb = _BLUE(co)
    pr = pr - 5 * (counter > (N / 3))
    pg = pg - 3 * (counter < (N / 2))
    pb = pb - 12 * (counter > (2 * N / 3))
    co = _RGB32(pr, pg, pb)
    PSET (xscr, yscr), co
NEXT counter
SLEEP

FUNCTION f# (x AS DOUBLE, a AS DOUBLE)
    DIM xsq AS DOUBLE
    xsq = x * x
    f# = a * x + 2# * (1# - a) * xsq / (1# + xsq) ^ 2
END FUNCTION




