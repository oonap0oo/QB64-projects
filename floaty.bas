' Floaty                        K Moerman 2026
' A 'creature' with long tentacles that seems to float in circles. All made from math functions
SCREEN _NEWIMAGE(1000, 1000, 32): _TITLE "Floaty"
WINDOW SCREEN(-500, -500)-(500, 500): t = 0: dt = 1 / 200
DO ' loop for animation, each iteration is 1 frame
    LINE (-500, -500)-(500, 500), _RGB32(0, 60), BF
    FOR a = 0 TO 2 * _PI STEP 2 * _PI / 10000 ' loop for drawing shape, STEP 1/Npoints
        r = EXP((1 + 0.5 * SIN(6 * a)) * SIN(45 * a)) ' radius body shape
        amod = a + 0.15 * r * SIN(a - 6 * t + r) - 2 * t ' modulate angle a with t and r
        w = 8 + 1.2 * r * COS(amod) ' constructing along it's width
        h = 0.1 * (r * SIN(amod) + r * r - 3 * t) ' constructing along it's length
        x = 40 * w * COS(h) ' polar to rect
        y = 40 * w * SIN(h)
        col% = 80 * r * (1 + SIN(12 * r - 20 * t)) ' making up a color
        PSET (x, y), _RGB32(255 - col%, 220 - col%, col%)
    NEXT a
    _DISPLAY
    _LIMIT 60
    t = t + dt
LOOP
