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
Const maxw = 200, minw = 20 'end and start width of the flying things as they grow in size
Const speedfactor = 1 / 50 ' influences step size of x and y of eech thing
Const dw = 0.75 ' step size of width increase of each thing

Dim Shared As Long flyerhnd(5), screenhnd, currflyerhnd
Dim Shared As Integer xmax, ymax, flyerw, flyerh
Dim As Integer h, c, alpha
Dim Shared As Single aspectratio
Dim Shared As Integer flyercol(N)
Dim Shared As Single x(N), y(N), dx(N), dy(N), w(N)
Dim Shared As String filen

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
    Cls
    For c = 0 To N - 1
        ' if thing leaves screen or has reached max size -> re-init
        If w(c) >= maxw Or x(c) > xmax Or x(c) < 0 Or y(c) > ymax Or y(c) < 0 Then
            initflyer c
        Else ' if not move the thing along and increase size
            w(c) = w(c) + dw: x(c) = x(c) + dx(c): y(c) = y(c) + dy(c)
        End If
        ' calc h from current width and aspect ratio
        h = w(c) * aspectratio
        ' go from transparent to opaque based on the width
        alpha = _Clamp(2.5 * 255 * w(c) / maxw, 50, 255)
        If alpha < 255 Then ' if not fully opaque make copy and reduce it's alpha
            ' currentflyer is one of the colored versions
            currflyerhnd = _CopyImage(flyerhnd(flyercol(c)))
            ' reduce the alpha of this copy
            _SetAlpha alpha, _RGBA32(0, 0, 0, 1) To _RGBA32(255, 255, 255, 255), currflyerhnd
            ' place the image on the screen at specified position and with specified size
            _PutImage (x(c) - w(c) / 2, y(c) - h / 2)-(x(c) + w(c) / 2, y(c) + h / 2), currflyerhnd, screenhnd, , _Smooth
            _FreeImage currflyerhnd ' copy can be disgarded from memory
        Else ' if fully opague just use the original, no need for the extra steps above
            _PutImage (x(c) - w(c) / 2, y(c) - h / 2)-(x(c) + w(c) / 2, y(c) + h / 2), flyerhnd(flyercol(c)), screenhnd, , _Smooth
        End If
    Next c
    _Display ' wait until this command to update visible display, runs smoother
Loop Until InKey$ <> ""

' init all values needed for the one flying object at index c  in the arrays
Sub initflyer (c As Integer)
    x(c) = xmax * Rnd ' start somewhere on screen
    y(c) = ymax * Rnd
    dx(c) = (x(c) - xmax / 2) * speedfactor ' direction ans speed depends on start position
    dy(c) = (y(c) - ymax / 2) * speedfactor
    w(c) = minw
    flyercol(c) = Rnd * 4 ' choose original or one of 3 color modified versions
End Sub

' load png image file and create a number of diffetent colored versions in memory
Sub generateimages
    Dim As Integer c, xb, yb
    Dim As Long col, alpha, r, g, b

    ' load png image file and determine dimensions
    flyerhnd(0) = _LoadImage(filen, 32)
    flyerw = _Width(flyerhnd(0)): flyerh = _Height(flyerhnd(0))
    ' make some copies of the image and modify the colors
    For c = 1 To 5
        flyerhnd(c) = _CopyImage(flyerhnd(0))
        _Source flyerhnd(0)
        _Dest flyerhnd(c)
        For xb = 0 To flyerw ' scan through the pixels and scramble rgb components
            For yb = 0 To flyerh
                col = Point(xb, yb)
                alpha = _Alpha(col)
                r = _Red(col): g = _Green(col): b = _Blue(col)
                Select Case c
                    '                   existing: r,g,b
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
