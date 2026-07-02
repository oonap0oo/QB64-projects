' 24 hour analog clock               K Moerman 2026

' the faceplate is drawn once and stored as image in memory
' each second this faceplate image is copied to display erasing previous hands
' then the hands are redrawn at the new position
' time info comes from function time$ which gibes 24 hour format as "hh:mm:ss"
' the _MAPTRIANGLE statement is used to draw the shape for the clock's hands

OPTION _EXPLICIT

' parameters
CONST W = 400, W2 = W / 2 ' sides of square image
CONST FONTPATH = "C:\Windows\Fonts\times.ttf" ' font to be used for faceplate text
CONST FONTSIZE = 19
CONST FACERAD = W2 * 0.96 ' radius of faceplate
CONST HOURMARKERSRAD = FACERAD * 0.74 ' radius of hour markers around faceplate
CONST MINUTEMARKERSRAD = FACERAD * 0.83 ' radius of minute markers around faceplate
CONST FACEBGCOLOR = _RGB32(5, 5, 30) ' background color of faceplate
CONST HOURTXTCOLOR = _RGB32(170, 255, 170) ' color of hour labels and markers
CONST MINUTSECONDTXTCOLOR = _RGB32(255) ' color of minute and seconds labels and markers
CONST HOURMARKERSIZE = 3 ' radius of hour marker dots
CONST MINSECMARKERSIZE = 2 ' radius of minute/seconds marker dots
CONST LHOURHAND = HOURMARKERSRAD * 0.8 ' length of hour hand
CONST LMINHAND = MINUTEMARKERSRAD ' length of minute hand
CONST LSECHAND = MINUTEMARKERSRAD ' length of seconds hand
CONST WIDTHHOURMINUTEHAND = LHOURHAND * 0.04 ' widest part of hour and minute hands
CONST WIDTHSECONDHAND = LSECHAND * 0.025 ' widest part of seconds hands
CONST BACKLENGHTHAND = MINUTEMARKERSRAD * 0.35 ' length of the short part at the back of hands
CONST HOURHANDCOLOR = _RGB32(210) ' color of hour hand
CONST MINUTEHANDCOLOR = _RGB32(220) ' color of minutes hand
CONST SECONDHANDCOLOR = _RGB32(255, 50, 50) ' color of seconds hand
CONST CENTERCOLOR = _RGB32(255, 51, 51) ' color of round bit that covers center of clock
CONST FACETXT = "24H CLOCK" ' text that goes on the faceplate
CONST FACETXTY = MINUTEMARKERSRAD * 0.4 ' height to put faceplate text

DIM AS STRING timetxt
DIM AS INTEGER hours, minutes, seconds
DIM SHARED AS LONG fonthandle, imagehandle, faceplatehandle

' create image for display and keep handle
imagehandle = _NEWIMAGE(W, W, 32): SCREEN imagehandle

' load font and keep handle
fonthandle = _LOADFONT(FONTPATH, FONTSIZE)

' wait until image for display exists to make sure
DO: _LIMIT 10: LOOP UNTIL _SCREENEXISTS

' draw the complete feceplate and stire in handle faceplatehandle
DrawFaceplateAndStore

' main loop
_SOURCE faceplatehandle ' fix faceplate image stored in memory as source for _PUTIMAGE
_DEST imagehandle ' fix display image as destination for _PUTIMAGE
DO
    timetxt = TIME$ ' should always return time in 24 hour format "hh:mm:ss"
    hours = VAL(MID$(timetxt, 1, 2)) ' single out hours,minutes and seconds, convert to integer
    minutes = VAL(MID$(timetxt, 4, 2))
    seconds = VAL(MID$(timetxt, 7, 2))
    _TITLE timetxt
    CLS
    _PUTIMAGE ' copy faceplate image stored in memory to display
    DrawHands hours, minutes, seconds
    _DISPLAY ' wait to display display here
    _LIMIT 1 ' limit loop cycle time and release remaining CPU
LOOP

' draw a disk of solid color
SUB CircleFill (x AS INTEGER, y AS INTEGER, r AS INTEGER, col AS LONG)
    CIRCLE (x, y), r, col
    PAINT (x, y), col
END SUB

' draw a filled triangle defined by 3 arbitrary points
SUB DrawTriangleFill (x1 AS INTEGER, y1 AS INTEGER, x2 AS INTEGER, y2 AS INTEGER, x3 AS INTEGER, y3 AS INTEGER, col AS LONG)
    DIM imhandle AS LONG
    imhandle = _DEST
    PSET (0, 0), col
    _MAPTRIANGLE (0, 0)-(0, 0)-(0, 0), imhandle TO(x1, y1)-(x2, y2)-(x3, y3), imhandle
    PSET (0, 0), _RGB32(0)
END SUB

' draw the background for the faceplate, called only once at start program
SUB DrawFaceBackground
    CircleFill W2, W2, FACERAD, FACEBGCOLOR
END SUB

