' Lorenz system, rotating

Option _Explicit

' calculation constants
Const Nstore = 15000 ' number of data points stored for drawing
Const Nloop = 10000 ' extra iterations to keep error of Euler method low
Const Ncolors = Nstore / 8
Const T = 150 ' Total time interval covered
Const x0 = 1.0 ' initial values of the three variables
Const y0 = 0.0
Const z0 = 1.0
Const sigma = 10 ' parameters Lorenz system
Const beta = 8 / 3
Const rho = 28

' plotting constants
Const XMAX = 550 ' image dimensions
Const YMAX = 400
Const dscr = 78 ' distance eyeball to projection screen
Const dxyz = 90 ' distance eyeball to xyz axes origin
Const Nxyangles = 200 ' number of animation steps for the 2 rotation axes
Const yzangle = 25 * _Pi / 180
Const PI_2 = 2 * _Pi
Const xscrmax = 38, yscrmax = 55, xscrmin = -38, yscrmin = -6 ' the bounds of the 2D projected values

' Variables
Dim As Long c1, c2, co(Nstore), colorindex
Dim As Integer pr, pg, pb
Dim As Double x, y, z, dx_dt, dy_dt, dz_dt, dt
Dim As Single xx(Nstore), yy(Nstore), zz(Nstore), dxyangle, limitxy
Dim As Single xscr, yscr, cos_xyangle, sin_xyangle, cos_yzangle, sin_yzangle
Dim As Single xscrscale, yscrscale, yr, yr2, xr, zr, xyangle

' generate window with 32bit color mode
Dim Shared As Long handle
handle = _NewImage(XMAX, YMAX, 32)
_Title "Lorenz System, rotating"
Screen handle
Cls

Print "Calculating"
' avoid calculating values these each iteration
xscrscale = XMAX / (xscrmax - xscrmin)
yscrscale = YMAX / (yscrmax - yscrmin)

' make up colors using counter c1 and store in array co
For colorindex = 0 To Ncolors - 1
    pr = 255 + 255 * (colorindex < (Ncolors / 2))
    pb = 255 + 255 * ((colorindex Mod (Ncolors / 2)) < (Ncolors / 4))
    pg = 255 - pb
    co(colorindex) = _RGB32(pr, pg, pb) ' convert r,g,b into color value  and store in array
Next colorindex

' calculate and store 3D solution to Lorenz equations using Euler method
dt = T / (Nstore * Nloop) ' time step for Euler Method
x = x0: y = y0: z = z0 ' load initial values
For c1 = 0 To Nstore - 1
    xx(c1) = x: yy(c1) = y: zz(c1) = z
    ' extra calculation steps to keep errors low from Euler method (smaller dt)
    For c2 = 0 To Nloop - 1
        dx_dt = sigma * (y - x) ' lorenz system with three 1st order diff. eq.
        dy_dt = x * (rho - z) - y
        dz_dt = x * y - beta * z
        x = dx_dt * dt + x: y = dy_dt * dt + y: z = dz_dt * dt + z ' Euler method
    Next c2
Next c1

' rotate, project and plot values
cos_yzangle = Cos(yzangle): sin_yzangle = Sin(yzangle) ' calc values once, use many times
dxyangle = PI_2 / Nxyangles ' the rotation angle xyangle increases with this step value
limitxy = PI_2 - dxyangle ' when angle xyangle reaches this value restore to zero
colorindex = 0
Do
    _Limit 50 ' reduce CPU load and this is 1 factor which determines animation speed
    If xyangle < limitxy Then xyangle = xyangle + dxyangle Else xyangle = 0
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
        ' draw the data point
        If c1 = 0 Then
            PReset (xscr, yscr)
        Else
            Line -(xscr, yscr), co(colorindex)
        End If
        If colorindex < Ncolors Then colorindex = colorindex + 1 Else colorindex = 0
    Next c1
    _Display ' wait to update visible image until this command, runs smoother
Loop Until InKey$ <> ""


