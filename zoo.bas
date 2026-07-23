' Jellies, swimmers and snails                       K Moerman 2026
' Own creation attempts inspired by the work of yuruyurau https://x.com/yuruyurau
CONST imw = 1100, imh = 900, aspect = imw / imh, himh = imh / 2, himw = imw / 2

hfg& = Foreground ' generate foreground image and assign to handle
hbg& = Background ' generate background image and assign to handle

hdspl& = _NEWIMAGE(imw, imh, 32) ' new image for display
SCREEN hdspl&: _TITLE "Jellies, swimmers and snails"
WINDOW SCREEN(-aspect, -1)-(aspect, 1) ' map coordinates, center in middle

DO
    FOR t = 0 TO 12 * 2 * _PI STEP _PI / 600 ' loop for animation, each iteration is 1 frame
        CLS
        _PUTIMAGE , hbg&, hdspl& ' put background image on display, deleting previous frame
        tjelly = t / 3: tsnail = t / 12 ' jellies and snails are slower
        RANDOMIZE USING 2 ' reinit rnd to generate same pseudo random sequence each frame
        Jellies tjelly ' draw group of jellies
        Swimmer t, 0.75, 1 ' draw 3 "swimmers" at different positions
        Swimmer t - 1.2, 0.58, .8
        Swimmer t - 2.4, 0.65, .6
        Snail -tsnail + 2.3, 0.80 ' draw 2 snails at different positions
        Snail tsnail + 3.4, 0.85
        RANDOMIZE USING 2 ' reinit rnd to generate same pseudo random sequence each frame
        Plants t ' draw group of plants
        _PUTIMAGE , hfg&, hdspl& ' put foreground image with border (transparent in middle)
        _DISPLAY ' wait to update image here, smoother animation
        IF INKEY$ = CHR$(13) THEN 'making a clean exit if RETURN pressed
            _FREEIMAGE hbg& ' free the fg and bg image from memory
            _FREEIMAGE hfg&
            END
        END IF
        _LIMIT 60 ' limit loop time to 60 frames/s
    NEXT t
LOOP

' draw foreground "cave like" border on seperate image and return handle
' only called once at start of program, image used every frame
FUNCTION Foreground&
    hfg& = _NEWIMAGE(imw, imh, 32)
    _DEST hfg&
    FOR a = 0 TO 2 * _PI STEP _PI / 40
        ' calc random looking radius values
        r = (2 + SIN(2 * 10 * a) + SIN(_PI * 10 * a)) / 4 * 175 + 330
        x = himw + aspect * r * COS(a) 'polar to rectangular
        y = himh + r * SIN(a)
        ' always leave gap from edges for PAINT statement
        'x = _CLAMP(x, 10, imw - 10)
        'y = _CLAMP(y, 10, imh - 10)
        ' not using _clamp allows use of other QB64 version
        IF x < 10 THEN x = 10 ELSE IF x > imw - 10 THEN x = imw - 10
        IF y < 10 THEN y = 10 ELSE IF y > imh - 10 THEN y = imh - 10
        IF a = 0 THEN ' first point: store coord. and set graphics cursor
            x0 = x
            y0 = y
            PRESET (x, y)
        ELSE
            LINE -(x, y), _RGB32(1) ' rest of points: draw lines
        END IF
    NEXT a
    LINE -(x0, y0), _RGB32(1) ' close the set of lines for PAINT statement
    PAINT (0, 0), _RGB32(0), _RGB32(1) ' fill border (outside of drawn lines) with black
    Foreground& = hfg&
END FUNCTION

' draw background on seperate image in memory and return handle
' only called once at start of program, image used every frame
FUNCTION Background&
    hbg& = _NEWIMAGE(imw, imh, 32)
    _DEST hbg&
    ' draw brighter looking patch in center
    ym = himh * 8 / 9
    CLS
    FOR a = 0 TO 2 * _PI STEP _PI / 40
        ' calc random looking radius values
        r = (2 + SIN(2 * 10 * a) + SIN(SQR(2) * 10 * a)) / 4 * 100 + 190
        x = himw + 1.35 * aspect * r * COS(a) 'polar to rectangular
        y = ym + r * SIN(a)
        IF a = 0 THEN ' first point: store coord. and set graphics cursor
            x0 = x
            y0 = y
            PRESET (x, y)
        ELSE
            LINE -(x, y), _RGB32(1) ' rest of points: draw lines
        END IF
    NEXT a
    LINE -(x0, y0), _RGB32(1) ' close the set of lines for PAINT statement
    PAINT (himw, ym), _RGB32(170), _RGB32(1) ' fill insede of drawn lines light grey
    ' draw diffuse light effect, dimmer towards botttom
    ' use alpha for transparency to allow brighter patch to show through
    rmax = _HYPOT(himh, imh) ' maximum radius, middle of upper edge to bottom corners
    FOR x = 0 TO imw ' loop through each pixel
        FOR y = 0 TO imh
            r = _HYPOT(x - himw, y) / rmax ' distance from middle of upper edge
            col = 0.5 + 0.5 * COS(_PI * r) ' drop off as r increases
            red% = 2 + col * (99 - 2) ' RGB values shift from brightest to darkest color
            green% = 7 + col * (150 - 7)
            blue% = 16 + col * (225 - 16)
            PSET (x, y), _RGB32(red%, green%, blue%, 220) ' draw pixel with transparency
        NEXT y
    NEXT x
    Background& = hbg&
