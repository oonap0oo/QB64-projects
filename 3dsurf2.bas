' 3D graph of sin(r)/r
Option _Explicit

Const XMAX = 1300 ' image dimensions
Const YMAX = 900
Const Nx = 70, Ny = 70 ' number of lines in x and y direction
Const xshift = 2.5, yshift = 4 ' tilt of graph
Const yl = -12, yu = 12 ' interval over which function is evaluated
Const xl = -12, xu = 12
Const zl = -0.1, zu = 1

Type PointType ' an x,y point
    x As Integer
    y As Integer
End Type

Dim As Integer v, h, dx, dy, zscr, co(Ny, Nx)
Dim As PointType points(Ny, Nx) ' all points of graph in array
Dim As Single x, y

Dim Shared As Long handle
handle = _NewImage(XMAX, YMAX, 32) ' generate window with 32bit color mode
Screen handle
_Title "3D Surface plot"
Cls

' calculate graph points and colors
For v = Ny - 1 To 0 Step -1
    y = xl + (xu - xl) * v / (Ny - 1)
    dx = v * xshift
    dy = v * yshift
    For h = 0 To Nx - 1
        x = xl + (xu - xl) * h / (Nx - 1)
        points(v, h).x = (XMAX / Nx - 3) * h + dx + 30
        zscr = (sinc(x, y) - zl) / (zu - zl) * YMAX * 0.75
        points(v, h).y = YMAX - zscr - dy - 40
        co(v, h) = zscr / YMAX / 0.75 * 255 + (1 - v / Ny) * 255 + 10
    Next h
Next v

' draw graph
For v = Ny - 2 To 0 Step -1
    For h = 1 To Nx - 1
        quad points(v + 1, h - 1), points(v, h - 1), points(v, h), points(v + 1, h), _RGB32(0, co(v, h), 0)
    Next h
Next v

Sleep

' function sin(r)/r
Function sinc (x As Single, y As Single)
    Dim r As Single
    r = Sqr(x * x + y * y)
    If r = 0 Then
        sinc = 1
    Else
        sinc = Sin(r) / r
    End If
End Function

' draw 1 quadrilateral using color c, defined by 4 arbitrary points and filled with black color
' the black color fill is used to erase lines which are to be hidden
Sub quad (p1 As PointType, p2 As PointType, p3 As PointType, p4 As PointType, c As Long)
    _MapTriangle (0, 0)-(0, 0)-(0, 0), handle To(p1.x, p1.y)-(p2.x, p2.y)-(p3.x, p3.y), handle
    _MapTriangle (0, 0)-(0, 0)-(0, 0), handle To(p1.x, p1.y)-(p4.x, p4.y)-(p3.x, p3.y), handle
    Line (p1.x, p1.y)-(p2.x, p2.y), c
    Line -(p3.x, p3.y), c
    Line -(p4.x, p4.y), c
    Line -(p1.x, p1.y), c
End Sub



