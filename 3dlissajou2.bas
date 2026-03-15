' 3D Lissajou

Option _Explicit

Const title = "3D Lissajou"
Const Npoints = 1000 ' number of data points calculated and drawn
Const xmax = 600, ymax = 500 ' size of window
Const margin = 10 ' margin between window edges and drawing
Const yzangle = 25 * _Pi / 180 ' angle over which graph is rotated around x axis for viewing
Const dscr = 12 ' distance eyeball to projection screen
Const dxyz = 15 ' distance eyeball to xyz axes origin
Const Nanimframes = 200 ' number of animation frames in one 360 degrees rotation
Const Nanimchange = 250 ' number of animation frames before fx,fy and fz parameters are chenged
Const xscrmax = 1.25, yscrmax = 1.25, xscrmin = -1.25, yscrmin = -1.25 ' bounds of calculated and projected curve
Const markerstep = 10 ' data points between two highlighted markers


Dim Shared As Single x(Npoints), y(Npoints), z(Npoints) ' calculated coordinates
Dim Shared As Long scrhandle ' handle to screen window
Dim Shared As Single cos_yzangle, sin_yzangle, xyangle, dxyangle, limitxyangle, xscrscale, yscrscale
Dim Shared As Integer fx, fy, fz, py, pz

' Create window in 32 bits color mode
scrhandle = _NewImage(xmax, ymax, 32)
Screen scrhandle
Cls

' calculate values once, use many times
cos_yzangle = Cos(yzangle): sin_yzangle = Sin(yzangle)
xscrscale = (xmax - 2 * margin) / (xscrmax - xscrmin)
yscrscale = (ymax - 2 * margin) / (yscrmax - yscrmin)

xyangle = 0 ' variable controls rotation angle around vertical z axis
dxyangle = 2 * _Pi / Nanimframes ' one step for xyangle
limitxyangle = 2 * _Pi - dxyangle ' used to reset xyangle back to 0

py = -_Pi / 3: pz = -_Pi / 2 ' phase added to sine functions for y and z coordinates

Do ' main loop
    For fy = 3 To 9 Step 2
        For fz = 3 To 9 Step 2
            For fx = 1 To 9 Step 2
                If fy <> fz And fx <> fy And fx <> fz Then
                    _Title title + "  fx=" + Str$(fx) + " fy=" + Str$(fy) + " fz=" + Str$(fz)
                    calc_points ' calc new coordinates based on fx,fy,fz
                    drawpoints Nanimchange ' draw a number of rotating animation frames
                End If
            Next fx
        Next fz
    Next fy
Loop

' calculate new x,y,z coordinates and store in arrays
Sub calc_points
    Dim As Integer counter
    Dim As Single angle

    For counter = 0 To Npoints - 1
        angle = counter / (Npoints - 1) * 2 * _Pi ' angle goes from 0 to 2.pi
        x(counter) = Sin(fx * angle)
        y(counter) = Sin(fy * angle + py)
        z(counter) = Sin(fz * angle + pz)
    Next counter
End Sub

' draw a number of ratating animation frames using the 3D coordinates stored in arrays
Sub drawpoints (Nframes As Integer)
    Dim As Single cos_xyangle, sin_xyangle, fproject
    Dim As Single xr, yr, yr2, zr, xscr, yscr, hue, bri
    Dim As Integer animation, counter, offset, limitoffset, markersize, ismarker
    Dim As Long col

    offset = 0
    limitoffset = Npoints - 1
    For animation = 1 To Nframes
        _Limit 30 ' pace animation and release remaining CPU time
        cos_xyangle = Cos(xyangle): sin_xyangle = Sin(xyangle) ' calc once use for all frames
        Cls
        For counter = 0 To Npoints - 1
            ' rotate 3D coord. around z axis to tilt graph for viewing
            xr = x(counter) * cos_xyangle - y(counter) * sin_xyangle
            yr = x(counter) * sin_xyangle + y(counter) * cos_xyangle
            ' rotate 3D coord. around x axis to tilt graph for viewing
            yr2 = yr * cos_yzangle - z(counter) * sin_yzangle
            zr = yr * sin_yzangle + z(counter) * cos_yzangle
            ' project 3D to 2D
            fproject = dscr / (dxyz + yr2)
            xscr = xr * fproject
            yscr = zr * fproject
            ' scale coord. to screen window
            xscr = margin + (xscr - xscrmin) * xscrscale
            yscr = margin + (yscrmax - yscr) * yscrscale
            ' draw point
            ismarker = (((counter + offset) Mod markerstep) = 0) ' is -1 if marker, else 0
            hue = counter / Npoints * 360 ' hie goes through complete range of 360 degrees
            bri = 10 + (1 - yr2) / 2 * 50 - ismarker * 50 'brighter if at the front and extra bright if marker
            col = _HSB32(hue, 100, bri) ' make long color value out of Hue, Saturation and brightness
            markersize = 3 - ismarker * 2 ' marker is larger square then others
            PReset (xscr, yscr)
            Line Step(-markersize \ 2, -markersize \ 2)-Step(markersize, markersize), col, BF
        Next counter
        _Display ' all graphic commands only become visible at this point, runs smoother
        ' update xyangle for animated rotation
        If xyangle < limitxyangle Then xyangle = xyangle + dxyangle Else xyangle = 0
        ' update offset for travelling markers
        If offset < limitoffset Then offset = offset + 1 Else offset = 0
        If InKey$ <> "" Then End
    Next animation
End Sub



