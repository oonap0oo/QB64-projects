' Based on code posted by Eric Schraf titled 'Fractal'
' in the FB group 'BASIC Programming Language"
' https://www.facebook.com/groups/2057165187928233/permalink/3972382923073107/
' This version:   K Moerman 2026
' ----------------------------------------------------
' The program iterates the following:
' z_new = z^2 + c       z and c are complex numbers
' z = zr + zi*j         zr and zc depend on coordinates
' c = cr + ci*j         cr and ci remain constant
' real and imaginary parts:
' re(z_new) = zre^2 - zim^2 + cre
' im(z_new) = 2*zre*zim + cim
' Pixels are colored if the modulus of z approaches t within +-dmin
' the closer to t the brighter the pixel
' This version animates the fractal by cycling values of t, dmin and zoom factor

Option _Explicit

Const Cre = -0.8, Cim = 0.156 'constant to use in iteration
Const WS = 850, HS = 480 'size of image in pixels

Dim As Integer x, y, count, gr: Dim As Long col
Dim As Double zre, zim, zre_sq, zim_sq, d, mod_sq, a, t, zoom, dmin

Screen _NewImage(WS, HS, 32): _Title "Fractal"

a = 0
Do 'animation loop
    _Limit 30: Cls
    t = .505 + .495 * Cos(a): zoom = 3.5 / WS / (t * 0.75 + 1): dmin = 0.06 * (7 * t + 1) / 7
    For x = 0 To WS / 2 'loop through all pixels of image
        For y = 0 To HS - 1
            zre = (x - WS / 2) * zoom 'initial value of complex number z depends on
            zim = (y - HS / 2) * zoom 'coord. or position in image
            count = 0: d = dmin
            Do
                zre_sq = zre * zre: zim_sq = zim * zim: mod_sq = zre_sq + zim_sq
                If mod_sq > 48 Or count > 30 Or d < dmin Then Exit Do
                d = Abs(mod_sq - t) ' d is difference between zre^2+zim^2 and t
                zim = 2 * zre * zim + Cim 'real and imag part of new complex number z
                zre = zre_sq - zim_sq + Cre
                count = count + 1 'keep track of number of iterations
            Loop
            If d < dmin Then 'only draw points when loop was terminated because of d
                gr = 255 - 240 * d / dmin: col = _RGB32(gr, gr, 0)
                PSet (x, y), col ' draw left half of image
                PSet (WS - x, HS - y), col ' right half of image is mirrored in x and y directions
            End If
        Next y
    Next x
    _Display
    a = a + 0.03: If a > 2 * _Pi Then a = 0
Loop Until InKey$ <> ""


