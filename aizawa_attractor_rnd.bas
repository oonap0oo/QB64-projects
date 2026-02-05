' Aizawa Attractor
' For use with QB64 Phoenix Edition

Option _Explicit
Const Nstore = 5000 ' number of data points stored for drawing
Const Nloop = 4000 ' extra iterations for accuracy (keep dt small)
Const T = 40 ' Total time interval covered
Const a = 0.95 'Aizawa Attractor parameters
Const b = 0.7
Const c = 0.6
Const d = 3.5
Const e = 0.25
Const f = 0.1

' graphing parameters
Const XMAX = 650, yMAX = 650 ' image dimensions
Const margin = 30 ' margin between window edges and drawing
Const yzangle = 45 * _Pi / 180 ' angle over which graph is rotated around x axis
Const xyangle = 20 * _Pi / 180 ' angle over which graph is rotated around z axis
Const dscr = 30 ' distance eyeball to projection screen
Const dxyz = 45 ' distance eyeball to xyz axes origin

Dim As Long c1, c2, co
Dim As Integer pr, pg, pb, r
Dim As Double x, xsq, y, z, dx_dt, dy_dt, dz_dt, dt
Dim As Single xscr(Nstore), yscr(Nstore), cos_yzangle, sin_yzangle, cos_xyangle, sin_xyangle
Dim As Single xscrmax, yscrmax, xscrmin, yscrmin, xscrscale, yscrscale, yr, zr, xr, yr2
Dim As String title

Randomize Timer ' make sure Rnd gives different numbers each time the program runs

Dim Shared As Long handle ' generate window with 32bit color mode
handle = _NewImage(XMAX, yMAX, 32)
Screen handle
title = "Aizawa Attractor"
_Title title
Cls

cos_yzangle = Cos(yzangle): sin_yzangle = Sin(yzangle) ' calc values once, use many times
cos_xyangle = Cos(xyangle): sin_xyangle = Sin(xyangle)
dt = T / (Nstore * Nloop) ' time step for Euler Method
For r = 1 To 20 ' several runs each with different init. values and plot color
    x = Rnd * 0.1: y = 0: z = 0.05 ' initial values with some randomness
    pr = 255 + (Rnd > .5) * 255 ' make up random colors
    pg = 255 + (Rnd > .5) * 255 ' pr,pg,pb are either 0 or 255 randomly
    pb = 255 + (Rnd > .5) * 255
    co = _RGB32(pr, pg, pb) ' convert r,g,b into 32 bit color value
    For c1 = 0 To Nstore - 1
        ' rotate 3D coord. around x axis to tilt graph for viewing
        ' |cos -sin| |x| rotation matrix
        ' |sin  cos| |y|
        yr = y * cos_yzangle - z * sin_yzangle
        zr = y * sin_yzangle + z * cos_yzangle
        ' rotate 3D coord. around z axis to tilt graph for viewing
        xr = x * cos_xyangle - yr * sin_xyangle
        yr2 = x * sin_xyangle + yr * cos_xyangle
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
            xsq = x * x
            dx_dt = (z - b) * x - d * y ' three ODEs of the Aizawa Attractor
            dy_dt = d * x + (z - b) * y
            dz_dt = c + a * z - z * z * z / 3.0 - (xsq + y * y) * (1 + e * z) + f * z * x * xsq
            x = dx_dt * dt + x: y = dy_dt * dt + y: z = dz_dt * dt + z ' Euler method
        Next c2
    Next c1
    xscrscale = (XMAX - 2 * margin) / (xscrmax - xscrmin) ' avoid calculating these each time
    yscrscale = (yMAX - 2 * margin) / (yscrmax - yscrmin)
    For c1 = 0 To Nstore - 1 ' scale and draw xscr,ysxr array values
        xscr(c1) = margin + (xscr(c1) - xscrmin) * xscrscale ' scale coord. to screen window
        yscr(c1) = margin + (yscrmax - yscr(c1)) * yscrscale
        PSet (xscr(c1), yscr(c1)), co
    Next c1
Next r

Sleep

