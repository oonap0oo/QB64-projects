' 3D surface plot

Option _Explicit

Const XMAX = 1000 ' image dimensions
Const YMAX = 600
Const margin = 20 ' margin between window edges and drawing
Const Nx = 90, Ny = 90 ' number of lines in x and y direction
Const yl = -12, yu = 12 ' y axis interval over which function is evaluated
Const xl = -12, xu = 12 ' x axis interval over which function is evaluated
Const zl = -0.2, zu = 1 ' z axis interval over which function is evaluated
Const dscr = 30 ' distance eyeball to projection screen
Const dxyz = 45 ' distance eyeball to xyz axes origin
Const yzangle = 1.5 * _Pi / 180 ' angle over which graph is rotated around x axis
Const xyangle = 35 * _Pi / 180 ' angle over which graph is rotated around z axis

Type PointType ' an 2D x,y point
    x As Single
    y As Single
End Type

Dim As Integer v, h, co(Ny, Nx)
Dim As Long linecol, fillcol
Dim As PointType points(Ny, Nx) ' all points of graph in array
Dim As Single x, y, z, yr, zr, xr, yr2, xscrmax, yscrmax, xscrmin, yscrmin, xscrspan, yscrspan

Dim Shared As Long handle ' generate window with 32bit color mode
handle = _NewImage(XMAX, YMAX, 32)
Screen handle
_Title "3D Surface plot"
Cls

' calculate graph points and colors
xscrmax = 0: xscrmin = 0: yscrmax = 0: yscrmin = 0
For v = Ny - 1 To 0 Step -1
    y = yl + (yu - yl) * v / (Ny - 1)
    For h = 0 To Nx - 1
        x = xl + (xu - xl) * h / (Nx - 1)
        z = sinc!(x, y)
        ' calculate and store line color
        co(v, h) = 5 + (z - zl) / (zu - zl) * 255 + (1 - v / Ny) * 150
        ' rotate 3D coord. around z axis to tilt graph for viewing
        xr = xrotate!(x, y, xyangle)
        yr = yrotate!(x, y, xyangle)
        ' rotate 3D coord. around x axis to tilt graph for viewing
        yr2 = xrotate!(yr, z, yzangle)
        zr = yrotate!(yr, z, yzangle)
        ' calculate and store projected coordinates
        ' keep track of max and min values
        points(v, h).x = xproj!(xr, yr2)
        If points(v, h).x > xscrmax Then xscrmax = points(v, h).x
        If points(v, h).x < xscrmin Then xscrmin = points(v, h).x
        points(v, h).y = yproj!(yr2, zr)
        If points(v, h).y > yscrmax Then yscrmax = points(v, h).y
        If points(v, h).y < yscrmin Then yscrmin = points(v, h).y
    Next h
Next v

' scale projected coordinates to screen
xscrspan = xscrmax - xscrmin: yscrspan = yscrmax - yscrmin
For v = Ny - 1 To 0 Step -1
    For h = 0 To Nx - 1
        points(v, h).x = margin + (points(v, h).x - xscrmin) / xscrspan * (XMAX - 2 * margin)
        points(v, h).y = YMAX - margin - (points(v, h).y - yscrmin) / yscrspan * (YMAX - 2 * margin)
    Next h
Next v

' draw graph
For v = Ny - 2 To 0 Step -1
    For h = 1 To Nx - 1
        linecol = _RGB32(0, co(v, h), 0)
        fillcol = _RGB32(co(v, h) / 8, co(v, h) / 4, co(v, h) / 8)
        quad points(v + 1, h - 1), points(v, h - 1), points(v, h), points(v + 1, h), linecol, fillcol
    Next h
Next v

Sleep

' function sin(r)/r
Function sinc! (x As Single, y As Single)
    Dim r As Single
    r = Sqr(x * x + y * y)
    If r = 0! Then
        sinc! = 1!
    Else
        sinc! = Sin(r) / r
    End If
End Function

' draw 1 quadrilateral using color c, defined by 4 arbitrary points and filled with black color
' the black color fill is used to erase lines which are to be hidden
Sub quad (p1 As PointType, p2 As PointType, p3 As PointType, p4 As PointType, c As Long, cf As Long)
    PSet (0, 0), cf
    _MapTriangle (0, 0)-(0, 0)-(0, 0), handle To(p1.x, p1.y)-(p2.x, p2.y)-(p3.x, p3.y), handle
    _MapTriangle (0, 0)-(0, 0)-(0, 0), handle To(p1.x, p1.y)-(p4.x, p4.y)-(p3.x, p3.y), handle
    Line (p1.x, p1.y)-(p2.x, p2.y), c
    Line -(p3.x, p3.y), c
    Line -(p4.x, p4.y), c
    Line -(p1.x, p1.y), c
End Sub

' projection x,y,z axis on 2D screen for xscr
' xscr/dscr = x / (dxyz + y)
' xscr = x * dscr / (dxyz + y)
Function xproj! (x As Single, y As Single)
    xproj! = x * dscr / (dxyz + y)
End Function

' projection x,y,z axis on 2D screen for yscr
' yscr/dscr = z / (dxyz + y)
' yscr = z * dscr / (dxyz + y)
Function yproj! (y As Single, z As Single)
    yproj! = z * dscr / (dxyz + y)
End Function

' rotation matrix
' |cos -sin| |x|
' |sin  cos| |y|
Function xrotate! (x As Single, y As Single, angle As Single)
    xrotate! = x * Cos(angle) - y * Sin(angle)
End Function

Function yrotate! (x As Single, y As Single, angle As Single)
    yrotate! = x * Sin(angle) + y * Cos(angle)
End Function

