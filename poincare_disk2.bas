' Poincare disk             K Moerman 2026
' relation between coord. on plane (x,y) and coord. on Poincare disk (xd,yd)
' r=sqr(x^2 + y^2)
' xd = tanh(r / 2) * x / r
' yd = tanh(r / 2) * y / r

DEFDBL A-Z ' variables without postfix are double precision float numbers iso. single  precision

CONST W = 950, HW = W / 2
CONST linecol& = _RGB32(80, 255, 80)
CONST D = 8 ' max coord. of plane figure before conversion to Poincare disk
CONST S = .45 ' size of one line drawing sector in plane figure before conversion to Poincare disk

SCREEN _NEWIMAGE(W, W, 32)
' calc. maximum coordinate the Poincare disk will reach
r = SQR(2) * D: xymax = SQR(2) * TANH(r / 2) * D / r
WINDOW (-xymax, -xymax)-(xymax, xymax) ' scaling coordinate system automatically
_TITLE "Poincare Disk"
DO
    FOR ds = 0 TO 2 * S - S / 120 STEP S / 120 ' animation loop, translates figure in x and y dir.
        CLS
        FOR xs = -D TO D STEP 2 * S ' drawing the set of line drawings
            FOR ys = -D TO D STEP 2 * S
                DrawSector xs + ds, ys + ds, S
            NEXT ys
        NEXT xs
        _DISPLAY
        _LIMIT 60
    NEXT ds
LOOP

' draw 1 line drawing centered around xs,ys with size s before conversion to Poincare disk
SUB DrawSector (xs, ys, s)
    FOR ds = 0 TO s STEP s / 9
        PoincareLine xs + ds, ys, xs, ys + s - ds, linecol&
        PoincareLine xs + ds, ys, xs, ys - s + ds, linecol&
        PoincareLine xs - ds, ys, xs, ys + s - ds, linecol&
        PoincareLine xs - ds, ys, xs, ys - s + ds, linecol&
    NEXT ds
END SUB

' draw a line on the Poincare disk, coordinates of start and end points are converted
SUB PoincareLine (x1, y1, x2, y2, col&)
    ' converting x and y coord from plane (x,y) to Poincare disk (xd,yd)
    ' r=sqr(x^2 + y^2)
    ' xd = tanh(r / 2) * x / r
    ' yd = tanh(r / 2) * y / r
    r = _HYPOT(x1, y1)
    tanhr = TANH(r / 2)
    p_x1 = tanhr * x1 / r
    p_y1 = tanhr * y1 / r
    r = _HYPOT(x2, y2)
    tanhr = TANH(r / 2)
    p_x2 = tanhr * x2 / r
    p_y2 = tanhr * y2 / r
    LINE (p_x1, p_y1)-(p_x2, p_y2), col&
END SUB

' From QB64 help Hyperbolic Tangent or SINH(x) / COSH(x)
FUNCTION TANH (x)
    TANH = (EXP(2 * x) - 1) / (EXP(2 * x) + 1)
END FUNCTION

