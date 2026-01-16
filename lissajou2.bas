' Lissajou
' --------
Option _Explicit

Const XMAX = 1000, YMAX = 800 ' image dimensions
Const MARGIN = 90 ' distance between window edge and Lissajou graph
Const MARGINSCALE = 30 ' distance between window edge and scale
Const N = 300 ' number of points for Lissajou graph
Const CO = _RGBA32(80, 255, 80, 255), COSCALE = _RGBA32(200, 200, 200, 255) ' colors for Lissajou graph and scale
Const NX = 3, NY = 5 ' frequency factors for Lissajou grap
Const NPHASE = 400 ' number of phase steps to go from 0 to 2*pi for animation

Dim As Long handlegraph, handlescale
Dim As Integer xscr, yscr, counter, xampl, yampl
Dim As Single angle, phase, dphase

' Prepare the scale on seperate image
handlescale = _NewImage(XMAX, YMAX, 32)
Screen handlescale
Line (MARGINSCALE, YMAX / 2)-(XMAX - MARGINSCALE, YMAX / 2), COSCALE
Line (XMAX / 2, MARGINSCALE)-(XMAX / 2, YMAX - MARGINSCALE), COSCALE
Line (MARGINSCALE, MARGINSCALE)-(XMAX - MARGINSCALE, YMAX - MARGINSCALE), COSCALE, B
For counter = 1 To 9
    xscr = counter / 10 * (XMAX - 2 * MARGINSCALE) + MARGINSCALE
    Line (xscr, YMAX / 2 - 10)-(xscr, YMAX / 2 + 10), COSCALE
Next counter
For counter = 1 To 7
    yscr = counter / 8 * (YMAX - 2 * MARGINSCALE) + MARGINSCALE
    Line (XMAX / 2 - 10, yscr)-(XMAX / 2 + 10, yscr), COSCALE
Next counter

' new image for lissajou graph
handlegraph = _NewImage(XMAX, YMAX, 32)
Screen handlegraph
_Title "Lissajou"
Cls

' calculating and plotting
phase = 0
dphase = 2 * _Pi / NPHASE ' value to increase phase for each animation step
xampl = (XMAX - 2 * MARGIN) / 2 'these values remain constant => more efficient to calc once
yampl = (YMAX - 2 * MARGIN) / 2
Do
    _Limit 100 ' reduce CPU load and this is 1 factor which determines animation speed
    Cls ' get rid of previous lissajou
    For counter = 0 To N - 1 ' draw new lissajou
        angle = counter / (N - 1) * 2 * _Pi
        xscr = MARGIN + xampl * (1 + Cos(NX * angle))
        yscr = MARGIN + yampl * (1 - Sin(NY * angle + phase))
        If counter = 0 Then PSet (xscr, yscr), CO Else Line -(xscr, yscr), CO
    Next counter
    _PutImage , handlescale, handlegraph ' add the image containing scale, has transparency with alpha blending
    _Display ' wait to update visible image until this command, runs smoother
    If phase <= 2 * _Pi Then phase = phase + dphase Else phase = 0 ' update phase value
Loop While InKey$ = "" ' end program when key pressed


