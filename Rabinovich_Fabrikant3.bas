' Rabinovich-Fabrikant System
' For use with QB64

Option _Explicit

Const PI_2 = 2 * _Pi

'Rabinovich-Fabrikant parameters
Const Nstore = 50000 ' number of data points stored for drawing
Const Nloop = 16000 ' extra iterations for accuraxy (keep dt small)
Const T = 1000.0# ' Total time interval covered
Const alpha = 0.14#, gamma = 0.118# ' parameter of Rabinovich-Fabrikant System
Const x0 = 0.1#, y0 = -0.1#, z0 = 0.1# ' initial values of the three variables

' graphing parameters
Const XMAX = 650 ' image dimensions
Const YMAX = 550
Const margin = 30 ' margin between window edges and drawing
Const dscr = 60 ' distance eyeball to projection screen
Const dxyz = 100 ' distance eyeball to xyz axes origin
Const doffset = 60 ' speed which colors are cycled with
Const xscrmax = 1.5, yscrmax = 1.1, xscrmin = -1.5, yscrmin = -.5
Const yzangle = 15 * _Pi / 180 ' angle over which graph is rotated around x axis
Const Nxyangles = 200 ' number of animation steps for the 2 rotation axes

Dim As Long c1, c2, offset, co(Nstore)
Dim As Integer pr, pg, pb
Dim As Double x, xsq, y, z, dx_dt, dy_dt, dz_dt, dt
Dim As Single xscr, yscr, cos_yzangle, sin_yzangle, cos_xyangle, sin_xyangle
Dim As Single xscrscale, yscrscale, yr, zr, xr, yr2, angle, xyangle, dxyangle, limitxy
Dim As Single xx(Nstore), yy(Nstore), zz(Nstore)
Dim As String title

Dim Shared As Long handle ' generate window with 32bit color mode
handle = _NewImage(XMAX, YMAX, 32)
Screen handle
title = "Rabinovich-Fabrikant alpha=" + Str$(alpha) + " gamma=" + Str$(gamma)
title = title + " x0=" + Str$(x0) + " y0=" + Str$(y0) + " z0=" + Str$(z0)
_Title title
Cls

' make up colors using counter c1 and store in array co
For c1 = 0 To Nstore - 1
    angle = c1 / (Nstore - 1) * PI_2 ' angle ramps up from 0 to 2*pi
    pr = 127 + 127 * Sin(angle)
    pg = 127 + 127 * Cos(angle)
    pb = 127 + 127 * Sin(2 * angle)
    co(c1) = _RGB32(pr, pg, pb) ' convert r,g,b into color value and store in array
Next c1

' calculate and store 3D solution to Rabinovich-Fabrikant System using Euler method
dt = T / (Nstore * Nloop) ' time step for Euler Method
Print Using "dt = ####^^^^"; dt
x = x0: y = y0: z = z0 ' load initial values
For c1 = 0 To Nstore - 1
    ' extra interations to keep errors low from Euler method (smaller dt)
    For c2 = 0 To Nloop - 1
        xsq = x * x ' square of x is used two times, calc one time
        dx_dt = y * (z - 1# + xsq) + gamma * x ' three ODEs of the Rabinovich-Fabrikant System
        dy_dt = x * (3# * z + 1# - xsq) + gamma * y
        dz_dt = -2# * z * (alpha + x * y)
        x = dx_dt * dt + x: y = dy_dt * dt + y: z = dz_dt * dt + z ' Euler method
    Next c2
    xx(c1) = x: yy(c1) = y: zz(c1) = z
    If c1 Mod 2000 = 0 Then
        Locate 2, 1
        Print Using "Calculating ###%"; c1 / Nstore * 100
    End If
Next c1


' calc values once, use many times
xscrscale = (XMAX - 2 * margin) / (xscrmax - xscrmin)
yscrscale = (YMAX - 2 * margin) / (yscrmax - yscrmin)
cos_yzangle = Cos(yzangle): sin_yzangle = Sin(yzangle)

' rotate, project and plot values
offset = Nstore - 1 - doffset ' offset used to cycle the color index
dxyangle = PI_2 / Nxyangles ' the rotation angle xyangle increases with this step value
limitxy = PI_2 - dxyangle ' when angle xyangle reaches this value restore to zero
Do
    _Limit 50
    ' xyangle ramps up from 0 to almost 2*pi
    If xyangle < limitxy Then xyangle = xyangle + dxyangle Else xyangle = 0
    ' new sin and cos values for this frame
    cos_xyangle = Cos(-xyangle): sin_xyangle = Sin(-xyangle)
    Cls
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
        xscr = xr * dscr / (dxyz + yr2)
        yscr = zr * dscr / (dxyz + yr2)
        ' scale coord. to screen window
        xscr = margin + (xscr - xscrmin) * xscrscale
        yscr = margin + (yscrmax - yscr) * yscrscale
        ' draw the data point
        Line (xscr - 1, yscr - 1)-(xscr, yscr), co((c1 + offset) Mod (Nstore - 1)), B
    Next c1
    _Display
    If offset >= doffset Then offset = offset - doffset Else offset = Nstore - 1 - doffset
Loop Until InKey$ <> ""

