' Swimming Quiverbloom            K Moerman 2026
' Based on info at https://community.wolfram.com/groups/-/m/t/3516580?p_p_auth=FgO1nw3g
' Original work by yuruyurau: https://x.com/yuruyurau/status/1942231466446057727
SCREEN _NEWIMAGE(1000, 900, 32): _TITLE "Swimming Quiverbloom"
WINDOW SCREEN(-190, -200)-(190, 200)
DO
    FOR t = 0 TO 2 * _PI STEP _PI / 400
        CLS
        FOR x = 0 TO 12000 STEP .5
            y = x / 235
            k = (4 + SIN(x / 11 + 8 * t)) * COS(x / 14)
            e = y / 9 - 19
            d = _HYPOT(k, e) + SIN(y / 9 + 3 * t)
            q = 2 * SIN(2 * k) + SIN(y / 17) * k * (9 + 2 * SIN(y - 3 * d))
            c = d * d / 50
            xp = q - 50 * COS(c) - 85
            yp = d * 39 - q * SIN(c) - 620
            xr = xp * COS(t) - yp * SIN(t)
            yr = xp * SIN(t) + yp * COS(t)
            col% = 100 * SIN(3 * k)
            PSET (xr, yr), _RGB32(255, col% + 155, 255 - col%)
        NEXT x
        _DISPLAY
        _LIMIT 60
    NEXT t
LOOP

