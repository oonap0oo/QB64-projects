'Flying things...
Option _Explicit
Randomize Timer

'--------------------------------------------------------
' path to png image file to be used, modify if needed
' specifying just the name works if the png image file is
' located in same dir as compiled exe
' if not found a dialog box will be used to specify path
Const defaultfilen = "flyer.png"
'--------------------------------------------------------
Const fullscreen = _TRUE 'run fullscreen if true, run in window if false
Const windwidth = 1200 / 1.5, windheight = 800 / 1.5 'dimensions of window, ignored if fullscreen
Const fps = 60 ' number of animation frames per second
Const N = 60 ' number of flying things
Const maxw = 200 / 1.5, minw = 10 'end and start width of the flying things as they grow in size
Const speedfactor = 1 / 60 ' influences step size of x and y of eech thing
Const dw = 0.75 ' step size of width increase of each thing
Const plusdalpha = 4, mindalpha = 10
Const Ncol = 6
Const fullwhite = _RGBA32(255, 255, 255, 255)
Const blackalmosttransparant = _RGBA32(0, 0, 0, 1)


Dim Shared As Long flyerhnd(Ncol), screenhnd, currflyerhnd
Dim Shared As Integer xmax, ymax, flyerw, flyerh
Dim Shared As Single aspectratio
Dim Shared As Integer flyercol(N), alpha(N)
Dim Shared As Single x(N), y(N), dx(N), dy(N), w(N)
Dim Shared As String filen
Dim As Integer c

' verify image file exists
If _FileExists(defaultfilen) Then ' if the default file found in same dir as exe
    filen = defaultfilen
Else
    filen = _OpenFileDialog$("Open image file", , "*.png", "Image files")
End If

generateimages ' load png image and create different colored versions

generatescreen ' create a screen image to draw on

' init. N things with their x,y,dx,dy,dw values and colors
For c = 0 To N - 1
    initflyer c
Next c

' main animation loop
aspectratio = flyerh / flyerw
Do
    _Limit fps ' pace animation and free remaining cpu time
    For c = 0 To N - 1
        ' if flyer has reached max size -> start making it transparant
        If w(c) >= maxw Then
            If alpha(c) >= mindalpha Then
                alpha(c) = alpha(c) - mindalpha
                advanceflyer (c)
            Else
                initflyer c ' if enough transparant then reinit
            End If
        ElseIf flyerleftscr%(c) Then ' if flyer exits screen -> reinit
            initflyer c
        Else ' if not move the thing along
            ' go from transparent to fully opaque
            If alpha(c) <= 255 - plusdalpha Then alpha(c) = alpha(c) + plusdalpha
            advanceflyer (c) ' move flyer and increase size
        End If
    Next c
    Cls
    For c = 0 To N - 1
        If alpha(c) < 255 Then ' if not fully opaque make copy and reduce it's alpha
            ' currentflyer is one of the colored versions
            currflyerhnd = _CopyImage(flyerhnd(flyercol(c)))
            ' reduce the alpha of this copy
            _SetAlpha alpha(c), blackalmosttransparant To fullwhite, currflyerhnd
            ' place the image on the screen
            placeimage c, currflyerhnd
            _FreeImage currflyerhnd ' copy can be disgarded from memory
        Else ' if fully opague just use the original, no need for the extra steps above
            placeimage c, flyerhnd(flyercol(c))
        End If
    Next c
    _Display ' wait until this command to update visible display, runs smoother
Loop Until InKey$ <> ""

' init all values needed for the one flying object at index c  in the arrays
Sub initflyer (c As Integer)
    Dim k As Integer
    x(c) = xmax * Rnd ' start somewhere on screen
    y(c) = ymax * Rnd
    dx(c) = (x(c) - xmax / 2) * speedfactor ' direction and speed depends on start position
    dy(c) = (y(c) - ymax / 2) * speedfactor
    w(c) = minw ' width starts at minimum
    flyercol(c) = Rnd * (Ncol - 1) ' choose one of the color variants
    alpha(c) = 0 ' starts fully transparant
    ' the newly init. flyer moves to start of array and will be drawn first
    ' so that any older flyer overlaps it in the final image
    ' all flyers ranked below it's original index c have to move up
    For k = c To 1 Step -1
        Swap x(k), x(k - 1)
        Swap y(k), y(k - 1)
        Swap dx(k), dx(k - 1)
        Swap dy(k), dy(k - 1)
        Swap w(k), w(k - 1)
        Swap flyercol(k), flyercol(k - 1)
        Swap alpha(k), alpha(k - 1)
    Next k
End Sub

' move flyer with index c along and increase it's size
Sub advanceflyer (c As Integer)
    w(c) = w(c) + dw ' increase width
    x(c) = x(c) + dx(c) ' move position
    y(c) = y(c) + dy(c)
End Sub

' True if flyer with index c has left the screen
Function flyerleftscr% (c As Integer)
    Dim As Integer halfw, halfh
    halfw = w(c) / 2
    halfh = halfw * aspectratio
    flyerleftscr% = x(c) - halfw > xmax Or x(c) + halfw < 0 Or y(c) - halfh > ymax Or y(c) + halfh < 0
End Function

'draw flyer with image attached to imagehnd using flyerinfo at index c
Sub placeimage (c As Integer, imagehnd As Long)
    Dim h As Single
    ' calc h from current width and aspect ratio
    h = w(c) * aspectratio
    _PutImage (x(c) - w(c) / 2, y(c) - h / 2)-(x(c) + w(c) / 2, y(c) + h / 2), imagehnd, screenhnd, , _Smooth
End Sub

'load png image file and create a number of diffetent colored versions in memory
Sub generateimages
    Dim As Integer c, xb, yb
    Dim As Long col, alpha, r, g, b

    '     load png image file and determine dimensions
    flyerhnd(0) = _LoadImage(filen, 32)
    flyerw = _Width(flyerhnd(0)): flyerh = _Height(flyerhnd(0))
    '     make some copies of the image and modify the colors
    For c = 1 To Ncol - 1
        flyerhnd(c) = _CopyImage(flyerhnd(0))
        _Source flyerhnd(0)
        _Dest flyerhnd(c)
        For xb = 0 To flyerw - 1 ' scan through the pixels and scramble rgb components
            For yb = 0 To flyerh - 1
                col = Point(xb, yb)
                alpha = _Alpha(col)
                r = _Red(col): g = _Green(col): b = _Blue(col)
                Select Case c
                    'case 0                  existing: r,g,b
                    Case 1:
                        PSet (xb, yb), _RGBA32(r, b, g, alpha)
                    Case 2:
                        PSet (xb, yb), _RGBA32(g, r, b, alpha)
                    Case 3:
                        PSet (xb, yb), _RGBA32(g, b, r, alpha)
                    Case 4:
                        PSet (xb, yb), _RGBA32(b, r, g, alpha)
                    Case 5:
                        PSet (xb, yb), _RGBA32(b, g, r, alpha)
                End Select
            Next yb
        Next xb
    Next c
End Sub

' create screen image either full screen or windowed
Sub generatescreen
    ' create a 32 bit color screen
    If fullscreen Then
        xmax = _DesktopWidth ' get current screen resolution dimensions
        ymax = _DesktopHeight ' reported values are smaller then reality due to ms windows scaling
        screenhnd = _NewImage(xmax, ymax, 32)
        Screen screenhnd
        _FullScreen
    Else
        xmax = windwidth ' for version in window
        ymax = windheight
        screenhnd = _NewImage(xmax, ymax, 32)
        Screen screenhnd
        _Title "Flying things"
    End If
End Sub




