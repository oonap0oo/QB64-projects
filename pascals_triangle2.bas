' Pascal's Triangle and Sierpinski"
Option _Explicit

Const N = 63
Const col1 = _RGB32(255, 255, 255), col2 = _RGB32(0, 0, 0)
Const col3 = _RGB32(0, 0, 0), col4 = _RGB32(255, 0, 0)

Dim As _Unsigned Long tr(N, N)
Dim As Integer r, c
' generate window
Screen _NewImage(1050, 550, 32)
_Font 8
_Title "Pascal's Triangle and Sierpinski"
Cls

tr(0, 0) = 1 ' Pascal's triangle starts with a single 1
For r = 1 To N ' calculate the values of the triangle
    tr(r, 0) = 1
    For c = 1 To r - 1
        tr(r, c) = tr(r - 1, c - 1) + tr(r - 1, c)
    Next c
    tr(r, r) = 1
Next r

Print Chr$(13)
For r = 0 To N ' print the last digit of each value of the triangle
    Color _RGB32(255, 255, 255), _RGB32(0, 0, 0)
    Print Space$(N - r + 1);
    For c = 0 To N
        If tr(r, c) <> 0 Then
            Color _RGB32(255, 255, 255), _RGB32(0, 0, 0)
            Print " ";
            If iseven%(tr(r, c)) Then Color col1, col2 Else Color col3, col4 ' mark the odd values
            Print Using "#"; tr(r, c) Mod 10; ' print only last digit
        End If
    Next c
    If r < N Then Print
Next r
Sleep

Function iseven% (a As Integer) ' is integer even
    iseven% = (a Mod 2) = 0
End Function
