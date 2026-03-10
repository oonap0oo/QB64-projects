' Recursive Tree on a windy day
Option _Explicit
Randomize Timer

Const FULLSCREEN = _FALSE
Const WINWIDTH = 1100 / 1.5, WINHEIGHT = 900 / 1.5 'dimensions of window, ignored if fullscreen
Const COLBRANCH = _RGB32(61, 17, 6), COLLEAVES = _RGB32(172, 255, 94)
Const COLSKY = _RGB32(50, 100, 161), COLGROUND = _RGB32(17, 67, 6)
Const COLCLOUD = _RGB32(155, 200, 249)
Const LSTART = 148 ' start lenght = length tree trunk
Const LREDUCT = 0.78 ' factor used to make consecutive branches shorter
Const ANGLEBRANCH = _Pi / 4 ' angle between side branches and main branch
Const ANGLEVARRANGE = 0.25 ' range over which angles are varied randomly as a factor
Const DWINDSTRENGHTRANGE = 0.04 ' range over which variable dwindstrength is varied randomly
Const PWINDAVERAGING = 0.8 ' probability for windstrenght to revert back to it's average
Const WINDAVERAGE = -0.3 ' windstrength tends to vary around this value
Const INERTIA = 5 ' higher value filters out small fast movements
Const RECURSDEPTH = 7 ' recursion depth of tree
Const CLOUDELLIPS = 4, CLOUDASPECT = 0.17, CLOUDSIZE = 60 ' values to draw the cloud

Dim Shared As Integer xmax, ymax, ymaxd4
Dim Shared As Integer clouddx(CLOUDELLIPS), clouddy(CLOUDELLIPS), cloudr(CLOUDELLIPS)
Dim Shared As Long screenhnd
Dim Shared As Single windstrength, startangle
Dim As Single dwindstrength
Dim As Integer k, xcloud, ycloud, xtree, ytree

generatescreen

ymaxd4 = ymax / 4 ' calculate once, use multiple times
xtree = 0.5 * xmax: ytree = ymax - 10 ' position of botton of trunk

generatecloud ' fill arrays cloudx(), cloudy() and cloudr() with random values

xcloud = -CLOUDSIZE
ycloud = newycloud%
windstrength = WINDAVERAGE
Do
    dwindstrength = Rnd * DWINDSTRENGHTRANGE ' value between 0 and +DWINDSTRENGHTRANGE
    ' make windstrength vary around WINDAVERAGE, excursions allowed
    If windstrength > WINDAVERAGE Then
        ' if above average make dwindstrength negative with probability PWINDAVERAGING
        If Rnd < PWINDAVERAGING Then dwindstrength = -dwindstrength
    Else
        ' if below average keep dwindstrength positive with probability PWINDAVERAGING
        If Rnd > PWINDAVERAGING Then dwindstrength = -dwindstrength
    End If
    For k = 1 To INERTIA
        _Limit 30
        ' update windstrenght with current dwindstrength for INERTIA times
        windstrength = windstrength + dwindstrength
        windstrength = _Clamp(windstrength, -1, 1)
        startangle = modifyangle!(_Pi / 2, windstrength / 2)
        Cls
        ' draw background
        Line (0, 0)-(xmax, ymax - ymaxd4), COLSKY, BF
        Line (0, ymax - ymaxd4 + 1)-(xmax, ymax), COLGROUND, BF
        ' draw cloud at new position
        drawcloud xcloud, ycloud
        ' start recursive function calls for tree
        nextbranch xtree, ytree, LSTART, startangle, RECURSDEPTH
        _Display
        ' update cloud position
        If xcloud - CLOUDSIZE < xmax Then
            xcloud = xcloud + 1
        Else
            xcloud = -CLOUDSIZE: ycloud = newycloud%
            generatecloud
        End If
    Next k
Loop Until InKey$ <> ""

