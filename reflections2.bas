' Reflections           K Moerman 2026

DEFDBL A-Z

CONST N = 900 ' number of points in animation
CONST W = 1100, H = 900, HW = W / 2, HH = H / 2 ' size of image
CONST VELOCITYPOINTS = 1 ' magnitude of velocity of points
CONST CALCANDPLOTPERFRAME = 15 ' number of new point positions calc. and plotted each frame
CONST R = H / 2 - 50, RSQ = R * R ' radius of circle, depends on size image
CONST INITXSOURCE = R - 30, INITYSOURCE = 0 ' coord. of source at start
CONST INITMAXREFL = 9 ' max number of reflections at start
CONST OVLALPHA = 8 ' opagueness of overlay inside circle
CONST TXTFONT = "arial.ttf", TXTSIZE = 26 ' font used

TYPE pointtype ' UDT with information of a point
    x AS SINGLE
    y AS SINGLE
    vx AS SINGLE
    vy AS SINGLE
    col AS LONG
    nrefl AS INTEGER
END TYPE

TYPE sourcetype ' UDT with information of the source
    x AS SINGLE
    y AS SINGLE
END TYPE

DIM SHARED points(N) AS pointtype ' array holding data for all points
DIM SHARED source AS sourcetype ' one source of points
DIM SHARED AS LONG hovl, hsrc, hdsp, hfont ' various handles for images, font
DIM SHARED maxrefl%, txth%

' load font to use
fontfile$ = ENVIRON$("SYSTEMROOT") + "\Fonts\" + TXTFONT ' TTF file normally in "C:\WINDOWS\FONTS"
hfont = _LOADFONT(fontfile$, TXTSIZE, "bold")


' Generate overlay image and store in memory for use
hovl = GenerateOverlayImage&

' Generate image of source and store in memory for use
hsrc = GenerateSourceImage&

' generate image for display
hdsp = _NEWIMAGE(W, H, 32): SCREEN hdsp
DO: LOOP UNTIL _SCREENEXISTS
WINDOW (-HW, -HH)-(HW, HH)
_SCREENMOVE _DESKTOPWIDTH / 2 - HW, _DESKTOPHEIGHT / 2 - HH

InitSource
InitAllPoints ' start with giving all points their initial values
maxrefl% = INITMAXREFL
SetTitle
DO
    _PUTIMAGE , hovl, hdsp ' put overlay on display
    FOR calc% = 1 TO CALCANDPLOTPERFRAME ' calc and plot new positions of all points
        AdvancePoints
        PlotPoints
    NEXT calc%
    PlotSource ' put image representing source on its current position
    _DISPLAY
    ProcessMouse ' process any mouse inputs
    ProcessKeys ' process any keyboard inputs
    _LIMIT 60
LOOP UNTIL INKEY$ = CHR$(13)

' initialise the data for 1 point with index k%
SUB InitPoint (k%, xs, ys)
    points(k%).x = xs ' points start at source position
    points(k%).y = ys
    angle = 2 * _PI * k% / N ' angle spread out 0..360 deg
    points(k%).vx = VELOCITYPOINTS * COS(angle) ' x and y comp. of velocity
    points(k%).vy = VELOCITYPOINTS * SIN(angle)
    col& = _HSB32(angle * 180 / _PI, 100, 100) ' color hue depends on angle
    points(k%).col = col&
    points(k%).nrefl = 0 ' number of reflection starts at 0
END SUB

' initialise all points
SUB InitAllPoints
    FOR k% = 0 TO N - 1
        InitPoint k%, source.x, source.y
    NEXT k%
END SUB

' source gets it's starting position
SUB InitSource
    source.x = INITXSOURCE
    source.y = INITYSOURCE
END SUB

SUB AdvancePoints
    FOR k% = 0 TO N - 1
        AdvancePoint k%
    NEXT k%
END SUB

' calculate new position for 1 point, taking into account possible reflection
' re-init the point from the source if it has reflected the maximum number fo times
SUB AdvancePoint (k%)
    ' advance according to current velocity
    points(k%).x = points(k%).x + points(k%).vx
    points(k%).y = points(k%).y + points(k%).vy
    rpointsq = points(k%).x * points(k%).x + points(k%).y * points(k%).y
    IF rpointsq >= RSQ THEN ' point has to be reflected?
        IF points(k%).nrefl < maxrefl% THEN ' has point not yet been reflected maximum number of times
            points(k%).nrefl = points(k%).nrefl + 1 ' keep track number of reflections
            ' update color of point decreasing opaqueness
            angledeg = 360 * k% / N
            alpha = 255 - 225 * points(k%).nrefl / maxrefl%
            points(k%).col = _HSBA32(angledeg, 100, 100, alpha)
            ' Calc new velocity comp. vx and vy after reflection
            ' Vout=Vin-2(Vin . n)n
            nx = points(k%).x / R ' x comp. of normal vector
            ny = points(k%).y / R ' y comp. of normal vector
            dotproduct = points(k%).vx * nx + points(k%).vy * ny ' dot product vin . n
            points(k%).vx = points(k%).vx - 2 * dotproduct * nx ' x comp. of Vout velocity after reflection
            points(k%).vy = points(k%).vy - 2 * dotproduct * ny ' y comp. of Vout velocity after reflection
        ELSE ' point has relfected max number of times
            InitPoint k%, source.x, source.y ' re-init the point from the source
        END IF
    END IF
