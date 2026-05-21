' x+sin(y) Attractor   K Moerman 2026
' Visual effect based on FB post by Johnny Ray Tellefson and
' explanations in the comments by Jonathan David Gilbert
' in FB group "BASIC Programming Language"
' https://www.facebook.com/groups/2057165187928233/permalink/4308985552746174/

Option _Explicit
'Parameters
Const H = 550 ' height image in pixels
Const NLINES = 15E3 ' number of lines
Const NPOINTS = 15 ' number points each line
Const XMAX = 5 * _Pi, YMAX = 3 * _Pi '  max. initial values x and y
Const ALPHA = 100 ' alpha factor, determines transparency of each line
' declare all vars
Dim As Long nline: Dim As Integer npoint, r, g, b, style
Dim As Double x, y, x2, y2, colscale
' seed the rnd function
Randomize Timer
' set up image
Screen _NewImage(H * XMAX / YMAX, H, 32): _Title "x=x+sin(x) y=y+sin(y) attractor"
Window (-XMAX, -YMAX)-(XMAX, YMAX) 'automaitically scale coordinates to image
' precalc this value
colscale = 255 / NLINES
' choose random init. points x,y and iterate
For nline = 0 To NLINES - 1
    x = XMAX * (2 * Rnd - 1) ' give x and y random initial values
    y = YMAX * (2 * Rnd - 1) ' x,y can be any point in the image
    x2 = x: y2 = y
    For npoint = 0 To NPOINTS - 1 ' calc. points and draw line
        x = x + Sin(x) ' iterate sin attractor on x and y
        y = y + Sin(y)
        r = nline Mod 256: g = (nline Mod 65) * 4: b = (nline Mod 33) * 8
        Line (x2, y2)-(x, y), _RGB32(r, g, b, ALPHA) ' draw line segment with reduced alpha
        x2 = x: y2 = y
    Next npoint
Next nline
Sleep
