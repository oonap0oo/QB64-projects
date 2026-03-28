' Animation based on Logistic Map
' https://en.wikipedia.org/wiki/Logistic_map

Option _Explicit

Const xmax = 800 ' image dimensions
Const ymax = 600
Const halfxmax = xmax / 2, halfymax = ymax / 2, twothirdsymax = 2 * ymax / 3
Const Niter = 25E3 ' number of iterations in one sector
Const a_start = 3.54, a_end = 4.0 ' interval parameter a
Const a_span = a_end - a_start, a_sum = a_start + a_end ' calc once, use many times
Const Nframes = 900 ' number of frames for parameters ar, ad to ramp from min to max value
Const Nrotframes = 90 ' number of frames in one 360 deg rotation
Const fps = 30 ' frames per second
Const SQR2 = Sqr(2) ' calc once, use many times
Const HALFPI = _Pi / 2, TWOPI = 2 * _Pi
Const dscr = 2 ' distance eyeball to projection screen
Const dxyz = 3 ' distance eyeball to xyz axes origin
Const yzangle = 30 * _Pi / 180 ' angle over which graph is rotated around x axis for viewing
Const cos_yzangle = Cos(yzangle), sin_yzangle = Sin(yzangle) ' calc once, use many times
Const scale = 1.6 ' factor to enlarge the final image
Const dscrscale = dscr * scale

Dim As Long handle, counter, col
Dim As Double ar, ad1, ad2, r, d1, d2
Dim As Single angle1, angle2, x, y, z, hue, rsinangle2
Dim As Integer frame, dframe, rotation

' define window in 32 bit color
handle = _NewImage(xmax, ymax, 32)
Screen handle: _Title "Animation based on the Logistic Map"
Cls
_ScreenMove 0, 0

' main animation loop
frame = 460: ' counter to advance values of ar and ad; ramps up and down between 0 and Nframes
dframe = 1 ' value added to frame, is either +1 or -1
rotation = 0 ' counter to determine rotation angle, ramps up from 0 to Nrotframes-1
Do
    ' pace animation and free up remaining CPU cycles
    _Limit fps
    ' calc new values of Logistic Map parameters ar,ad1 and ad2
    ar = a_start + a_span * frame / Nframes
    ad1 = a_sum - ar
    ad2 = ar * 0.4 + ad1 * 0.6
    ' initial values, r is distance from origin, d prop. to angles
    r = 0.5: d1 = 0.5: d2 = 0.5
    Cls
    For counter = 1 To Niter
        ' Logistic Map iterations, r,d1 and d2 are between 0 and 1
        r = ar * r * (1 - r)
        d1 = ad1 * d1 * (1 - d1)
        d2 = ad2 * d2 * (1 - d2)
        ' calc angles out of d and rotation
        angle1 = HALFPI * (d1 + rotation / Nrotframes)
        angle2 = HALFPI * d2
        ' calc once, use 2 times
        rsinangle2 = r * Sin(angle2)
        'calc from spherical coord (r,angle1,angle2) to carth. coord (x,y,z)
        x = rsinangle2 * Cos(angle1)
        y = rsinangle2 * Sin(angle1)
        z = r * Cos(angle2)
        ' define color of point
        hue = r * 360 ' calc hue based on distance from origin r
        col = _HSB32(hue, 100, 100) ' color as long, defined with hue, sat, bri
        ' --- SECTOR 1
        drawpoint x, y, z, col
        ' --- SECTOR 2
        drawpoint -y, x, z, col
        ' --- SECTOR 3
        drawpoint -x, -y, z, col
        ' --- SECTOR 4
        drawpoint y, -x, z, col
    Next counter
    'Locate 1, 1: Print frame
    _Display ' any graphics command only becomes visible here, smoother animation
    'frame ramps up and down between 0 and Nframes
    If frame = Nframes Then
        dframe = -1
    ElseIf frame = 0 Then
        dframe = 1
    End If
    frame = frame + dframe
    ' rotation ramps up from 0 to Nrotframes-1
    rotation = (rotation + 1) Mod Nrotframes
Loop Until InKey$ <> ""


' convert 3D (x,y,z) to 2D and draw the point
Sub drawpoint (x As Single, y As Single, z As Single, col As Long)
    Dim As Single yr, zr, fproject
    Dim As Integer xscr, yscr
    ' rotate 3D coord. around x axis to tilt graph for viewing
    yr = y * cos_yzangle - z * sin_yzangle
    zr = y * sin_yzangle + z * cos_yzangle
    ' project 3D to 2D
    fproject = dscrscale / (dxyz + yr)
    xscr = halfxmax + halfymax * x * fproject
    yscr = twothirdsymax - halfymax * zr * fproject
    ' draw point
    PSet (xscr, yscr), col
End Sub
