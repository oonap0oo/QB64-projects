' Rotating Galaxy based on code shown by Eric Schraf in a post in
' the FB group "BASIC Programming Language":
' https://www.facebook.com/groups/2057165187928233/permalink/3970851503226249/
' This version animates the galaxy by making it rotate. K Moerman 2026
' It uses a simpified algoritm to generate the galaxy image
' The statement "Randomize Using 1" resets the pseudorandom sequence and makes
' the Rnd function yield the same sequence of numbers each iteration which
' is used to generate the same points but in rotated images for each frame of the animation

Option _Explicit
$Color:32
Const DROTAT = 2 * _Pi / 900
Dim As Integer n: Dim As _Unsigned Long c
Dim As Single distance, angle, u, v, x, y, xt, yt, cos_dist, sin_dist, rotat

Screen _NewImage(800, 600, 32): Window Screen(-32, -24)-(32, 24): _Title "Rotating galaxy"
rotat = 0
Do
    _Limit 60
    Cls
    Randomize Using 1
    For n = 1 To 20000
        ' generate cloud of points, more of them near centre
        distance = Log(Rnd + 4.54E-05) ' random distance from center, exponentially distributed 0 to -10
        angle = 2 * _Pi * Rnd ' random angle 0 to 2pi radians
        u = 6 * distance * Sin(angle): v = 5 * distance * Cos(angle)
        ' re-arange points to give spiralling arms and rotate for animation
        ' point gets more rotation if further from center
        cos_dist = Cos(3 * distance + rotat): sin_dist = Sin(3 * distance + rotat)
        x = u * cos_dist + v * sin_dist: y = -u * sin_dist + v * cos_dist
        ' add randomness, makes arms appear more fuzzy
        y = y + Rnd * 3 - 1.5
        ' give galaxy it's 3D looking tilt
        xt = 1.4 * x + 0.6 * y: yt = 0.2 * x + 0.8 * y
        ' sample pixel and increase the color value
        c = Point(xt, yt)
        If c <> -1 Then
            Select Case c ' revisited pixels "heat up" by changing colors
                Case Black: c = Red
                Case Red: c = Orange
                Case Orange: c = Yellow
                Case Else: c = White
            End Select
            Line (xt, yt)-Step(.08, .08), c, B
        End If
    Next n
    _Display
    rotat = rotat + DROTAT: If rotat > 2 * _Pi - DROTAT Then rotat = 0
Loop Until InKey$ <> ""
