' Munching squares with animated palette, added a sphere.
DefSng A-Z: Dim p(1023) As Long, i As Integer, j As Integer, b As Integer, n As Integer: Screen 13
For i = 0 To 127: c = i: If c > 63 Then c = Abs(127 - c)
p(i) = c * 256& * 256& + c * 256& + c: For j = 1 To 2: p(i + 128 * j) = p(i)
Next j: Next i: Palette Using p(0): R = 150: d = 300
For i = 0 To 1000: For j = 0 To 1000
x = R * Sin((i - 500) / 500 * 1.5707)
z = R * Sin((j - 500) / 500 * 1.5707)
s = R * R - x * x - z * z
If s >= R * R / 4 Then
y = -Sqr(s): f = 160 / (d + y)
b = ((i \ 4 + 20) Xor (j \ 4)) And 63
PSet (160 + x * f, 100 - z * f), b + 1
End If
Next j: Next i
While InKey$ <> Chr$(27)
Palette Using p(n): Palette 0, 0: n = (n + 1) Mod 256
t = Timer + .05: While t > Timer: Wend
Wend