' draw all text and markers on the faceplate, called only once at start program
SUB DrawFaceTxt (fonth AS LONG)
    DIM AS SINGLE angle, anglestep, xmarker, ymarker, xtext, ytext
    DIM AS INTEGER hour, minutes, txtwidth, txtheight
    DIM AS STRING hourtxt, minutestxt
    ' set font and background
    _FONT fonth
    COLOR , _RGBA32(0, 0, 0, 0) ' transparent background for text
    txtheight = _FONTHEIGHT
    ' Draw hour labels 1..24
    hour = 1
    anglestep = 2 * _PI / 24
    COLOR HOURTXTCOLOR
    FOR angle = anglestep - _PI / 2 TO 2 * _PI - _PI / 2 STEP anglestep
        xmarker = W2 + HOURMARKERSRAD * COS(angle)
        ymarker = W2 + HOURMARKERSRAD * SIN(angle)
        CircleFill xmarker, ymarker, HOURMARKERSIZE, HOURTXTCOLOR
        hourtxt = _TRIM$(STR$(hour))
        txtwidth = _PRINTWIDTH(hourtxt)
        xtext = xmarker - txtwidth * COS(angle)
        ytext = ymarker - 0.87 * txtheight * SIN(angle)
        _PRINTSTRING (xtext - txtwidth / 2, ytext - txtheight / 2), hourtxt
        hour = hour + 1
    NEXT angle
    ' Draw minutes or seconds labels 5..60
    txtwidth = _PRINTWIDTH("24")
    minutes = 1
    anglestep = 2 * _PI / 60
    COLOR MINUTSECONDTXTCOLOR
    FOR angle = anglestep - _PI / 2 TO 2 * _PI - _PI / 2 STEP anglestep
        xmarker = W2 + MINUTEMARKERSRAD * COS(angle)
        ymarker = W2 + MINUTEMARKERSRAD * SIN(angle)
        IF minutes MOD 5 = 0 THEN
            CircleFill xmarker, ymarker, MINSECMARKERSIZE * 2, MINUTSECONDTXTCOLOR
            minutestxt = _TRIM$(STR$(minutes))
            xtext = xmarker + txtwidth * COS(angle)
            ytext = ymarker + txtheight * SIN(angle)
            _PRINTSTRING (xtext - txtwidth / 2, ytext - txtheight / 2), minutestxt
        ELSE
            CircleFill xmarker, ymarker, MINSECMARKERSIZE, MINUTSECONDTXTCOLOR
        END IF
        minutes = minutes + 1
    NEXT angle
    ' draw text on faceplate
    COLOR HOURTXTCOLOR
    txtwidth = _PRINTWIDTH(FACETXT)
    _PRINTSTRING (W2 - txtwidth / 2, W2 - FACETXTY), FACETXT
END SUB

' draw one hand, shape is made of 4 filled triangles
SUB DrawHand (angle AS SINGLE, l AS INTEGER, w AS INTEGER, col AS LONG)
    DIM AS SINGLE cosangle, sinangle
    DIM AS INTEGER x, y, widthx, widthy, backx, backy
    cosangle = COS(angle): sinangle = SIN(angle)
    x = l * cosangle: y = l * sinangle
    widthx = w * sinangle: widthy = -w * cosangle
    backx = BACKLENGHTHAND * cosangle: backy = BACKLENGHTHAND * sinangle
    DrawTriangleFill W2, W2, W2 + x, W2 + y, W2 + widthx, W2 + widthy, col
    DrawTriangleFill W2, W2, W2 + x, W2 + y, W2 - widthx, W2 - widthy, col
    DrawTriangleFill W2, W2, W2 - backx, W2 - backy, W2 + widthx, W2 + widthy, col
    DrawTriangleFill W2, W2, W2 - backx, W2 - backy, W2 - widthx, W2 - widthy, col
END SUB

' draw hour, minute and seconds hands
SUB DrawHands (hours AS INTEGER, minutes AS INTEGER, seconds AS INTEGER)
    DIM AS SINGLE anglehours, angleminutes, angleseconds
    angleseconds = 2 * _PI * seconds / 60
    angleminutes = angleseconds / 60 + 2 * _PI * minutes / 60
    anglehours = angleminutes / 60 + 2 * _PI * hours / 24
    angleseconds = angleseconds - _PI / 2
    angleminutes = angleminutes - _PI / 2
    anglehours = anglehours - _PI / 2
    ' hours hand
    DrawHand anglehours, LHOURHAND, WIDTHHOURMINUTEHAND, HOURHANDCOLOR
    ' minutes hand
    DrawHand angleminutes, LMINHAND, WIDTHHOURMINUTEHAND, MINUTEHANDCOLOR
    ' seconds hand
    DrawHand angleseconds, LSECHAND, WIDTHSECONDHAND, SECONDHANDCOLOR
    ' little disk covers the center
    CircleFill W2, W2, BACKLENGHTHAND * 0.2, CENTERCOLOR
END SUB

' draw complete faceplate and store image in memory referenced by faceplatehandle
' called once at start of program
SUB DrawFaceplateAndStore
    DrawFaceBackground
    DrawFaceTxt fonthandle
    faceplatehandle = _COPYIMAGE(imagehandle)
END SUB
