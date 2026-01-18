' Modular multiplication circle

Const XMAX = 1000, YMAX = 1000 ' image dimensions
Const top_margin = 40 ' upper margin left for text placement
Const title = "Modular multiplication circle "
Const font_path = "C:\Windows\Fonts\Cour.ttf" ' path to TTF font to use for printing on plot

Dim As Integer x(400), y(400), n, x_center, y_center, radius
Dim As Integer m, p, value, d
Dim As Double angle
Dim As Long handlegraph, co
Dim As String imgname, s

' new image for graph in 32bit mode
handlegraph = _NewImage(XMAX, YMAX, 32)
Screen handlegraph

radius = YMAX / 2 - top_margin - 10
x_center = XMAX / 2: y_center = YMAX / 2 + top_margin

Read m, p ' read first pair of values
Do
    Cls
    imgname = title + "  m = " + Str$(m) + "  p = " + Str$(p)
    _Title imgname
    ' calculate coordinates of points on circle and store in arrays
    For n = 0 To m - 1
        angle = 2 * _Pi * n / m + _Pi / 2
        x(n) = x_center - radius * Cos(angle)
        y(n) = y_center - radius * Sin(angle)
    Next n
    ' draw outline of circle
    Circle (x_center, y_center), radius, _RGB32(255, 255, 255)
    ' draw lines between points determined bij mod - multiplication
    For n = 0 To m - 1
        value = (n * p) Mod m
        Line (x(value), y(value))-(x(n), y(n)), _RGB32(255, 255, 255)
    Next n
    ' add text
    placetext XMAX / 2, 20, imgname, 26, _RGB32(255, 255, 255)
    placetext XMAX - 80, YMAX - 45, "Hit Return", 20, _RGB32(255, 255, 255)
    Input s ' wait for return key
    Read m, p ' read next pair of values
Loop Until m = 0 ' loop until zeros at end of data is reached

Sleep

' Interesting combinations of m and p values, zero means end is reached
Data 300,77,224,91,224,114,300,158,298,60
Data 276,167,270,16,298,25,270,16,300,231
Data 254,182,232,133,0,0

' output center aligned text at x,y coord. with color co and size fontsize
Sub placetext (x As Integer, y As Integer, txt As String, fontsize As Integer, co As Long)
    _Font _LoadFont(font_path, fontsize, "MONOSPACE")
    Color co
    _PrintString (x - _PrintWidth(txt) / 2, y), txt
End Sub



