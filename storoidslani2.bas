' Super Toroid         K Moerman 2026
' using information from FB post"Super Toroid" by Mathswithmuza
' https://www.facebook.com/share/r/1CrtP9rFBe/
'
' n is even pos. integer greater then 2
' t is positive integer
'
' R = [cos(v)^n + sin(v)^n] ^ (-1/n)
' x = [4 + R * cos(t * u + v)] * cos(u)
' y = [4 + R * cos(t * u + v)] * sin(u)
' z = R * sin(t*u + v)
'
' O =< u =< 2*PI
' O =< v =< 2*PI

' modifications:
' visualise as 3D line curve iso. surface
' constant animated rotation of figure around z axis by adding angle
' fixed rotation around x axis for viewing

Option _Explicit

Const TWOPI = 2 * _Pi
Const SW = 800, SH = 520, ASP = SW / SH ' height and width of display, aspect ratio
Const NSPIRALS = 250, NSTEPS = 60 'NSPIRALS: total n spirals, NSTEPS: number of steps in 1 spiral
Const DV = TWOPI / NSTEPS
Const ANISTEPS = 1200 ' number of frames for one rotation of the figure
Const N = 10, INVN = 1 / N ' N defines profile shape of toroid
Const T = 6, T2 = (T / NSPIRALS + 1) ' T: defines number of twists around toroid
Const dscr = 5 ' distance eyeball to projection screen
Const dxyz = 10 ' distance eyeball to xyz axes origin
Const SC = 2.2, SHIFTV = 0.7 ' SC: scale factor, SHIFTV: vertical shift of image
Const YZANGLE = 25 * _Pi / 180 'fixed rotation angle around x axis for viewing
Const CYZ = Cos(YZANGLE), SYZ = Sin(YZANGLE)

Dim As Single v_ani, v, r, x, y, yr, z, zr, xscr, yscr, hue, ani, proj
Dim As Single rshape(NSPIRALS * NSTEPS): Dim As Long k

Screen _NewImage(SW, SH, 32): Window (-SC * ASP, -SHIFTV - SC)-(SC * ASP, SC - SHIFTV)
_Title "Super Toroid": _ScreenMove 0, 0

' pre-calculate rshape values and store in array
v = 0
For k = 0 To NSPIRALS * NSTEPS - 1
    rshape(k) = 1 / (Cos(v) ^ N + Sin(v) ^ N) ^ INVN
    v = v + DV
Next k

Do
    For ani = 0 To TWOPI Step TWOPI / ANISTEPS
        _Limit 60
        Cls
        v = 0 'variable ramps from 0 to NSPIRALS*2*PI to caluclate x,y,z from
        For k = 0 To NSPIRALS * NSTEPS - 1
            r = 4 + rshape(k) * Cos(T2 * v)
            v_ani = v / NSPIRALS + ani 'add variable (ani) to rotate around z axis
            x = r * Cos(v_ani)
            y = r * Sin(v_ani)
            z = rshape(k) * Sin(T2 * v)
            ' fixed rotation around x axis
            yr = y * CYZ - z * SYZ: zr = y * SYZ + z * CYZ
            ' project to 2D screen
            proj = dscr / (dxyz + yr)
            xscr = x * proj: yscr = zr * proj
            ' define color and plot
            hue = _R2D(v) Mod 360
            If v = 0 Then
                PReset (xscr, yscr)
            Else
                Line -(xscr, yscr), _HSB32(hue, 100, 100)
            End If
            v = v + DV
        Next k
        _Display
    Next ani
Loop

