' Minsky algorithm art      K Moerman 2026
' Using information from article 'The Integer Circle Algorithm'
' https://nbickford.wordpress.com/2011/04/03/the-minsky-circle-algorithm/
' Changes of version 5:
' use 3 step algorithm to remove skewing
' If loop reaches max interations a choosen color is used iso. whatever Nmax hammens to give
' p is a floating point iso. integer and is looped through values automatically

Option _Explicit
Const hw = 500, hh = 300 'dimensions of screen image
Const Nmax = 32767 'max munber of iterations
Dim As Integer x(Nmax), y(Nmax), x0, y0, r, g, b, answer
Dim As Double d, e, p, hd: Dim As Long himg, n, k, co
Dim As String impath, fname, pstr, dstr, ky, label
' create screen window
himg = _NewImage(hw * 2, hh * 2, 32): Screen himg: _ScreenMove 0, 0
Window Screen(-hw, -hh)-(hw, hh) ' make coord. 0,0 center of image
' get user input
Print "Minsky Algorithm Art" + Chr$(13) + "--------------------" + Chr$(13)
Print "Enter parameter d" + Chr$(13) + "d is a floating point number, different from 0" + Chr$(13) + "Or just hit Enter for d=1.0"
Input d: If d = 0 Then d = 1
hd = d / 2 ' use d/2 because of 3 step algorithm
Print Chr$(13) + "Images will be generated stepping values for second parameter p from 5 to 30"
Print "Hit ENTER to continue to next image"
Print "Hit s to save an image to PNG" + Chr$(13)
Print "Hit any key to start"
While InKey$ = ""
    _Limit 60
Wend
' calculation and drawing
For p = 5 To 30 Step .5
    e = 4 / d * Sin(_Pi / p) ^ 2
    Cls
    For y0 = -hh To hh ' iterate through rows of pixels
        For x0 = -hw To hw ' iterate through columns of pixels
            If Point(x0, y0) = _RGB32(0) Then ' Has point been plotted already? if not plot now
                x(0) = x0: y(0) = y0: n = 1 ' set initial conditions for each pixel depends on pixel position
                Do 'x,y are iterated until x0,y0 is encountered again or Nmax iterations reached
                    x(n) = x(n - 1) - Int(y(n - 1) * hd) ' Minsky algoritm using int() as floor()
                    y(n) = y(n - 1) + Int(x(n) * e) ' note: new value of x has to be used here
                    x(n) = x(n) - Int(y(n) * hd) ' 3rd step to remove skewing in image
                    If x(n) = x0 And y(n) = y0 Then ' has iterated back to starting point
                        g = n Mod 256: b = (n Mod 128) * 2: r = (n Mod 65) * 4 'make up red,green,blue out of n
                        co = _RGB32(r, g, b)
                        Exit Do
                    End If
                    If n = Nmax Then ' max number of iterations reached
                        co = _RGB32(0, 0, 100) ' use fixed color in this case
                        Exit Do
                    End If
                    n = n + 1
                Loop ' n is period: how many iterations it took to reach back to starting point
                For k = 0 To n ' plot all points calculated in iteration loop
                    PSet (x(k), y(k)), co ' all the points on the trajectory loop have same period so same color
                Next k
            End If
        Next x0
    Next y0
    label = "   Minsky Art v5    d= " + Str$(d) + "   p= " + Str$(CInt(p * 100) / 100) + Space$(2)
    _PrintString (2 * hw - _PrintWidth(label), 2 * hh - _FontHeight), label: _Title label + "  Hit [enter] to continue, [s] to save"
    ky = ""
    While ky = ""
        ky = InKey$
        If ky = "s" Then 'optionally save image as png
            dstr = _Trim$(Str$(d)): Mid$(dstr, InStr(dstr, ".")) = "_" 'replace decimal point with "_"
            pstr = Str$(CInt(p * 100) / 100)
            pstr = _Trim$(pstr): Mid$(pstr, InStr(pstr, ".")) = "_"
            fname = "minskyart_p" + pstr + "d" + dstr + ".png"
            impath = _SaveFileDialog$("Save image", fname, "*.PNG|*.JPG|*.*", "Image File")
            If impath <> "" Then _SaveImage impath, himg
        End If
        _Limit 60
    Wend
Next p
Sleep