END FUNCTION

' draw group of Jellies at random positions and different t phases
SUB Jellies (t)
    FOR dt = 0 TO 2 * _PI STEP _PI / 9
        Jelly t - dt, .05 + RND * .55
    NEXT dt
END SUB

' draw 1 "Jelly", shape generated using math functions
SUB Jelly (t, dx)
    FOR a = 0 TO 1 STEP 1 / 599 ' loop for drawing shape, STEP 1/Npoints
        ma = 1 - a
        at = 2 * a * _PI - 8 * t ' combination a (part of shape) and time
        b = SIN(400 * a) + SIN(3 * 400 * a) / 5 ' main shape of body
        e = SQR(1 - ma * ma) / (1 + EXP(90 * (a - .4))) ' envelope applied to body
        cl = 1 - 0.2 * SIN(at) ' contraction along length
        cw = 1 - 0.5 * COS(at) ' contraction in direction of width
        tl = .2 * (a > .45) * SIN(-at) * (a - .45) ' tail of jelly
        l = 0.2 * (-.2 - a) * cl ' constructing shape along its length
        w = 0.065 * e * b * cw + tl + dx ' constructing shape in direction of it's width
        x = w * COS(t) - l * SIN(t) 'rotating shape with time
        y = w * SIN(t) + l * COS(t)
        col% = 80 * COS(at) ' making up a color
        PSET (x, y), _RGB32(255, 255, 170 + col%) 'Jellies made up from points
    NEXT a
END SUB

' draw 1 fish-like "Swimmer"
SUB Swimmer (t, dr, scale)
    da = 1 / 2499 / scale * dr / 0.75 ' determine number of points to be calculated
    FOR a = 0 TO 1 STEP da ' loop for drawing shape
        at = 2 * a * _PI - 8 * t ' combination a (part of shape) and time
        b = SIN(450 * a) * (.7 + SIN(930 * a)) ' main shape of body
        e = 2 * a * EXP(-a * 8) ' envelope applied to body
        l = 1.5 * scale * (0.7 - a) * (1 - b * b / 8) + t ' constructing shape along its length
        w = scale * (e * b - SIN(at) / 12) + dr ' constructing shape in direction of it's width
        x = w * COS(l) ' polar to rectangular
        y = w * SIN(l)
        col% = 200 * COS(4 * b - a * 6) ' making up a color, changes across width of body
        IF a = 0 THEN PRESET (x, y) ELSE LINE -(x, y), _RGB32(50 + col%, 200, 255 - col%)
    NEXT a
END SUB

' draw 1 "snail"
SUB Snail (t, dr)
    da = 1 / 599 / dr ' STEP 1/Npoints
    FOR a = 0 TO 1 STEP da ' loop for drawing shape
        at = 2 * a * _PI - 18 * t ' combination a (part of shape) and time
        b = SIN(100 * a) * SIN(300 * a) * SIN(500 * a) ' main shape of body
        e = 0.45 * dr * SIN(_PI * a) ' envelope applied to body
        l = 0.3 * dr * (1 - a) * (1 - 0.6 * SIN(at) * b * b) + t ' constructing shape along its length
        w = 0.22 * dr * e * b + .01 * SIN(at) + dr ' constructing shape in direction of it's width
        x = w * COS(l) ' polar to rectangular
        y = w * SIN(l)
        col% = 150 * ABS(b) ' making up a color, changes across width of body
        IF a = 0 THEN PRESET (x, y) ELSE LINE -(x, y), _RGB32(100 + col%, 100 + col%, 255 - col%)
    NEXT a
END SUB

' draw all plants at random positions and random t phases
SUB Plants (t)
    FOR n = 1 TO 15
        angle = .2 + 2.7 * RND ' position determined by angle
        dt = _PI * RND
        Plant t + dt, angle
    NEXT n
END SUB

' draw 1 "plant"
SUB Plant (t, angle)
    FOR a = 0 TO 1 STEP 1 / 199 ' loop for drawing shape, STEP 1/Npoints
        at = 2 * _PI * a - 2 * t ' combination a (part of shape) and time
        b = SIN(340 * a) ' main shape of body
        e = 1 - a ' envelope applied to body
        w = 0.04 * b * e + 0.1 * SIN(at) * a + angle ' constructing shape in direction of it's width
        l = aspect - 0.7 * a ' constructing shape in direction of it's length
        x = l * COS(w) ' polar to rectangular
        y = l * SIN(w)
        IF a = 0 THEN PRESET (x, y) ELSE LINE -(x, y), _RGB32(111 * a, 211 * a, 194 * a)
    NEXT a
END SUB

