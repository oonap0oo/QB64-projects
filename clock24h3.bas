' 24 hour analog clock               K Moerman 2026

' the faceplate is drawn once and stored as image in memory
' each frame this faceplate image is copied to display erasing previous hands
' then the hands are redrawn at the new position
' there are 60 frames in a second giving a sweeping second hand
' the hands of the clock are drawn using SVG code generated in basic to have some
' anti-aliasing

OPTION _EXPLICIT

' parameters
CONST W = 500 ' sides of square clock image in pixels
CONST W2 = W \ 2
CONST FONTPATH = "C:\Windows\Fonts\times.ttf" ' font to be used for faceplate text
CONST FONTSIZE = W / 20 - 1
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
CONST FACETXT = "24H CLOCK" ' text that goes on the faceplate
CONST FACETXTY = MINUTEMARKERSRAD * 0.4 ' height to put faceplate text

DIM AS DOUBLE hours, minutes, seconds, secondsmidnight
DIM SHARED AS LONG fonthandle, imagehandle, faceplatehandle, svgimagehandle
DIM AS INTEGER frame
DIM AS STRING polygonstrhours, polygonstrminutes, polygonstrseconds
DIM AS STRING completesvg, svgheader, wstr, wstrh, originstr, diskstr
DIM AS STRING svgsecondhand1, svgminutehand1, svghourhand1
DIM AS STRING lsechandstr, lminhandstr, lhourhandstr
DIM AS STRING widthhourminstr1, widthhourminstr2, widthsecstr1, widthsecstr2, backlengthstr

' create image for display and keep handle
imagehandle = _NEWIMAGE(W, W, 32): SCREEN imagehandle

' load font and keep handle
fonthandle = _LOADFONT(FONTPATH, FONTSIZE)

' wait until image for display exists to make sure
DO: _LIMIT 10: LOOP UNTIL _SCREENEXISTS

' draw the complete feceplate and stire in handle faceplatehandle
DrawFaceplateAndStore

' fix display image as destination for _PUTIMAGE
_DEST imagehandle

' define svg code snippets which depend on size of clock
wstr = LTRIM$(STR$(W)): wstrh = LTRIM$(STR$(W2))
svgheader = "<svg width='" + wstr + "' height='" + wstr + "'>"
originstr = "," + wstrh + "," + wstrh
lsechandstr = STR$(LSECHAND + W2) + "," + wstrh
lminhandstr = STR$(LMINHAND + W2) + "," + wstrh
lhourhandstr = STR$(LHOURHAND + W2) + "," + wstrh
backlengthstr = STR$(W2 - BACKLENGHTHAND) + "," + wstrh
widthhourminstr1 = wstrh + ", " + STR$(W2 - WIDTHHOURMINUTEHAND)
widthhourminstr2 = wstrh + ", " + STR$(W2 + WIDTHHOURMINUTEHAND)
widthsecstr1 = wstrh + ", " + STR$(W2 - WIDTHSECONDHAND)
widthsecstr2 = wstrh + ", " + STR$(W2 + WIDTHSECONDHAND)

' assemble svg code which stays constant with time but depend on size of clock
svgsecondhand1 = "<polygon points='" + lsechandstr + " " + widthsecstr1 + " "
svgsecondhand1 = svgsecondhand1 + backlengthstr + " " + widthsecstr2
svgsecondhand1 = svgsecondhand1 + "' fill='red' stroke='red' shape-rendering='geometricPrecision'"
svgminutehand1 = "<polygon points='" + lminhandstr + " " + widthhourminstr1 + " "
svgminutehand1 = svgminutehand1 + backlengthstr + " " + widthhourminstr2
svgminutehand1 = svgminutehand1 + "' fill='white' stroke='white' shape-rendering='geometricPrecision'"
svghourhand1 = "<polygon points='" + lhourhandstr + " " + widthhourminstr1 + " "
svghourhand1 = svghourhand1 + backlengthstr + " " + widthhourminstr2
svghourhand1 = svghourhand1 + "' fill='rgb(210,210,210)' stroke='rgb(210,210,210)' shape-rendering='geometricPrecision'"
' svg for little disk whick covers the center
diskstr = "<circle cx='" + wstrh + "' cy='" + wstrh + "' r='" + LTRIM$(STR$(BACKLENGHTHAND * 0.2)) + "' fill='red'/>"

' main loop
frame = 0
_TITLE TIME$
DO
    ' calculate decimal hours, minutes and seconds
    secondsmidnight = TIMER(0.001) * 1000
    seconds = (CLNG(secondsmidnight) MOD 60000) / 1000
    minutes = (CLNG(secondsmidnight / 60) MOD 60000) / 1000
    hours = (CLNG(secondsmidnight / 3600) MOD 60000) / 1000
    CLS
    ' assemble svg code for hours hand, uses rotation tag to rotate hand to correct angle
    polygonstrhours = svghourhand1
    polygonstrhours = polygonstrhours + "transform='rotate(" + LTRIM$(STR$(360 * hours / 24 - 90)) + originstr + ")'/>"
    ' assemble svg code for minutes hand, uses rotation tag to rotate hand to correct angle
    polygonstrminutes = svgminutehand1
    polygonstrminutes = polygonstrminutes + "transform='rotate(" + LTRIM$(STR$(360 * minutes / 60 - 90)) + originstr + ")'/>"
    ' assemble svg code for seconds hand, uses rotation tag to rotate hand to correct angle
    polygonstrseconds = svgsecondhand1
    polygonstrseconds = polygonstrseconds + "transform='rotate(" + LTRIM$(STR$(360 * seconds / 60 - 90)) + originstr + ")'/>"
    ' assemble complete svg code
    completesvg = svgheader
    completesvg = completesvg + polygonstrhours + polygonstrminutes + polygonstrseconds
    completesvg = completesvg + diskstr + "/svg>"
    ' render the svg code to an image, the "memory" argument tells _LOADIMAGE() that completesvg
    ' contains the svg code itself and not a path to a file
    svgimagehandle = _LOADIMAGE(completesvg, 32, "memory")
    ' copy faceplate image stored in memory to display
    _PUTIMAGE (0, 0), faceplatehandle
    ' copy hands rendered from svg stored as image in memory to display
    _PUTIMAGE (0, 0), svgimagehandle
    ' release memory occupied by image for hands
    _FREEIMAGE svgimagehandle
    _DISPLAY ' wait to display display here
    frame = frame + 1
    IF frame = 14 THEN
        frame = 0
        _TITLE TIME$
    END IF
    _LIMIT 60 ' limit loop cycle time and release remaining CPU
LOOP

' draw a disk of solid color
SUB CircleFill (x AS INTEGER, y AS INTEGER, r AS INTEGER, col AS LONG)
    CIRCLE (x, y), r, col
    PAINT (x, y), col
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

' draw complete faceplate and store image in memory referenced by faceplatehandle
' called once at start of program
SUB DrawFaceplateAndStore
    DrawFaceBackground
    DrawFaceTxt fonthandle
    faceplatehandle = _COPYIMAGE(imagehandle)
END SUB
