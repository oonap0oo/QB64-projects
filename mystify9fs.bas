' Mystify screensaver recreated
' the number of shapes can be specified
' each shape has a adjustable number of corner points
' each shape moves and has trails following it, the first shape is trail 0

Option _Explicit
Randomize Timer

Const fullscreen = _FALSE 'run fullscreen if true, run in window if false
Const windwidth = 1024 / 1.5, windheight = 768 / 1.5 'dimensions of window, ignored if fullscreen
Const fps = 60 ' number of animation frames per second
Const stepsize = 1 ' distance in pixels each point coord. changes between frames
Const Npoints = 4 ' number of points in each shape, windows Mystify used 4
Const Nshapes = 3 ' number of different colored shapes to be created
Const Ntrail = 8 ' number of trails for each shape
Const trailsep = 10 ' seperations between trails of each shape
Const alphadropoff = 200 ' specifies how much fainter the last trail is drawn compared to 1st

' create a 32 bit color screen
Dim As Long handle
Dim Shared As Integer xmax, ymax
If fullscreen Then
    xmax = _DesktopWidth ' get current screen resolution dimensions
    ymax = _DesktopHeight ' reported values are smaller then reality due to ms windows scaling
    handle = _NewImage(xmax, ymax, 32)
    Screen handle
    _FullScreen
Else
    xmax = windwidth ' for version in window
    ymax = windheight
    handle = _NewImage(xmax, ymax, 32)
    Screen handle
    _Title "Mystify, screensaver recreated"
End If

Dim Shared As Integer x(Npoints, Nshapes, Ntrail), y(Npoints, Nshapes, Ntrail)
Dim Shared As Integer dx(Npoints, Nshapes, Ntrail), dy(Npoints, Nshapes, Ntrail)
Dim Shared As Long co(Nshapes, Ntrail)

Dim As Integer shape, trail

' init trail O of all shapes with random points coord. x,y and step directions dx, dy
initfirsttrail

' init colors of all trails of all shapes to include reducing alpha for successive trails
initallcolors

' advance points of trail 0 of all shapes and
' copy coords to successive trails at right moments
' advance points of trail 0 of all shapes to create separation between trail 0 and 1
initremainingtrails

' main animation loop start drawing from here
Do
    _Limit fps ' pace animation and free up CPU time in between frames
    Cls
    For trail = 0 To Ntrail - 1 ' draw all trails of all shapes
        For shape = 0 To Nshapes - 1
            drawshape trail, shape, co(shape, trail)
        Next shape
    Next trail
    _Display ' wait to update visible window with all graphics commands until here
    nextstep ' trails have been init. now update all of them using dx and dy
    While _MouseInput 'exit if left mouse button pressed
        If _MouseButton(1) Then Exit Do
    Wend
Loop Until InKey$ <> "" ' exit if key pressed
End
'Sleep
'report

'initialise first trail of each shape with coord x,y step directions dx,dy
Sub initfirsttrail
    Dim As Integer shape, pnt
    For shape = 0 To Nshapes - 1
        For pnt = 0 To Npoints - 1
            x(pnt, shape, 0) = Rnd * xmax
            y(pnt, shape, 0) = Rnd * ymax
            dx(pnt, shape, 0) = (1 + 2 * (Rnd < .5)) * stepsize ' is either -stepsize of +stepsize
            dy(pnt, shape, 0) = (1 + 2 * (Rnd < .5)) * stepsize
        Next pnt
    Next shape
End Sub

' initialise color of trail 0 of all shapes
' vary the hue with maximum saturation, brightness of 255
' trail 0 color is opaque, so alpha is also maximum of 255
Sub initallcolors
    Dim As Integer shape, h
    For shape = 0 To Nshapes - 1
        h = 250 * shape / (Nshapes - 1)
        co(shape, 0) = _HSBA32(h, 255, 255, 255)
    Next shape
End Sub

' make the successive trails folow trail 0 with specified separation
Sub initremainingtrails
    Dim As Integer trail2init, loopcounter
    ' advance points of trail 0 of all shapes and
    ' copy coords to successive trails at right moments
    For trail2init = Ntrail - 1 To 1 Step -1 ' furthest trail is initialised first
        For loopcounter = 0 To trailsep / stepsize
            startstep
        Next loopcounter
        updatetrails trail2init ' copy coord. of trail0 to trail number trail2init
    Next trail2init
    ' advance points of trail 0 of all shapes to create separation between trail 0 and 1
    For loopcounter = 0 To trailsep / stepsize
        startstep
    Next loopcounter
End Sub



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

' during initialisation of the trails, update point coord. of first trail using dx and dy
Sub startstep
    Dim As Integer pnt, shape
    For shape = 0 To Nshapes - 1
        For pnt = 0 To Npoints - 1
            x(pnt, shape, 0) = x(pnt, shape, 0) + dx(pnt, shape, 0)
            y(pnt, shape, 0) = y(pnt, shape, 0) + dy(pnt, shape, 0)
            If x(pnt, shape, 0) >= xmax Or x(pnt, shape, 0) <= 0 Then dx(pnt, shape, 0) = -dx(pnt, shape, 0)
            If y(pnt, shape, 0) >= ymax Or y(pnt, shape, 0) <= 0 Then dy(pnt, shape, 0) = -dy(pnt, shape, 0)
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
                If x(pnt, shape, trail) >= xmax Or x(pnt, shape, trail) <= 0 Then dx(pnt, shape, trail) = -dx(pnt, shape, trail)
                If y(pnt, shape, trail) >= ymax Or y(pnt, shape, trail) <= 0 Then dy(pnt, shape, trail) = -dy(pnt, shape, trail)
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


