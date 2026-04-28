' Morphing Bubble Universe, based on algoritm found on many places on the web
' this version K Moerman 2026
' example used as reference, in Sinclair Basic on a PC by BigEd:
' https://stardot.org.uk/forums/viewtopic.php?t=25833
' This version morphs the output during animation using variable a

Option _Explicit

Const SPIXELS = 650, FPS = 30, Nshapes = 300, Npoints = 230, DT = 1E-3
Const R = 2 * _Pi / Nshapes, Fhue = 360 / Nshapes, DS = 1 / SPIXELS

Dim As Double x, y, t, ang_y, shape_t, ang_x, a, zoom
Dim As Integer shape, pnt

Screen _NewImage(SPIXELS, SPIXELS, 32) ' create 32 bit color window
_Title "Bubble Universe, morphing": Cls: _ScreenMove 0, 0

t = 0: x = 0: y = 0
Do
    _Limit FPS ' pace animation, release remaining CPU
    a = Cos(3 * t): zoom = Abs(a) + 1.1 ' factor a influences the iteration equations
    Window (-zoom, -zoom)-(zoom, zoom): Cls ' zoom changes during animation to keep image in frame
    For shape = 0 To Nshapes - 1 ' outer loop draws 1 frame containing (Nshapes) shapes
        shape_t = R * shape + t
        For pnt = 0 To Npoints - 1 ' inner loop draws 1 spiral or other shape made from (Npoints) points
            ang_y = shape + y: ang_x = shape_t + x ' during inner loop only x and y change
            x = Sin(ang_y) + a * Sin(ang_x) ' factor a cycles between -1 and +1 during animation
            y = a * Cos(ang_y) + Cos(ang_x)
            Line (x, y)-Step(DS, DS), _HSB32(shape * Fhue, pnt + 20, pnt + 25), B
        Next pnt
    Next shape
    _Display
    t = t + DT ' time variable
Loop Until InKey$ <> ""

