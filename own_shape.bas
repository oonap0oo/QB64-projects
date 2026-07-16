' Simple swimmer                        K Moerman 2026
' Own creation attempt inspired by the work of yuruyurau https://x.com/yuruyurau
SCREEN _NEWIMAGE(1000, 900, 32): _TITLE "Simple swimmer"
WINDOW SCREEN(-1, -1)-(1, 1)
DO
    FOR t = 0 TO 2 * _PI STEP _PI / 600 ' loop for animation, each iteration is 1 frame
        CLS
        FOR a = 0 TO 1 STEP 1 / 2999 ' loop for drawing shape, STEP 1/Npoints
            at = 2 * a * _PI - 8 * t
            b = SIN(450 * a) * (.7 + SIN(930 * a)) ' main shape of body
            e = 2 * a * EXP(-a * 8) ' envelope applied to body
            l = 1.5 * (0.7 - a) * (1 - b * b / 8) + t ' constructing shape along its length
            w = e * b - SIN(at) / 12 + 0.75 ' constructing shape in direction of it's width
            x = w * COS(l) ' polar to rectangular
            y = w * SIN(l)
            col% = 128 + 127 * COS(4 * b - a * 6) ' making up a color, changes across width of body
            IF a = 0 THEN PRESET (x, y) ELSE LINE -(x, y), _RGB32(col%, 255, 1 - col%)
        NEXT a
        _DISPLAY
        _LIMIT 60
    NEXT t
LOOP
