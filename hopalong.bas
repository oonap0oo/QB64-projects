' Hopalong fractal
' ----------------

OPTION _EXPLICIT

CONST XMAX = 1000 ' image dimensions
CONST YMAX = 800
CONST a = 6 ' constants fractal
CONST b = 1 ' the parameters a, b and c can be any
CONST c = 5 ' floating point value between 0 and +10
CONST x0 = 0.7, y0 = -0.6 ' initial values
CONST N = 2E7 ' number of iterations
CONST comax = _RGB32(255, 255, 255)

DIM AS LONG co, handle, pr, pg, pb, counter
DIM AS INTEGER xscr, yscr
DIM AS DOUBLE x, y, xold

handle = _NEWIMAGE(XMAX, YMAX, 32) ' generate window
SCREEN handle
_TITLE "Hopalong Fractal a=" + STR$(a) + " b=" + STR$(b) + _
" c=" + STR$(c) + " x0=" + STR$(x0) + " y0=" + STR$(y0)
CLS

x = x0: y = y0
FOR counter = 1 TO N
    xold = x
    x = y - 1 - SQR(ABS(b * x - 1 - c)) * SGN(x - 1)
    y = a - xold - 1
    xscr = XMAX * (x + 400) / 800
    yscr = YMAX * (y + 400) / 800
    co = POINT(xscr, yscr)
    IF co < comax THEN
        pr = _RED(co): pg = _GREEN(co): pb = _BLUE(co)
        pr = pr + 3: pg = pg + 1: pb = pb + 5
        co = _RGB32(pr, pg, pb)
        PSET (xscr, yscr), co
    END IF
NEXT counter
SLEEP






