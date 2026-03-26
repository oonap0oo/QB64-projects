' Animation based on Logistoc Map
' https://en.wikipedia.org/wiki/Logistic_map

Option _Explicit

Const imsize = 600 ' image dimensions
Const halfimsize = imsize / 2
Const Niter = 2.5E4 ' number of iterations in one frame
Const a_start = 3.55, a_end = 4.0 ' interval parameter a
Const Nframes = 300 ' number of frames for parameters ar, ad to ramp from min to max value
Const Nrotframes = 175 ' number of frames in one 360 deg rotation
Const fps = 60 ' frames per second
Const SQR2 = Sqr(2) ' calc once, use many times
Const HALFPI = _Pi / 2

Dim As Long handle, counter, frame, col
Dim As Double ar, ad, r, d, angle, a_span, a_sum, hue, rcosangle, rsinangle
Dim As Integer dframe, rotation, xscr, yscr
Dim As String title


' define window in 32 bit color
title = "Animation based on the Logistic Map"
handle = _NewImage(imsize, imsize, 32)
Screen handle: _Title title
Cls

a_span = a_end - a_start: a_sum = a_start + a_end ' some values calc. once, used many times
frame = 0 ' counter to advance values of ar and ad; ramps up and down between 0 and Nframes
dframe = 1 ' value added to frame, is either +1 or -1
rotation = 0 ' counter to determine rotation angle, ramps up from 0 to Nrotframes-1
Do
    _Limit fps ' pace animation and free up remaining CPU cycles
    ar = a_start + a_span * frame / Nframes ' calc new values of Logistic Map parameters ar and ad
    ad = a_sum - ar
    r = 0.5: d = 0.5 ' initial values, r is distance from origin, d prop. to angle
    Cls
    For counter = 1 To Niter
        r = ar * r * (1 - r) ' Logistic Map iterations, r and d are in 0..1
        d = ad * d * (1 - d)
        angle = HALFPI * (d + rotation / Nrotframes) ' calc angle out of d and rotation, is in 0..pi
        hue = r * 360 ' calc hue based on distance from origin r
        col = _HSB32(hue, 100, 100) ' color as long, defined with hue, sat, bri
        rcosangle = r * Cos(angle): rsinangle = r * Sin(angle) ' calc. once, used 4 times
        xscr = halfimsize * (1 + rcosangle) ' calc. screen coord. for first sector
        yscr = halfimsize * (1 + rsinangle)
        PSet (xscr, yscr), col
        xscr = halfimsize * (1 - rsinangle) ' adding pi/2 to first sector
        yscr = halfimsize * (1 + rcosangle)
        PSet (xscr, yscr), col
        xscr = halfimsize * (1 - rcosangle) ' adding pi to first sector
        yscr = halfimsize * (1 - rsinangle)
        PSet (xscr, yscr), col
        xscr = halfimsize * (1 + rsinangle) ' adding 3*pi/2 to first sector
        yscr = halfimsize * (1 - rcosangle)
        PSet (xscr, yscr), col
    Next counter
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


