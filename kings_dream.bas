' king's dream fractal
' -------------

Option _Explicit

Const XMAX = 1300 ' image dimensions
Const YMAX = 900

Const a = 2.879879 ' constants fractal
Const b = -0.765145
Const c = -0.966918
Const d = 0.744728

Const x0 = 2.0, y0 = 2.0 ' initial values

Const N = 6E6 ' number of iterations

Const comax = _RGB32(255, 255, 255)

Dim As Long co, handle, pr, pg, pb, counter
Dim As Integer xscr, yscr
Dim As Double x, y, xold

handle = _NewImage(XMAX, YMAX, 32) ' generate window
Screen handle
_Title "King's Dream fractal"
Cls

x = x0: y = y0
For counter = 1 To N
    xold = x
    x = Sin(a * x) + b * Sin(a * y)
    y = Sin(c * xold) + d * Sin(c * y)
    xscr = XMAX * (x + 2) / 4
    yscr = YMAX * (y + 2) / 4
    co = Point(xscr, yscr)
    If co < comax Then
        pr = _Red(co): pg = _Green(co): pb = _Blue(co)
        pr = pr + 3: pg = pg + 1: pb = pb + 5
        co = _RGB32(pr, pg, pb)
        PSet (xscr, yscr), co
    End If
Next counter
Sleep






