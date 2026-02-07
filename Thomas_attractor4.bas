'Thomas attractor

Option _Explicit
' calculation constants
Const Nstore = 5000 ' number of data points stored for drawing
Const Nloop = 15000 ' extra iterations to keep error of Euler method low
Const T = 2000 ' Total time interval covered
Const b = 0.185 ' parameter of Thomas attractor
Const x0 = 0.2 ' initial values of the three variables
Const y0 = 0.5
Const z0 = 0.3
' plotting constants
Const XMAX = 500 ' image dimensions
Const YMAX = 500
Const dscr = 30 ' distance eyeball to projection screen
Const dxyz = 40 ' distance eyeball to xyz axes origin
Const Nyzangles = 200, Nxyangles = 500 ' number of animation steps for the 2 rotation axes
Const PI_2 = 2 * _Pi
Const xscrmax = 4, yscrmax = 4, xscrmin = -4, yscrmin = -4 ' the bounds of the 2D projected values

Dim As Long c1, c2, co(Nstore)
Dim As Integer pr, pg, pb
Dim As Double x, y, z, dx_dt, dy_dt, dz_dt, dt
Dim As Single xx(Nstore), yy(Nstore), zz(Nstore), dayz, daxy, limitxy, limityz
Dim As Single xscr(Nstore), yscr(Nstore), cos_yzangle, sin_yzangle, cos_xyangle, sin_xyangle
Dim As Single xscrscale, yscrscale, yr, zr, xr, yr2, yzangle, xyangle
Dim As String title
' generate window with 32bit color mode
Dim Shared As Long handle
handle = _NewImage(XMAX, YMAX, 32)
Screen handle
title = "Thomas attractor b=" + Str$(b)
title = title + " x0=" + Str$(x0) + " y0=" + Str$(y0) + " z0=" + Str$(z0)
_Title title
Cls
' avoid calculating these each time
xscrscale = XMAX / (xscrmax - xscrmin)
yscrscale = YMAX / (yscrmax - yscrmin)
' make up colors using counter c1 and store in array
Print "Calculating"
For c1 = 0 To Nstore - 1
    pb = 255 + 255 * ((c1 Mod 1000) < 500)
    pr = 255 + 255 * ((c1 Mod 500) < 250)
    pg = 255 + 255 * ((c1 Mod 250) < 125)
    co(c1) = _RGB32(pr, pg, pb) ' convert r,g,b into color value  and store in array
Next c1
' calculate and store 3D values using Euler method
dt = T / (Nstore * Nloop) ' time step for Euler Method
x = x0: y = y0: z = z0 ' load initial values
For c1 = 0 To Nstore - 1
    xx(c1) = x: yy(c1) = y: zz(c1) = z
    ' extra calculation steps to keep errors low from Euler method (smaller dt)
    For c2 = 0 To Nloop - 1
        dx_dt = Sin(y) - b * x ' three ODEs of the Thomas attractor
        dy_dt = Sin(z) - b * y
        dz_dt = Sin(x) - b * z
        x = dx_dt * dt + x: y = dy_dt * dt + y: z = dz_dt * dt + z ' Euler method
    Next c2
Next c1
' rotate, project and plot values
yzangle = 0: xyangle = 0
dayz = PI_2 / Nyzangles: daxy = PI_2 / Nxyangles ' the 2 rotation angles increase with these step values
limityz = PI_2 - dayz: limitxy = PI_2 - daxy ' when angles reach these values restore to zero
Do
    _Limit 30 ' reduce CPU load and this is 1 factor which determines animation speed
    If yzangle < limityz Then yzangle = yzangle + dayz Else yzangle = 0 ' ramp rotation angles from 0 to 2*pi
    If xyangle < limitxy Then xyangle = xyangle + daxy Else xyangle = 0
    cos_yzangle = Cos(yzangle): sin_yzangle = Sin(yzangle) ' calc values once, use many times
    cos_xyangle = Cos(xyangle): sin_xyangle = Sin(xyangle)
    For c1 = 0 To Nstore - 1
        ' rotate 3D coord. around z axis to tilt graph for viewing
        ' |cos -sin| |x|
        ' |sin  cos| |y|
        xr = xx(c1) * cos_xyangle - yy(c1) * sin_xyangle
        yr = xx(c1) * sin_xyangle + yy(c1) * cos_xyangle
        ' rotate 3D coord. around x axis to tilt graph for viewing
        yr2 = yr * cos_yzangle - zz(c1) * sin_yzangle
        zr = yr * sin_yzangle + zz(c1) * cos_yzangle
        'calculate and store projected coordinates: 3D to 2D
        xscr(c1) = xr * dscr / (dxyz + yr2)
        yscr(c1) = zr * dscr / (dxyz + yr2)
    Next c1
    ' scale values and plot
    Cls
    For c1 = 0 To Nstore - 1
        ' scale coord. to screen window
        xscr(c1) = (xscr(c1) - xscrmin) * xscrscale
        yscr(c1) = (yscrmax - yscr(c1)) * yscrscale
        ' draw the data point
        If c1 = 0 Then
            PReset (xscr(c1), yscr(c1))
        Else
            Line -(xscr(c1), yscr(c1)), co(c1)
        End If
    Next c1
    _Display ' wait to update visible image until this command, runs smoother
Loop Until InKey$ <> ""