' recursive function draws branch and callc itself 3 times
' when max level is reached draw a leaf
Sub nextbranch (x As Integer, y As Integer, l As Integer, angle As Single, level As Integer)
    Dim As Integer dx, dy, xn, yn, k, nextl
    Dim As Single nextangle, nextdangle

    dx = l * Cos(angle): dy = -l * Sin(angle)
    xn = x + dx: yn = y + dy
    thickline x, y, xn, yn, level + 2, COLBRANCH
    If level > 0 Then
        nextl = l * LREDUCT
        nextangle = modifyangle!(angle, windstrength)
        nextbranch xn, yn, nextl, nextangle, level - 1
        nextl = nextl * LREDUCT
        nextdangle = modifyangle!(ANGLEBRANCH, -windstrength)
        nextbranch xn, yn, nextl, nextangle + nextdangle, level - 1
        nextdangle = modifyangle!(ANGLEBRANCH, windstrength)
        nextbranch xn, yn, nextl, nextangle - nextdangle, level - 1
    Else
        Circle (xn, yn), 3, COLLEAVES
    End If
End Sub

' change angle value to take into account effect of wind
Function modifyangle! (angle As Single, windstrength As Single)
    modifyangle! = angle + angle * ANGLEVARRANGE * windstrength
End Function

' generate a new set of random ellipses to make up a cloud
Sub generatecloud
    Dim As Integer k
    For k = LBound(clouddx) To UBound(clouddx)
        clouddx(k) = CLOUDSIZE * (1 - 2 * Rnd)
        clouddy(k) = CLOUDSIZE * (1 - 2 * Rnd) * CLOUDASPECT
        cloudr(k) = CLOUDSIZE * (0.6 + 0.4 * Rnd)
    Next k
End Sub

' draw the cloud at point x,y based on ellipses stored in array
Sub drawcloud (x As Integer, y As Integer)
    Dim As Integer k, xc, yc, t
    For k = LBound(clouddx) To UBound(clouddx)
        xc = x + clouddx(k)
        yc = y + clouddy(k)
        For t = 2 To cloudr(k)
            Circle (xc, yc), t, COLCLOUD, , , CLOUDASPECT
        Next t
    Next k
End Sub

'get height (y value) for a new cloud
Function newycloud%
    newycloud% = ymaxd4 + ymaxd4 * Rnd - CLOUDSIZE
End Function

' draw a line between two arbitrary points with any given thickness
Sub thickline (x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer, thick As Integer, col As Long)
    Dim As Integer x3, y3, x4, y4, dx, dy, x1b, y1b, x2b, y2b
    Dim As Single alpha

    alpha = _Atan2((y2 - y1), (x2 - x1)) - _Pi / 2
    dx = thick * Cos(alpha) / 2
    dy = thick * Sin(alpha) / 2
    x3 = x1 + dx
    y3 = y1 + dy
    x4 = x2 + dx
    y4 = y2 + dy
    x1b = x1 - dx
    y1b = y1 - dy
    x2b = x2 - dx
    y2b = y2 - dy
    PSet (0, 0), col
    _MapTriangle (0, 0)-(0, 0)-(0, 0), screenhnd To(x1b, y1b)-(x3, y3)-(x2b, y2b), screenhnd
    _MapTriangle (0, 0)-(0, 0)-(0, 0), screenhnd To(x2b, y2b)-(x4, y4)-(x3, y3), screenhnd
End Sub

' create screen image either full screen or windowed
Sub generatescreen
    ' create a 32 bit color screen
    If FULLSCREEN Then
        xmax = _DesktopWidth ' get current screen resolution dimensions
        ymax = _DesktopHeight ' reported values are smaller then reality due to ms windows scaling
        screenhnd = _NewImage(xmax, ymax, 32)
        Screen screenhnd
        _FullScreen
    Else
        xmax = WINWIDTH ' for version in window
        ymax = WINHEIGHT
        screenhnd = _NewImage(xmax, ymax, 32)
        Screen screenhnd
        _Title "Recursive Tree on a windy day"
        _ScreenMove 0, 0
    End If
End Sub

