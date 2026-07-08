' Mandala for QB64          K Moerman 2026
' ESCAPE key terminates program, any other key draws new mandala
' Random figure drawn in 256 color mode, then the RGB of the colors is cycled
' The figure is made of colored disks drawn in each sector of the mandala
' this program was adapted from the first version made to be compatible
' with QBASIC 1.1 and QUICKBASIC 4.5, hence the use of sigils for variables

RANDOMIZE TIMER
CONST HW% = 300, HH% = 300, TXT$ = "Mandala "
SCREEN _NEWIMAGE(2 * HW%, 2 * HH%, 256) ' open window in 256 color mode
WINDOW (-HW%, -HH%)-(HW%, HH%) ' put coord. origin in middle

DIM SHARED cols&(256) ' array holds RGB combinations for 256 color attributes

GenerateRGB ' fill array with RGB values

DO ' main loop
    nsectors% = 9 + CINT(RND * 14) ' random number of sectors for mandala
    ndisks% = CINT(4500 / nsectors%) ' more sectors = less disks per sector
    _TITLE TXT$ + STR$(nsectors%) + " sectors, " + STR$(ndisks%) + " disks per sector"
    DrawFigure ndisks%, nsectors% ' draw the new mandala
    k$ = AnimateColors ' animate colors until a key is pressed, k$ contains key character
LOOP UNTIL k$ = CHR$(27) ' exit when ESCAPE is pressed
END

' sub to draw a filled disk based on Minsky circle algorithm
SUB disk2 (xc, yc, r, col%)
    e = 1 / r ' factor to advance x and y in minsky algor.
    dy = r ' start values for x and y
    dx = 0
    FOR n% = 0 TO CINT(_PI * r) ' repeat for half circumference
        dx = dx - e * dy ' update coord with minsky algor.
        dy = dy + e * dx
        LINE (xc + dx, yc + dy)-(xc - dx, yc + dy), col% 'draw horiz. line for each y
    NEXT n%
END SUB

' modify RGB content of 256 color attributes and store in array for re-use
SUB GenerateRGB
    FOR col% = 0 TO 255
        a = 2 * _PI * col% / 255
        red% = 32 + 31 * SIN(3 * a) ' RGB components in range 0..63
        blue% = 32 + 31 * SIN(2 * a + 2 * _PI / 3)
        green% = 32 + 31 * SIN(a + 4 * _PI / 3)
        cols&(col%) = red% + 256 * green% + 65536 * blue%
        PALETTE col%, cols&(col%)
    NEXT col%
END SUB

' Drawing of mandala figure
' 2=r*a^ndisks => 2/r=a^ndisks => (2/r)^(1/ndisks)=a
SUB DrawFigure (ndisks%, nsectors%)
    _DISPLAY ' pauze display updates till next _DISPLAY
    CLS
    anglesector = 2 * _PI / nsectors%
    cosangle = COS(anglesector): sinangle = SIN(anglesector)
    r = HW% * sinangle ' start value for radius of disks
    a = (2 / r) ^ (1 / ndisks%) ' multiplier <1 to reduce radius r during loop
    FOR disk% = 0 TO ndisks% - 1
        x = RND * (HW% - r) ' random value of center coord. x so disk still fits on screen
        y = 0 ' first sector y is zero
        col% = CINT(255 * RND) ' random one of 255 colors
        FOR sector% = 0 TO nsectors% - 1 ' draw same disk for each sector
            disk2 x, y, r, col%
            xnew = cosangle * x - sinangle * y ' rotation of x and y coord.
            y = sinangle * x + cosangle * y
            x = xnew
        NEXT sector%
        IF r > 2 THEN r = r * a ' reduce radius of disks as loop continues
    NEXT disk%
END SUB

' Main loop modifying rgb content of 256 attributes using array
FUNCTION AnimateColors$
    frame% = 0: k$ = ""
    DO
        FOR col% = 0 TO 255 ' go through all 256 colors
            index% = (col% + frame%) MOD 256 ' array index is offset by frame%
            PALETTE col%, cols&(index%) ' update color using RGB from array
        NEXT col%
        frame% = (frame% + 1) MOD 256 ' advance frame counter, 0..255
        _DISPLAY
        _DELAY 0.05
        k$ = INKEY$
    LOOP UNTIL k$ <> ""
    AnimateColors$ = k$
END FUNCTION

