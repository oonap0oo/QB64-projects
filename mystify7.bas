' Mystify screensaver recreated
Option _Explicit
Randomize Timer

Const XMAX = 640 ' image dimensions
Const YMAX = 480
Const Npoints = 4 ' number of points in each shape, windows Mystify used 4
Const Nshapes = 3 ' number of different colored shapes to be created
Const Ntrail = 8 ' number of trails for each shape
Const trailsep = 10 ' seperations between trails of each shape
Const alphadropoff = 200 ' specifies how much fainter the last trail is drawn compared to 1st

Dim Shared As Long handle ' generate window with 32bit color mode
handle = _NewImage(XMAX, YMAX, 32)
Screen handle
_Title "Mystify"
Cls

Dim Shared As Integer x(Npoints, Nshapes, Ntrail), y(Npoints, Nshapes, Ntrail)
Dim Shared As Integer dx(Npoints, Nshapes, Ntrail), dy(Npoints, Nshapes, Ntrail)
Dim Shared As Long co(Nshapes, Ntrail)

Dim As Integer pnt, shape, trail, r, g, b, alpha, loopcounter, trail2init

'initialise first trail of each shape with coord x,y step directions dx,dy
For shape = 0 To Nshapes - 1
    For pnt = 0 To Npoints - 1
        x(pnt, shape, 0) = Rnd * XMAX
        y(pnt, shape, 0) = Rnd * YMAX
        dx(pnt, shape, 0) = 1 + 2 * (Rnd < .5) ' is either -1 or 1
        dy(pnt, shape, 0) = 1 + 2 * (Rnd < .5)
    Next pnt
Next shape

' initialise color of all shapes and trails
For shape = 0 To Nshapes - 1
    r = (shape * 120) Mod 255 ' make up rgb components using modular division
    g = (shape * 230) Mod 255
    b = 255 - r
    co(shape, 0) = _RGBA32(r, g, b, 255)
Next shape

' main animation loop
loopcounter = 0: trail2init = Ntrail - 1
Do
    If trail2init > 0 Then ' initialise trails of all shapes
        If loopcounter < trailsep Then 'wait for enough sepration to init. next trail
            loopcounter = loopcounter + 1
        Else
            loopcounter = 0 ' time to init next trail
            updatetrails trail2init ' another trail to take coords. of first shape
            trail2init = trail2init - 1
        End If
        startstep ' trails still being initialised, only update first trail using dx and dy
    ElseIf trail2init = 0 Then ' all trails have coords. wait for enough sepration between trail 0 and 1
        If loopcounter < trailsep Then
            loopcounter = loopcounter + 1
        Else
            trail2init = trail2init - 1
        End If
        startstep ' still only update first trail using dx and dy
    Else ' intialisation has finished, normal run
        _Limit 60 ' limits loop speed and frees CPU
        Cls
        For trail = 0 To Ntrail - 1 ' draw all shapes
            For shape = 0 To Nshapes - 1
                drawshape trail, shape, co(shape, trail)
            Next shape
        Next trail
        _Display ' wait to update visible window with all graphics commands until here
        nextstep ' trails have been init. now update all of them using dx and dy
    End If
Loop Until InKey$ <> ""
'Sleep
'report

' copy data from first trail to a specified trail during initialisation
Sub updatetrails (trail)
    Dim As Integer pnt, shape, r, g, b, alpha
    For shape = 0 To Nshapes - 1
        For pnt = 0 To Npoints - 1
            x(pnt, shape, trail) = x(pnt, shape, 0)
            y(pnt, shape, trail) = y(pnt, shape, 0)
            dx(pnt, shape, trail) = dx(pnt, shape, 0)
            dy(pnt, shape, trail) = dy(pnt, shape, 0)
        Next pnt
        r = _Red(co(shape, 0)): g = _Green(co(shape, 0)): b = _Blue(co(shape, 0))
        alpha = 255 - trail / Ntrail * alphadropoff
        co(shape, trail) = _RGBA(r, g, b, alpha)
    Next shape
End Sub

' during initialisation of the trails,update point coord. of first trail using dx and dy
Sub startstep
    Dim As Integer pnt, shape
    For shape = 0 To Nshapes - 1
        For pnt = 0 To Npoints - 1
            x(pnt, shape, 0) = x(pnt, shape, 0) + dx(pnt, shape, 0)
            y(pnt, shape, 0) = y(pnt, shape, 0) + dy(pnt, shape, 0)
            If x(pnt, shape, 0) >= XMAX Or x(pnt, shape, 0) <= 0 Then dx(pnt, shape, 0) = -dx(pnt, shape, 0)
            If y(pnt, shape, 0) >= YMAX Or y(pnt, shape, 0) <= 0 Then dy(pnt, shape, 0) = -dy(pnt, shape, 0)
        Next pnt
    Next shape
End Sub

' once all trails are initialised, update point coord. using dx and dy
' change sign of dx or dy if point touches edge of screen
Sub nextstep
    Dim As Integer pnt, shape, trail
    For trail = 0 To Ntrail - 1
        For shape = 0 To Nshapes - 1
            For pnt = 0 To Npoints - 1
                x(pnt, shape, trail) = x(pnt, shape, trail) + dx(pnt, shape, trail)
                y(pnt, shape, trail) = y(pnt, shape, trail) + dy(pnt, shape, trail)
                If x(pnt, shape, trail) >= XMAX Or x(pnt, shape, trail) <= 0 Then dx(pnt, shape, trail) = -dx(pnt, shape, trail)
                If y(pnt, shape, trail) >= YMAX Or y(pnt, shape, trail) <= 0 Then dy(pnt, shape, trail) = -dy(pnt, shape, trail)
            Next pnt
        Next shape
    Next trail
End Sub

' draw 1 specified trail of specified shape using specified color
Sub drawshape (trail As Integer, shape As Integer, co As Long)
    Dim As Integer pnt
    PReset (x(0, shape, trail), y(0, shape, trail)) 'preset first point
    For pnt = 1 To Npoints - 1
        Line -(x(pnt, shape, trail), y(pnt, shape, trail)), co
    Next pnt
    Line -(x(0, shape, trail), y(0, shape, trail)), co 'complete the closed figure
End Sub

' only used for diagnostics, not called normally
Sub report
    Dim As Integer pnt, shape, trail
    For shape = 0 To Nshapes - 1
        For trail = 0 To Ntrail - 1
            For pnt = 0 To Npoints - 1
                Print x(pnt, shape, trail); y(pnt, shape, trail); _Red(co(shape, trail));
                Print _Green(co(shape, trail)); _Blue(co(shape, trail)); _Alpha(co(shape, trail))
            Next pnt
            Print
        Next trail
    Next shape
End Sub

