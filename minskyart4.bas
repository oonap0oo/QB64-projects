' Minsky algorithm art      K Moerman 2026
' Using information from article 'The Integer Circle Algorithm'
' https://nbickford.wordpress.com/2011/04/03/the-minsky-circle-algorithm/
Option _Explicit
Const hw = 500, hh = 300 'dimensions of screen image
Const Nmax = 32767 'max munber of iterations
Dim As Integer x(Nmax), y(Nmax), x0, y0, r, g, b, p, answer
Dim As Double d, e: Dim As Long himg, n, k, co: Dim As String impath, fname, dstr
' create screen window
himg = _NewImage(hw * 2, hh * 2, 32): Screen himg: _ScreenMove 0, 0
Window Screen(-hw, -hh)-(hw, hh) ' make coord. 0,0 center of image
' get user input
Print "Minsky Algorithm Art" + Chr$(13) + "--------------------" + Chr$(13)
Print "Enter parameter d, a floating point number" + Chr$(13) + "Or just hit Enter for d=1.0"
Input d: If d = 0 Then d = 1
Print "Enter parameter p, must be integer number greater then 4"
Print "Interesting examples: 7, 9, 11, 13"
Input p: p = _Max(5, p): e = 4 / d * Sin(_Pi / p) ^ 2 ' calculate second parameter e
Cls
For y0 = -hh To hh ' iterate through columns of pixels
    For x0 = -hw To hw ' iterate through rows of pixels
        If Point(x0, y0) = _RGB32(0) Then ' Has point been plotted already? if not plot now
            x(0) = x0: y(0) = y0: n = 1 ' set initial conditions for each pixel depends on pixel position
            Do 'x,y are iterated until x0,y0 is encountered again or Nmax iterations reached
                x(n) = x(n - 1) - Int(y(n - 1) * d) ' Minsky algoritm
                y(n) = y(n - 1) + Int(x(n) * e) ' note: new value of x has to be used here
                If x(n) = x0 And y(n) = y0 Then Exit Do ' has iterated back to starting point
                If n = Nmax Then Exit Do ' max number of iterations reached
                n = n + 1
            Loop ' n is period: how many iterations it took to reach back to starting point
            g = (n Mod 128) * 2: r = (n Mod 65) * 4: b = (n Mod 33) * 8 'make up red,green,blue out of n
            co = _RGB32(r, g, b)
            For k = 0 To n ' plot all points calculated in iteration loop
                PSet (x(k), y(k)), co ' all the points on the trajectory loop have same period so same color
            Next k
        End If
    Next x0
Next y0
_Title "Minsky Art    d=" + Str$(d) + " p=" + Str$(p) + " e=" + Str$(e) ' set window title caption
'optionally save image as png
answer = _MessageBox("Save Image", "Save image as file?", "YesNo", "question", 0)
If answer = 1 Then
    dstr = _Trim$(Str$(d)): Mid$(dstr, InStr(dstr, ".")) = "_"
    fname = "minskyart" + _Trim$(Str$(p)) + dstr + ".png"
    impath = _SaveFileDialog$("Save image", fname, "*.PNG|*.JPG|*.*", "Image File")
    If impath <> "" Then _SaveImage impath, himg
End If
Sleep
