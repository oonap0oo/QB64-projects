' Rotating sphere         K Moerman 2026
' Using a fixed image as sphere surface, generated once and stored in memory.
' Each frame this background image is copied to display and lines are redrawn
' for each new rotation position
Option _Explicit
Const S = 600, R = 250 'S:size in pixels of window, R: radius of sphere in pixels
Const N1 = 40, DA1 = 2 * _Pi / N1 'N1: number of latitudes and calculated step size
Const N2 = 40, DA2 = 2 * _Pi / N2 'N2: number of longitudes and calculated step size
Const Nfrhor = 450, Nfrver = 1100 'Nfrhor,Nfrver: number of frames horizontal,vertical rotation
Const col = _RGB32(0) 'color of lines
Const XL = 1, YL = 1.2, ZL = .6 'vector defining light source for sphere surface
Dim As Single x, y, z, yr, zr, xp(N1), zp(N1), angle1, angle2
Dim As Single rothorz, rotvert, cos_rotvert, sin_rotvert
Dim As Integer k1, first: Dim As Long hdisp, hsurf
' generate image containing sphere surface will be used as background drawing lines on top
hsurf = gensurf&
' generate image for display
hdisp = _NewImage(S, S, 32): Screen hdisp: Window (-S / 2, -S / 2)-(S / 2, S / 2)
_Title "Rotating Sphere"
' main animation loop
rothorz = 0: rotvert = 0
Do
    _Limit 60 'pace animation and release remaining CPU
    cos_rotvert = Cos(rotvert): sin_rotvert = Sin(rotvert) 'calc once use many times
    _PutImage , hsurf, hdisp 'place stored img with background on display also erases prev. frame contents lines
    For angle2 = 0 To 2 * _Pi + DA2 Step DA2 'loop through longitudes
        first = _TRUE: k1 = 0
        For angle1 = 0 To _Pi + DA1 Step DA1 'loop through latitudes
            y = R * Sin(angle1) * Sin(angle2 + rothorz) 'spherical to cart. coord.
            z = R * Cos(angle1)
            x = R * Sin(angle1) * Cos(angle2 + rothorz)
            zr = cos_rotvert * z - sin_rotvert * y 'rotation vertical around x axis
            yr = sin_rotvert * z + cos_rotvert * y
            If yr >= 0 Then 'if line should be visible...
                If first Then
                    first = _FALSE 'first visible point of current longitude, do not draw yet
                Else
                    Line -(x, zr), col ' draw segment of longitude line
                    If angle2 > 0 Then Line -(xp(k1), zp(k1)), col ' draw segment of latitude line
                End If
                PReset (x, zr) 'set graphical cursor up for next segment
            End If
            xp(k1) = x: zp(k1) = zr: k1 = k1 + 1 'store coord. to use with next line
        Next angle1
    Next angle2
    _Display 'display all graphical changes only now, runs smoother
    If rothorz < 2 * _Pi Then rothorz = rothorz + 2 * _Pi / Nfrhor Else rothorz = 0
    If rotvert < 2 * _Pi Then rotvert = rotvert + 2 * _Pi / Nfrver Else rotvert = 0
Loop Until InKey$ <> ""

' generate image with constant sphere surface and return handle
Function gensurf&
    Dim As Long himg: Dim As Single x, y, z, d, n
    himg = _NewImage(S, S, 32): _Dest himg: Window (-S / 2, -S / 2)-(S / 2, S / 2)
    n = Sqr(XL * XL + YL * YL + ZL * ZL) 'norm of lighting vector
    For x = -R + 1 To R + 1 ' iterate through ixels of square containing sphere
        For z = -R + 1 To R + 1
            If _Hypot(x, z) <= R + 1 Then 'If part of circle containing sphere...
                y = Sqr((R + 1) * (R + 1) - x * x - z * z) 'calc. depth or y coord.
                d = XL * x + YL * y + ZL * z: d = _Clamp(d / R / n, 0, 1) 'Dot product
                PSet (x, z), _RGB32(0, 20 + 235 * d, 0) 'draw sphere surface diffuse reflection
                If d > 0.96 Then PSet (x, z), _RGB32(255, 100 * d) 'draw specular reflection
            End If
        Next z
    Next x
    gensurf& = himg
End Function