END SUB

' plot all the points at their current pos.
SUB PlotPoints
    FOR k% = 0 TO N - 1
        PSET (points(k%).x, points(k%).y), points(k%).col
    NEXT k%
END SUB

' put source image on display
SUB PlotSource
    _PUTIMAGE (source.x - 8, source.y + 8), hsrc, hdsp
END SUB

' porcess mouse inputs
SUB ProcessMouse
    txth = _FONTHEIGHT
    WHILE _MOUSEINPUT
        IF _MOUSEBUTTON(1) THEN
            DO ' wait until mouse button has been released
                i = _MOUSEINPUT ' call _mouseinput to update data such as _mousebutton()
            LOOP UNTIL NOT _MOUSEBUTTON(1)
            xmouse = _MOUSEX
            ymouse = _MOUSEY
            x = xmouse - HW
            y = HH - ymouse
            mousersq = x * x + y * y
            IF mousersq <= RSQ THEN ' mouse inside circle?
                source.x = x
                source.y = y
            ELSE
                IF xmouse < 400 AND xmouse > 30 THEN ' mouse above a button?
                    SELECT CASE ymouse
                        CASE 20 TO txth% + 20: ChangeMaxrefl
                        CASE 2 * txth% + 20 TO 3 * txth% + 20: InitAllPoints
                    END SELECT
                END IF
            END IF
        END IF
    WEND
END SUB

' process all keyboard inputs
SUB ProcessKeys
    DO
        k& = _KEYHIT
        SELECT CASE k&
            CASE ASC("R"), ASC("r"): ChangeMaxrefl
            CASE ASC("S"), ASC("s"): InitAllPoints
        END SELECT
    LOOP UNTIL k = 0
END SUB

' let user change max. number of reflections using dialog box
SUB ChangeMaxrefl
    result$ = _INPUTBOX$("Number of reflections", "Change number of reflections", STR$(maxrefl%))
    IF result$ <> "" THEN
        resultint% = INT(VAL(result$))
        IF resultint% > -1 THEN maxrefl% = resultint%
    END IF
    SetTitle
END SUB

' draw a simple kind of button at x,y with label txt
SUB KindOffButton (x, y, txt$)
    htxt = _FONTHEIGHT
    wtxt = _PRINTWIDTH(txt$)
    LINE (x - 2, y - 2)-(x + wtxt + 1, y + htxt), _RGB32(160), BF
    COLOR _RGB32(0), _RGB32(0, 0)
    _PRINTSTRING (x, y), txt$
END SUB

' Generate overlay image and return handle
FUNCTION GenerateOverlayImage&
    himg& = _NEWIMAGE(W, H, 32)
    _DEST himg&
    LINE (0, 0)-(W, H), _RGB32(0, OVLALPHA), BF 'include low opague black region inside circle to fade old content
    CIRCLE (HW, HH), R, _RGB32(255) ' draw circle, points reflect from inside it
    outsidecol& = _RGB32(0, 0, 50)
    PAINT (0, 0), outsidecol&, _RGB32(255) ' paint some color outside circle
    _FONT hfont, himg&
    COLOR _RGB32(255), outsidecol&
    txth% = _FONTHEIGHT
    _PRINTSTRING (30, H - txth% - 10), "Click inside circle to change postion of source"
    KindOffButton 30, 20, "Change max. number of reflections"
    KindOffButton 30, 2 * txth% + 20, "Re-init points from source"
    GenerateOverlayImage& = himg&
END FUNCTION

' Generate image of source and store in memory for use
FUNCTION GenerateSourceImage&
    himg& = _NEWIMAGE(16, 16, 32)
    _DEST himg&
    CIRCLE (8, 8), 8, _RGB32(255)
    PAINT (8, 8), _RGB32(255)
    GenerateSourceImage& = himg&
END FUNCTION

SUB SetTitle
    _TITLE "REFLECTIONS   -   maximum number of reflections: " + STR$(maxrefl%)
END SUB
