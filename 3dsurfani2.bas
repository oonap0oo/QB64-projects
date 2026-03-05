' 3D surface plot, animated

Option _Explicit

Const XMAX = 1000 ' image dimensions
Const YMAX = 650
Const margin = 20 ' margin between window edges and drawing
Const Nx = 90, Ny = 90 ' number of lines in x and y direction
Const yl = -12, yu = 12 ' y axis interval over which function is evaluated
Const xl = -12, xu = 12 ' x axis interval over which function is evaluated
Const zl = -.5, zu = 1 ' z axis interval over which function is evaluated
Const dscr = 32 ' distance eyeball to projection screen
Const dxyz = 45 ' distance eyeball to xyz axes origin
Const yzangle = 6 * _Pi / 180 ' angle over which graph is rotated around x axis
Const xyangle = 35 * _Pi / 180 ' angle over which graph is rotated around z axis
Const Nframes = 120 ' total number of frames in animation
Const fps = 60 ' number of frames per second

Type PointType ' custom variable type: a 2D point with extra integer for color
    x As Single ' x and y coord.
    y As Single
    co As Integer ' color
End Type

' Array points() contains all the data needed to draw the animation
Dim As PointType points(Ny, Nx, Nframes)

Dim As Integer v, h, frame
Dim As Long linecol, fillcol
Dim As Single x, y, z, yr, zr, xr, yr2, xscrmax, yscrmax, xscrmin, yscrmin
Dim As Single xscrspan, yscrspan, alpha, dalpha
Dim Shared As Single cos_yzangle, sin_yzangle, cos_xyangle, sin_xyangle

' generate window with 32bit color mode
Dim Shared As Long handle
handle = _NewImage(XMAX, YMAX, 32)
Screen handle
_Title "3D Surface plot, animated"
Cls

' calc values once, use many times
cos_yzangle = Cos(yzangle): sin_yzangle = Sin(yzangle)
cos_xyangle = Cos(xyangle): sin_xyangle = Sin(xyangle)

' step increase of parameter alpha which increases each frame
dalpha = 2 * _Pi / Nframes

' calculate graph points and colors for each frame
' and store the data in the array points()
xscrmax = 0: xscrmin = 0: yscrmax = 0: yscrmin = 0
For frame = 0 To Nframes - 1
    alpha = frame * dalpha ' increase parameter alpha each frame
    For v = Ny - 1 To 0 Step -1
        y = yl + (yu - yl) * v / (Ny - 1)
        For h = 0 To Nx - 1
            x = xl + (xu - xl) * h / (Nx - 1)
            z = sinexp!(x, y, alpha)
            ' calculate and store line color
            points(v, h, frame).co = (z - zl) / (zu - zl) * 255 + (1 - v / Ny) * 100
            ' rotate 3D coord. around z axis to tilt graph for viewing
            ' |cos -sin| |x|
            ' |sin  cos| |y|
            xr = x * cos_xyangle - y * sin_xyangle
            yr = x * sin_xyangle + y * cos_xyangle
            ' rotate 3D coord. around x axis to tilt graph for viewing
            yr2 = yr * cos_yzangle - z * sin_yzangle
            zr = yr * sin_yzangle + z * cos_yzangle
            ' calculate and store projected coordinates
            points(v, h, frame).x = xr * dscr / (dxyz + yr2)
            points(v, h, frame).y = zr * dscr / (dxyz + yr2)
            ' keep track of max and min values over all frames
            If points(v, h, frame).x > xscrmax Then xscrmax = points(v, h, frame).x
            If points(v, h, frame).x < xscrmin Then xscrmin = points(v, h, frame).x
            If points(v, h, frame).y > yscrmax Then yscrmax = points(v, h, frame).y
            If points(v, h, frame).y < yscrmin Then yscrmin = points(v, h, frame).y
        Next h
    Next v
Next frame

' scale projected coordinates for screen taking into account the maximum
' x and y values encountered over all frames
xscrspan = xscrmax - xscrmin: yscrspan = yscrmax - yscrmin
For frame = 0 To Nframes - 1
    For v = Ny - 1 To 0 Step -1
        For h = 0 To Nx - 1
            points(v, h, frame).x = margin + (points(v, h, frame).x - xscrmin) / xscrspan * (XMAX - 2 * margin)
            points(v, h, frame).y = YMAX - margin - (points(v, h, frame).y - yscrmin) / yscrspan * (YMAX - 2 * margin)
        Next h
    Next v
Next frame

' main loop: draw stored data to screen, frame after frame
frame = 0
Do
    _Limit fps ' limit number of loops per second and free remaining cpu time
    alpha = frame * dalpha
    Cls
    For v = Ny - 2 To 0 Step -1
        For h = 1 To Nx - 1
            linecol = _RGB32(0, points(v, h, frame).co, 0)
            fillcol = _RGB32(points(v, h, frame).co / 10, points(v, h, frame).co / 3, points(v, h, frame).co / 10)
            quad points(v + 1, h - 1, frame), points(v, h - 1, frame), points(v, h, frame), points(v + 1, h, frame), linecol, fillcol
        Next h
    Next v
    _Display ' wait to display changes to screen until this statement, runs smoother
    ' increase and cycle frame counter
    If frame < Nframes - 1 Then frame = frame + 1 Else frame = 0
Loop Until InKey$ <> ""

' function to be plotted, variables x and y, parameter alpha
Function sinexp! (x As Single, y As Single, alpha As Single)
    Dim r As Single
    r = Sqr(x * x + y * y)
    sinexp! = Sin(r - alpha) * Exp(-r / 12)
End Function

' draw 1 quadrilateral using color c, defined by 4 arbitrary points and filled with background color
' the background color fill is used to erase lines which are to be hidden
Sub quad (p1 As PointType, p2 As PointType, p3 As PointType, p4 As PointType, c As Long, cf As Long)
    PSet (0, 0), cf
    _MapTriangle (0, 0)-(0, 0)-(0, 0), handle To(p1.x, p1.y)-(p2.x, p2.y)-(p3.x, p3.y), handle
    _MapTriangle (0, 0)-(0, 0)-(0, 0), handle To(p1.x, p1.y)-(p4.x, p4.y)-(p3.x, p3.y), handle
    Line (p1.x, p1.y)-(p2.x, p2.y), c
    Line -(p3.x, p3.y), c
    Line -(p4.x, p4.y), c
    Line -(p1.x, p1.y), c
End Sub


