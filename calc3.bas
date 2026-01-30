' Very BAsic Calculator
' Mostly made to try out mouse interaction and button functionality coded in QB64
OPTION _EXPLICIT

CONST XMAX = 440 ' image dimensions
CONST YMAX = 420
CONST BORDER = 30, HEADER = 70
CONST FONTPATH = "C:\Windows\Fonts\consola.ttf" ' path to TTF font to use
CONST KEYTXTSIZE = 30, DISPTXTSIZE = 31 ' text font sizes
CONST KEYTXTCOLOR = _RGB32(200, 200, 255), KEYCOLOR = _RGB32(0, 0, 255)
CONST KEYHIGHLIGHTCOLOR = _RGB32(255, 255, 0), DISPLAYCOLOR = _RGB32(128, 128, 255)

DIM AS LONG handle
DIM SHARED AS LONG keyfont, dispfont
DIM SHARED AS STRING lastoper, displaystr
DIM SHARED AS INTEGER isnewop
DIM SHARED AS DOUBLE yreg
DIM AS INTEGER i
DIM AS STRING keytxt, typedtxt

handle = _NEWIMAGE(XMAX, YMAX, 32) ' generate window
SCREEN handle
_TITLE "Basic Calculator"
COLOR KEYTXTCOLOR
CLS

' load fonts and store in shared long variables
keyfont = _LOADFONT(FONTPATH, KEYTXTSIZE, "MONOSPACE")
dispfont = _LOADFONT(FONTPATH, DISPTXTSIZE, "MONOSPACE")

isnewop = -1 'True ' flag used in calculator operation
displaystr = "0" ' string holds text displayed by calc

drawborder
drawkeys
updatedisplay

DO '  main loop precessing mouse movements, clicks and keyboard key presses
    DO WHILE _MOUSEINPUT ' Check the mouse status and update _MOUSE variables
        keytxt = findkey(_MOUSEX, _MOUSEY, _MOUSEBUTTON(1))
        IF keytxt <> "" THEN processkey keytxt ' a button was clicked
        DO ' wait until mouse button has been released
            i = _MOUSEINPUT ' call _mouseinput to update data such as _mousebutton()
        LOOP UNTIL NOT _MOUSEBUTTON(1)
    LOOP
    typedtxt = INKEY$ ' process keys pressed on physical keyboard
    IF typedtxt <> "" THEN processkey typedtxt
    _LIMIT 20 ' reduce CPU load by limiting loop speed
LOOP

' draw keypad using info from data field
SUB drawkeys
    DIM AS INTEGER x, y, row, col, kwidth, kheight
    DIM AS STRING txt
    COLOR KEYTXTCOLOR
    _FONT keyfont
    RESTORE 'start at beginning of data field
    READ txt, row, col, kheight, kwidth
    DO
        x = BORDER + col
        y = BORDER + HEADER + row
        LINE (x, y)-(x + kwidth, y + kheight), KEYCOLOR, B
        _PRINTSTRING (x + kwidth / 2 - _PRINTWIDTH(txt) / 2, y + kheight / 3), txt
        READ txt, row, col, kheight, kwidth
    LOOP UNTIL txt = "" ' enpty txt means end of data is reached
END SUB

' find which on screen key the mouse is hovering over
' and detect mouse clicks on that key
FUNCTION findkey$ (xmouse AS INTEGER, ymouse AS INTEGER, mousebutton AS INTEGER)
    DIM AS INTEGER x, y, row, col, kwidth, kheight
    DIM AS STRING txt
    findkey$ = ""
    RESTORE
    READ txt, row, col, kheight, kwidth
    DO
        x = BORDER + col
        y = BORDER + HEADER + row
        IF (x <= xmouse) AND ((x + kwidth) >= xmouse) AND (y <= ymouse) AND ((y + kheight) >= ymouse) THEN
            LINE (x, y)-(x + kwidth, y + kheight), KEYHIGHLIGHTCOLOR, B
            IF mousebutton = -1 THEN
                findkey$ = txt
            END IF
        ELSE
            LINE (x, y)-(x + kwidth, y + kheight), KEYCOLOR, B
        END IF
        READ txt, row, col, kheight, kwidth
    LOOP UNTIL txt = ""
END FUNCTION

' take action once a key with label keytxt has been clicked
SUB processkey (keytxt AS STRING)
    DIM displayvalue AS DOUBLE
    SELECT CASE keytxt
        CASE "0" TO "9", "."
            IF isnewop THEN
                displaystr = keytxt
            ELSE
                IF LEN(displaystr) < 17 THEN displaystr = displaystr + keytxt
            END IF
            isnewop = 0 'False
        CASE "+", "-", "/", "x"
            IF (lastoper <> "") AND isnewop AND (keytxt = "-") THEN ' allow input of negative value
                displaystr = "-"
                isnewop = 0 'false
            ELSE
                yreg = VAL(displaystr)
                lastoper = keytxt
                isnewop = -1 'true
            END IF
        CASE "=", CHR$(13)
            displayvalue = VAL(displaystr)
            SELECT CASE lastoper
                CASE "+"
                    displayvalue = yreg + displayvalue
                CASE "-"
                    displayvalue = yreg - displayvalue
                CASE "x"
                    displayvalue = yreg * displayvalue
                CASE "/"
                    IF displayvalue <> 0 THEN displayvalue = yreg / displayvalue
            END SELECT
            displaystr = STR$(displayvalue)
            lastoper = ""
            isnewop = -1 'true
        CASE "C", CHR$(127)
            displaystr = "0"
            yreg = 0
            lastoper = ""
            isnewop = -1 'true
        CASE "CE", CHR$(8)
            displaystr = "0"
        CASE "Vx"
            displayvalue = VAL(displaystr)
            IF displayvalue >= 0 THEN
                displayvalue = SQR(displayvalue)
                isnewop = -1 'true
                displaystr = STR$(displayvalue)
            END IF
    END SELECT
    updatedisplay
END SUB

' update value shown on calc display
SUB updatedisplay
    DIM AS INTEGER c, p
    DIM outp AS STRING
    DIM AS INTEGER x, y
    outp = displaystr
    outp = RIGHT$(SPACE$(20) + LTRIM$(RTRIM$(outp)), 21)
    p = INSTR(outp, "D") ' replace "D" with "E" for scientific notation
    IF p > 0 THEN
        MID$(outp, p, 1) = "E"
    END IF
    x = BORDER + 10: y = HEADER / 2 + 5
    LINE (x, y)-(x + _PRINTWIDTH(outp), y + 20), _RGB32(0, 0, 0), BF
    _FONT dispfont
    COLOR DISPLAYCOLOR
    _PRINTSTRING (x, y), outp
END SUB

' draw a box around the calc outline
SUB drawborder
    DIM edge AS INTEGER
    edge = BORDER / 2
    LINE (edge, edge)-(XMAX - edge, YMAX - edge), KEYCOLOR, B
END SUB

' data containing key labels, position and size
' format:   "text",row,column,height,width
DATA "/",0,300,50,80,"x",60,300,50,80,"-",120,300,50,80,"+",180,300,50,80
DATA "9",60,0,50,80,"8",60,100,50,80,"7",60,200,50,80
DATA "6",120,0,50,80,"5",120,100,50,80,"4",120,200,50,80
DATA "3",180,0,50,80,"2",180,100,50,80,"1",180,200,50,80
DATA "=",240,200,50,180,".",240,0,50,80,"0",240,100,50,80
DATA "Vx",0,0,50,80,"C",0,100,50,80,"CE",0,200,50,80
' terminate with "" and zeros
DATA "",0,0,0,0


