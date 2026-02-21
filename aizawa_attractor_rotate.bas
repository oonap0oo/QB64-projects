' Aizawa Attractor, rotating

Option _Explicit

' calculation constants
Const Nstore = 8000 ' number of data points stored for drawing
Const Nloop = 10000 ' extra iterations to keep error of Euler method low
Const T = 60 ' Total time interval covered
Const a = 0.95 'Aizawa Attractor parameters
Const b = 0.7
Const c = 0.6
Const d = 3.5
Const e = 0.25
Const f = 0.1

' plotting constants
Const XMAX = 500: Const YMAX = 500 ' image dimensions
Const dscr = 78 ' distance eyeball to projection screen
Const dxyz = 90 ' distance eyeball to xyz axes origin
Const Nxyangles = 200 ' number of animation steps for the 2 rotation axes
Const yzangle = 25 * _Pi / 180 ' fixed angle for rotation around x axis
Const PI_2 = 2 * _Pi
Const xscrmax = 1.42, yscrmax = 1.83, xscrmin = -1.42, yscrmin = -0.71 ' the bounds of the 2D projected values

' Variables
Dim As Long c1, c2, co(Nstore)
Dim As Integer pr, pg, pb
Dim As Double x, xsq, y, z, dx_dt, dy_dt, dz_dt, dt
Dim As Single xx(Nstore), yy(Nstore), zz(Nstore), dxyangle, limitxy
Dim As Single xscr, yscr, cos_xyangle, sin_xyangle, cos_yzangle, sin_yzangle
Dim As Single xscrscale, yscrscale, yr, yr2, xr, zr, xyangle, angle

' generate window with 32bit color mode
Dim Shared As Long handle
handle = _NewImage(XMAX, YMAX, 32)
_Title "Aizawa Attractor, rotating"
Screen handle
Cls

Print "Calculating"
' avoid calculating values these each iteration
xscrscale = XMAX / (xscrmax - xscrmin)
yscrscale = YMAX / (yscrmax - yscrmin)

' make up colors using counter c1 and store in array co
For c1 = 0 To Nstore - 1
    angle = c1 / (Nstore - 1) * PI_2 ' angle ramps up from 0 to 2*pi
    pr = 127 + 127 * Sin(angle)
    pg = 127 + 127 * Cos(angle)
    pb = 255 - pg
    co(c1) = _RGB32(pr, pg, pb) ' convert r,g,b into color value and store in array
Next c1

' calculate and store 3D solution to Aizawa Attractor using Euler method
dt = T / (Nstore * Nloop) ' time step for Euler Method
x = 0.071: y = 0: z = 0.05 ' initial values
For c1 = 0 To Nstore - 1
    xx(c1) = x: yy(c1) = y: zz(c1) = z
    ' extra calculation steps to keep errors low from Euler method (smaller dt)
    For c2 = 0 To Nloop - 1
        xsq = x * x
        dx_dt = (z - b) * x - d * y ' three ODEs of the Aizawa Attractor
        dy_dt = d * x + (z - b) * y
        dz_dt = c + a * z - z * z * z / 3.0 - (xsq + y * y) * (1 + e * z) + f * z * x * xsq
        x = dx_dt * dt + x: y = dy_dt * dt + y: z = dz_dt * dt + z ' Euler method
    Next c2
Next c1

' rotate, project and plot values
cos_yzangle = Cos(yzangle): sin_yzangle = Sin(yzangle) ' calc values once, use many times
dxyangle = PI_2 / Nxyangles ' the rotation angle xyangle increases with this step value
limitxy = PI_2 - dxyangle ' when angle xyangle reaches this value restore to zero
Do
    _Limit 50 ' reduce CPU load and this is 1 factor which determines animation speed
    ' xyangle ramps up from 0 to almost 2*pi
    If xyangle < limitxy Then xyangle = xyangle + dxyangle Else xyangle = 0
    ' new sin and cos values for this frame
    cos_xyangle = Cos(-xyangle): sin_xyangle = Sin(-xyangle)
    Cls
    For c1 = 0 To Nstore - 1
        ' rotate 3D coord. around z axis with varying angle for rotation
        ' |cos -sin| |x|
        ' |sin  cos| |y|
        xr = xx(c1) * cos_xyangle - yy(c1) * sin_xyangle
        yr = xx(c1) * sin_xyangle + yy(c1) * cos_xyangle
        ' rotate 3D coord. around x axis with fixed angle to tilt graph for viewing
        yr2 = yr * cos_yzangle - zz(c1) * sin_yzangle
        zr = yr * sin_yzangle + zz(c1) * cos_yzangle
        'calculate projected coordinates: 3D to 2D
        xscr = xr * dscr / (dxyz + yr2)
        yscr = zr * dscr / (dxyz + yr2)
        ' scale coord. to screen window
        xscr = (xscr - xscrmin) * xscrscale
        yscr = (yscrmax - yscr) * yscrscale
        ' draw the data point using a 2x2 filled box for nicer result
        Line (xscr - 1, yscr - 1)-(xscr, yscr), co(c1), BF
    Next c1
    _Display ' wait to update visible image until this command, runs smoother
Loop Until InKey$ <> ""


