' Mandala for QB64          K Moerman 2026
' ESCAPE key terminates program, S key saves as SVG file, N asks for new number of sectors
' ENTER key draws new mandala
' Random figure drawn using SVG circle tags
' The figure is made of colored disks drawn in each sector of the mandala

RANDOMIZE TIMER
CONST W% = 800, H% = 800 ' size of mandala
CONST BRD% = 100 ' height region at bottom of window for help text
CONST TXT$ = "Mandala "
CONST HW% = W% / 2, HH% = H% / 2, NEWLINE$ = _CHR_CR + _CHR_LF
CONST THIRD360 = 2 * _PI / 3, TWOTHIRD360 = 2 * THIRD360

DIM SHARED hscr&, svgheader$

hscr& = _NEWIMAGE(W%, H% + BRD%, 32) ' open window in 32 color mode
SCREEN hscr&

svgheader$ = GenerateSVGHeader$ ' generate header text of SVG once, depends only on W% and H%

' font used for help text
fontpath$ = ENVIRON$("SYSTEMROOT") + "\fonts\lucon.ttf"
_FONT _LOADFONT(fontpath$, 19, "monospace")

DO: _LIMIT 10: LOOP UNTIL _SCREENEXISTS 'make sure screen is ready

_SCREENMOVE _MIDDLE '10, 10 ' move window in view

' main loop
ndisks% = 300 ' start value for number of disks per sector, can be changed with D key
nsectors% = 13 ' start value for number of sectors, can be changed with N key
DO
    info$ = TXT$ + STR$(nsectors%) + " sectors, " + STR$(ndisks%) + " disks per sector"
    svg$ = GenerateSVGFigure$(ndisks%, nsectors%) ' generate the SVG code of new mandala
    DrawSVG svg$ ' draw SVG code to screen
    DrawInfoText info$ ' update help text
    _TITLE info$
    DO ' wait for user input
        _LIMIT 30
        k$ = UCASE$(INKEY$)
        SELECT CASE k$
            CASE "S": SaveSVG2File svg$ ' save svg code to file
            CASE "N": nsectors% = GetNumberSectors%(nsectors%): EXIT DO ' get new number of sectors
            CASE "D": ndisks% = GetNumberDisks%(ndisks%): EXIT DO ' get new number of disks per sector
            CASE CHR$(27), CHR$(13): EXIT DO
        END SELECT
    LOOP
LOOP UNTIL k$ = CHR$(27) ' exit program  when ESCAPE is pressed
END

' generate SVG header code, called once at start program
FUNCTION GenerateSVGHeader$
    width$ = _TRIM$(STR$(W%))
    height$ = _TRIM$(STR$(H%))
    svg$ = "<?xml version='1.0' encoding='UTF-8' standalone='no'?>" + NEWLINE$
    svg$ = svg$ + "<svg width='" + width$
    svg$ = svg$ + "' height='" + height$ + "'"
    svg$ = svg$ + " viewBox='0 0 " + width$ + " " + height$ + "'"
    svg$ = svg$ + " xmlns='http://www.w3.org/2000/svg'" + ">" + NEWLINE$
    GenerateSVGHeader$ = svg$
END FUNCTION

' generate string containing SVG code with rgb() function
FUNCTION ColorSVG$ (anglecol)
    red% = 128 + 127 * SIN(3 * anglecol) ' RGB components in range 0..255
    blue% = 128 + 127 * SIN(2 * anglecol + THIRD360)
    green% = 128 + 127 * SIN(anglecol + TWOTHIRD360)
    ColorSVG$ = "rgb(" + _TRIM$(STR$(red%)) + "," + _TRIM$(STR$(blue%)) + "," + _TRIM$(STR$(green%)) + ")"
END FUNCTION

' Generating SVG code of complete mandala figure
FUNCTION GenerateSVGFigure$ (ndisks%, nsectors%)
    svg$ = svgheader$ ' start SVG code with same header each time
    anglesector = 2 * _PI / nsectors%
    cosangle = COS(anglesector): sinangle = SIN(anglesector)
    r = HW% * sinangle ' start value for radius of disks
    a = (2 / r) ^ (1 / ndisks%) ' multiplier <1 to reduce radius r during loop
    FOR disk% = 0 TO ndisks% - 1
        x = RND * (HW% - r) ' random value of center coord. x so disk still fits on screen
        y = 0 ' first sector y is zero
        anglecol = 2 * _PI * RND ' random value from 0..2PI
        svg$ = svg$ + "<g fill='" + ColorSVG$(anglecol) + "'>" + NEWLINE$ ' start SVG group of disks with same color
        FOR sector% = 0 TO nsectors% - 1 ' draw same disk for each sector
            shapesvg$ = "<circle cx='" + _TRIM$(STR$(x + HW%)) + "' cy='" + _TRIM$(STR$(y + HH%)) + "' r='" + _TRIM$(STR$(r)) + "'/>"
            svg$ = svg$ + shapesvg$ + NEWLINE$
            xnew = cosangle * x - sinangle * y ' rotation of x and y coord.
            y = sinangle * x + cosangle * y
            x = xnew
        NEXT sector%
        svg$ = svg$ + "</g>" + NEWLINE$ ' close the SVG group
        IF r > 2 THEN r = r * a ' reduce radius of disks as loop continues
    NEXT disk%
    GenerateSVGFigure$ = svg$ + "</svg>" ' close the SVG code
END FUNCTION

' draw svg code to screen
SUB DrawSVG (svg$)
    hsvg& = _LOADIMAGE(svg$, 32, "memory")
    CLS
    '_SOURCE hsvg&
    _PUTIMAGE (0, 0)-(W%, H%), hsvg&, hscr&
    _FREEIMAGE hsvg&
END SUB

' save svg code to file
SUB SaveSVG2File (svg$)
    result$ = _SAVEFILEDIALOG$("Save SVG", "mandala.svg", "*.svg") ' get path and name
    IF result$ <> "" THEN
        f% = FREEFILE
        OPEN result$ FOR OUTPUT AS #f% ' write SVG code as text file
        PRINT #f%, svg$
        CLOSE #f%
    END IF
END SUB

' place help text
SUB DrawInfoText (info$)
    _PRINTSTRING (10, W% + 0.5 * _FONTHEIGHT), info$
    _PRINTSTRING (10, W% + 2 * _FONTHEIGHT), "[ENTER]: New mandala           [S]: Save as SVG file"
    _PRINTSTRING (10, W% + 3 * _FONTHEIGHT), "[N]: Change number of sectors  [D]:change number of disks per sector"
    _PRINTSTRING (10, W% + 4 * _FONTHEIGHT), "[ESC]: Exit"
END SUB

' get new number of sectors
FUNCTION GetNumberSectors% (nsector%)
    result$ = _INPUTBOX$("Mandala sectors", "Number of sectors, larger then 2?", STR$(nsector%))
    IF result$ <> "" THEN ' if dialog was not cancelled
        number% = VAL(result$)
        IF number% > 2 THEN GetNumberSectors% = number%
    END IF
END FUNCTION

' get new number of disks per sector
FUNCTION GetNumberDisks% (ndisks%)
    result$ = _INPUTBOX$("Mandala disks", "Number of disks per sector, larger then 0?", STR$(ndisks%))
    IF result$ <> "" THEN ' if dialog was not cancelled
        number% = VAL(result$)
        IF number% > 0 THEN GetNumberDisks% = number%
    END IF
END FUNCTION

