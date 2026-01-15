' Gingerbread man fractal
' -----------------------
Option _Explicit

Const XMAX = 1300 ' image dimensions
Const YMAX = 900
Const x0 = -0.1, y0 = 0 ' initial values
Const N = 5E5 ' number of iterations

Dim As Long co, handle, counter
Dim As Integer xscr, yscr, d, pr, pg, pb
Dim As Double x, y, xold, yold
' generate graphical window with 32 bit color
handle = _NewImage(XMAX, YMAX, 32)
Screen handle
_Title "Gingerbread Man Fractal"
Cls
' calculating and plotting
x = x0: y = y0
For counter = 1 To N
    xold = x: yold = y
    x = 1 - y + Abs(x) ' gingerbread fractal equations
    y = xold
    xscr = XMAX * (x + 3.5) / 12 ' map to screen coord.
    yscr = YMAX * (8.5 - y) / 12
    d = dist(x, y, xold, yold) * 50 ' distance between 2 successive points
    pg = (d Mod 33) * 8 ' derive rgb out of distance d
    pb = (d Mod 256)
    pr = (d Mod 129) * 2
    co = _RGB32(pr, pg, pb) ' define 32 bit color value
    PSet (xscr, yscr), co ' color one point
Next counter
Sleep

Function dist# (x1#, y1#, x2#, y2#) ' distance between x1,y1 and x2,y2
    dist# = Sqr((x1# - x2#) ^ 2 + (y1# - y2#) ^ 2)
End Function



