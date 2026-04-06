' Bubble Universe, algoritm found on many places on the web, this version K Moerman 2026
' example used as reference, in Sinclair Basic on a PC by BigEd:
' https://stardot.org.uk/forums/viewtopic.php?t=25833

Option _Explicit

Const HPIXELS = 900, VPIXELS = 670, FPS = 30, MAXY = 2.0
Const Nshapes = 200, Npoints = 350, DT = 2E-3
Const R = 2 * _Pi / Nshapes, MAXX = MAXY * HPIXELS / VPIXELS, Fhue = 360 / Nshapes

Dim As Double x, y, t, ang_y, shape_t, ang_x
Dim As Integer shape, pnt

Screen _NewImage(HPIXELS, VPIXELS, 32) ' create 32 bit color window
_Title "Bubble Universe": Cls: _ScreenMove 0, 0
Window (-MAXX, -MAXY)-(MAXX, MAXY) ' coordinates automatically mapped

t = 0: x = 0: y = 0
Do
    _Limit FPS ' pace animation, release remaining CPU
    Cls
    For shape = 0 To Nshapes - 1 ' outer loop draws 1 frame containing (Nshapes) shapes
        shape_t = R * shape + t
        For pnt = 0 To Npoints - 1 ' inner loop draws 1 spiral or other shape made from (Npoints) points
            ang_y = shape + y: ang_x = shape_t + x
            x = Sin(ang_y) + Sin(ang_x)
            y = Cos(ang_y) + Cos(ang_x)
            PSet (x, y), _HSB32(shape * Fhue, pnt + 20, pnt + 25)
        Next pnt
    Next shape
    _Display
    t = t + DT
Loop Until InKey$ <> ""

