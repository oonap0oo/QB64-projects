' Sierpinski triangle
' -------------------

Option _Explicit
Randomize Timer
Const XMAX = 1200, YMAX = 800 ' image dimensions
Dim As Long handle, cx(2), cy(2), k
Dim As Integer px, py, index, r, g, b, hx, hy
dim title as string

title = "Sierkinski triangle"
handle = _NewImage(XMAX, YMAX, 32)
Screen handle: _Title title
Color _RGB(255, 255, 255)
Cls

cx(0) = XMAX / 2: cy(0) = 0
cx(1) = 0: cy(1) = YMAX
cx(2) = XMAX: cy(2) = YMAX
px = XMAX / 2: py = YMAX
hx = XMAX / 4: hy = YMAX / 4
For k = 1 To XMAX * YMAX / 2
    index = Int(Rnd * 2 + .5)
    px = (px + cx(index)) / 2
    py = (py + cy(index)) / 2
    r = (px Mod hx) * 255 / hx: g = (py Mod hy) * 255 / hy
    b = 255 - ((r + g) Mod 255)
    PSet (px, py), _RGB(r, g, b)
Next k
_PrintString (30, 30), title, handle
Sleep






