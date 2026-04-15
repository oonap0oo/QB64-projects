' Based on program posted by Eric Schraf in FB group 'BASIC Programming Language'
' url: https://www.facebook.com/share/p/1Ef4RtrEK4/
' This version animates the lines, it makes use of some newer QB64 functions such as _Hypot()
' and _Atan2() reducing code, it also uses the window() function for coord. mapping eliminating
' pixel coordinate calculations in basic code
' This version: K Moerman 2026
' ------------------------------------------------------------------------
' A number of lines have starting points randomly distributed in a square, each line has a
' set number of segments which are dranw at angle (angle). Each new segment is drawn at angle
' defined by the angle between current end point (x,y) and x-axis, increased by angle (heading)
' and a sine component which gives visual effect of concentric rings at some moments in the animation.
' the value of (heading) ramps up periodically which animates the output
' The "Randomize using x" statement resets the sequence of pseudo random numbers, Rnd will yield
' same sequence each iteration, this avoids having to store the
' starting point coord. in arrays for redrawing each frame

Option _Explicit
Const SW = 900, SH = 600, ASP = SW / SH, Nlines = 300, Npoints = 30, DS = 0.02, DH = 1.5E-2
Dim As Integer lines, points: Dim As Single x, y, hue: Dim As Double angle, heading
Screen _NewImage(SW, SH, 32): _Title "Animated lines": Window (-ASP, -1)-(ASP, 1)
heading = 4 * _Pi / 3
Do
    _Limit 60
    Randomize Using 1
    Cls
    For lines = 0 To Nlines
        x = 2 * Rnd - 1: y = 2 * Rnd - 1: PReset (x, y)
        For points = 0 To Npoints
            angle = _Atan2(y, x) + heading + Sin(6 * _Pi * _Hypot(x, y)) / 4
            x = x + DS * Cos(angle): y = y + DS * Sin(angle): hue = 30 + 30 * Sin(points / 2)
            Line -(x, y), _HSB32(hue, 100, 100)
        Next points
    Next lines
    heading = heading + DH: If heading > 10 * _Pi / 3 Then heading = 4 * _Pi / 3
    _Display
Loop Until InKey$ <> ""
