' Rabinovich-Fabrikant System
' For use with QB64 Phoenix Edition

Option _Explicit
'Rabinovich-Fabrikant parameters
' example 1
Const Nstore = 50000 ' number of data points stored for drawing
Const Nloop = 2000 ' extra iterations for accuraxy (keep dt small)
Const T = 100# ' Total time interval covered
Const alpha = 0.05, gamma = 0.1 ' parameter of Rabinovich-Fabrikant System
Const x0 = 0.1, y0 = -0.1, z0 = 0.1 ' initial values of the three variables
Const yzangle = 5 * _Pi / 180 ' angle over which graph is rotated around x axis
Const xyangle = -120 * _Pi / 180 ' angle over which graph is rotated around z axis

' example 2
'Const Nstore = 25000 ' number of data points stored for drawing
'Const Nloop = 16000 ' extra iterations for accuraxy (keep dt small)
'Const T = 500# ' Total time interval covered
'Const alpha = 0.14, gamma = 0.118 ' parameter of Rabinovich-Fabrikant System
'Const x0 = 0.1, y0 = -0.1, z0 = 0.1 ' initial values of the three variables
'Const yzangle = 15 * _Pi / 180 ' angle over which graph is rotated around x axis
'Const xyangle = -25 * _Pi / 180 ' angle over which graph is rotated around z axis

' graphing parameters
Const XMAX = 650 ' image dimensions
Const YMAX = 650
Const margin = 30 ' margin between window edges and drawing
Const dscr = 30 ' distance eyeball to projection screen
Const dxyz = 100 ' distance eyeball to xyz axes origin

Dim As Long c1, c2, co
Dim As Integer pr, pg, pb
Dim As Double x, xsq, y, z, dx_dt, dy_dt, dz_dt, dt
Dim As Single xscr(Nstore), yscr(Nstore), cos_yzangle, sin_yzangle, cos_xyangle, sin_xyangle
Dim As Single xscrmax, yscrmax, xscrmin, yscrmin, xscrscale, yscrscale, yr, zr, xr, yr2
Dim As String title

Dim Shared As Long handle ' generate window with 32bit color mode
handle = _NewImage(XMAX, YMAX, 32)
Screen handle
title = "Rabinovich-Fabrikant alpha=" + Str$(alpha) + " gamma=" + Str$(gamma)
title = title + " x0=" + Str$(x0) + " y0=" + Str$(y0) + " z0=" + Str$(z0)
_Title title
Cls

cos_yzangle = Cos(yzangle): sin_yzangle = Sin(yzangle) ' calc values once, use many times
cos_xyangle = Cos(xyangle): sin_xyangle = Sin(xyangle)
dt = T / (Nstore * Nloop) ' time step for Euler Method
x = x0: y = y0: z = z0 ' load initial values
For c1 = 0 To Nstore - 1
    ' rotate 3D coord. around z axis to tilt graph for viewing
    ' |cos -sin| |x|
    ' |sin  cos| |y|
    xr = x * cos_xyangle - y * sin_xyangle
    yr = x * sin_xyangle + y * cos_xyangle
    ' rotate 3D coord. around x axis to tilt graph for viewing
    yr2 = yr * cos_yzangle - z * sin_yzangle
    zr = yr * sin_yzangle + z * cos_yzangle
    'calculate and store projected coordinates: 3D to 2D
    xscr(c1) = xr * dscr / (dxyz + yr2)
    yscr(c1) = zr * dscr / (dxyz + yr2)
    ' keep track of max and min values
    xscrmin = _Min(xscrmin, xscr(c1))
    xscrmax = _Max(xscrmax, xscr(c1))
    yscrmin = _Min(yscrmin, yscr(c1))
    yscrmax = _Max(yscrmax, yscr(c1))
    ' extra interations to keep errors low from Euler method (smaller dt)
    For c2 = 0 To Nloop - 1
        xsq = x * x ' square of x is used two times, calc one time
        dx_dt = y * (z - 1 + xsq) + gamma * x ' three ODEs of the Rabinovich-Fabrikant System
        dy_dt = x * (3 * z + 1 - xsq) + gamma * y
        dz_dt = -2 * z * (alpha + x * y)
        x = dx_dt * dt + x: y = dy_dt * dt + y: z = dz_dt * dt + z ' Euler method
    Next c2
Next c1

xscrscale = (XMAX - 2 * margin) / (xscrmax - xscrmin) ' avoid calculating these each time
yscrscale = (YMAX - 2 * margin) / (yscrmax - yscrmin)
For c1 = 0 To Nstore - 1
    xscr(c1) = margin + (xscr(c1) - xscrmin) * xscrscale ' scale coord. to screen window
    yscr(c1) = margin + (yscrmax - yscr(c1)) * yscrscale
    pr = 255 + 255 * ((c1 Mod 16000) < 8000) ' make up colors using counter c1
    pg = 255 + 255 * ((c1 Mod 8000) < 4000)
    pb = 255 + 255 * ((c1 Mod 4000) < 2000)
    co = _RGB32(pr, pg, pb) ' restore r,g,b into color value and draw point
    ' draw the data point
    If c1 = 0 Then
        PReset (xscr(c1), yscr(c1))
    Else
        Line -(xscr(c1), yscr(c1)), co
    End If
Next c1

Sleep

