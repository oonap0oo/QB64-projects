' mandelbrot fractal viewer
' -------------------------
'
' z_new = z^2 + c       z and c are complex numbers
' z = zr + zi*j         zr and zc remain constant
' c = cr + ci*j         cr and ci depend on coordinates
' z^2 = (zr+zi*j)^2 = zr^2 + 2*zr*zi*j - zi^2 = zr^2 - zi^2  + 2*zr*zi*j
' z_new = z^2 + c = (zr^2 - zi^2 + cr)  + (2*zr*zi + ci)*j
' real and imaginary parts:
' re(z_new) = zr^2 - zi^2 + cr
' im(z_new) = 2*zr*zi + ci
'
' K Moerman 2026

Option _Explicit

Const XMAX = 1920 ' image dimensions
Const YMAX = 1080
Const filename = "mandelbrot.png" 'default filename for PNG image file when saved
Const maxloopcount = 512 'maximum iterations for z_new = z^2 + c
Const fontpath = "\fonts\lucon.ttf", fontsize = 35 ' font used for help screen
Const xlini = -2.4, xuini = 1.1 ' initial boundaries for fractal
Const ylini = -1.25, yuini = 1.25
Const panstepsize = 1 / 4 ' distance fractal shifts when panning as ratio
Const zoomrectcolor = _RGB32(255) ' color with alpha transparency for zoom rectangle

Dim Shared As Long handle, col(maxloopcount), bufferhandle
Dim Shared As Integer exitnormal
Dim Shared As Double xl, yl, xu, yu, dx, dy, newxl, newyl, aspect
Dim Shared As Double xlold, ylold, xuold, yuold, cr, ci
Dim Shared As String filepath

Dim As Integer counter
Dim As Long fonthandle
Dim As Double zr, zi, zrsq, zisq, x, y

' this can hold a copy of the screen, is used when drawing zoom rectangle with mouse
bufferhandle = _NewImage(XMAX, YMAX, 32)

' create full screen display image in 32 bit color
_FullScreen
handle = _NewImage(XMAX, YMAX, 32)
Screen handle
Cls

' create a font for larger text
' Environ$("SYSTEMROOT") : Find Windows Folder Path.
fonthandle = _LoadFont(Environ$("SYSTEMROOT") + fontpath, fontsize, "monospace")
_Font fonthandle

' get users home directory as starting point for optionally saving image files
filepath = Environ$("HOMEPATH")

' show user help info
showinfo

' create array of color values
createcolors

' the aspect ratio of the screen
aspect = YMAX / XMAX

' initial boundaries of viewing area
xl = xlini: xu = xuini
yl = ylini: yu = yuini
xlold = xl: xuold = xu: ylold = yl: yuold = yu

' main loop draws the mandelbot fractal and waits for user input
exitnormal = 0
Do
    dx = (xu - xl) / XMAX
    dy = (yu - yl) / YMAX
    For x = 0 To XMAX - 1
        cr = xl + x * dx ' real part of constant c depends on x position
        For y = 0 To YMAX - 1
            counter = 0
            zr = 0: zi = 0 ' set initial value of z for each run
            ci = yl + y * dy ' imaginary part of constant c depends on y position
            Do ' loop measures how quick z diverges with magnitude greater then 2
                zrsq = zr * zr: zisq = zi * zi ' large speed increase by replacing x^2 by x*x
                zi = 2# * zr * zi + ci
                zr = zrsq - zisq + cr
                counter = counter + 1
            Loop While (counter < maxloopcount) And ((zrsq + zisq) < 4#)
            PSet (x, YMAX - y), col(counter)
        Next y
    Next x
    While _MouseInput ' clear mouse inputs done while drawing was not complete
    Wend
    mousezoom ' wait for user input
Loop Until exitnormal

' release bufferimage, probable not really needed as program is exiting anyways?
_FreeImage bufferhandle
' dont wait for another keystroke to exit
System


' create array of color values
Sub createcolors
    Dim As Integer r, g, b, counter

    For counter = 0 To maxloopcount
        b = (counter Mod 32) * 8
        r = (counter Mod 127) * 2
        g = (counter Mod 64) * 4
        col(counter) = _RGB32(r, g, b)
    Next counter
End Sub

' calc new x boundary from mouse input
Function newx# (mousex As Integer, oldx As Double, dx As Double)
    newx# = oldx + mousex * dx
End Function

' calc new y boundary from mouse input
Function newy# (mousey As Integer, oldy As Double, dy As Double)
    newy# = oldy + (YMAX - mousey) * dy
End Function

' process mouse and key input
Sub mousezoom
    Dim As Integer mx, my, mx2, my2, mx2old, my2old

    Do ' wait for mouse button press or keystroke
        _Limit 500 ' slow down loop and release remaining cpu time
        If _MouseInput Then ' read mouse info
            If _MouseButton(1) Then Exit Do ' left mouse button press: start drawing zoom region
            If _MouseButton(2) Then zoomout: Exit Sub ' right mouse button press:zoom out
        End If
        If keystrokeexit% Then Exit Sub ' proces keystrokes and exit if required
    Loop
    ' left mouse button pressed
    mx = _MouseX: my = _MouseY
    newxl = newx#(mx, xl, dx): newyl = newy#(my, yl, dy)
    _PutImage , handle, bufferhandle ' take a copy of the screen
    Do ' wait for left mouse button release
        If _MouseInput Then ' if mouse actions are detected
            mx2old = mx2: my2old = my2 ' keep previous mouse pointer coord.
            mx2 = _MouseX: my2 = _MouseY
            If my2 > my Then ' selection rectangle keeps aspect ratio of screen
                my2 = my + Abs(mx2 - mx) * aspect
            Else
                my2 = my - Abs(mx2 - mx) * aspect
            End If
            ' restore the part of screen over which previous selection rectangle was drawn
            ' to erase previous rectangle
            _PutImage (mx, my)-(mx2old, my2old), bufferhandle, handle, (mx, my)-(mx2old, my2old)
            ' draw new selection rectangle
            Line (mx, my)-(mx2, my2), zoomrectcolor, B
        End If
    Loop Until Not _MouseButton(1)
    ' left mouse button released, calculate new x and y boundaries from screen coord.
    xlold = xl: xuold = xu: ylold = yl: yuold = yu
    xu = newx#(mx2, xl, dx): yu = newy#(my2, yl, dy)
    xl = newxl: yl = newyl
    ' xu should be greater then xl, yu should be greater then yl
    If xu < xl Then Swap xl, xu
    If yu < yl Then Swap yl, yu
End Sub

' Proces keystrokes if any, returns -1 (true) if program
' needs to stop waiting for further user mouse or keystroke input.
' Returns 0 (false) if program needs to continue waiting for user input
Function keystrokeexit%
    Dim As Long keycode
    Dim As String keychar
    Dim As Integer answer

    keycode = _KeyHit ' _keycode can also process arrow keys
    keychar = InKey$ ' neccesary to empty keystroke buffer apparently
    Select Case keycode
        Case 19200: panfractal "left": keystrokeexit% = -1 ' left arrow key, pan to the left
        Case 18432: panfractal "up": keystrokeexit% = -1 ' up arrow key, pan upwards
        Case 19712: panfractal "right": keystrokeexit% = -1 ' right arrow key, pan to the right
        Case 20480: panfractal "down": keystrokeexit% = -1 ' down arrow key, pan downwards
        Case 27: 'ESC, exit program
            answer = _MessageBox("Exit?", "Exit the program?", "yesno", "question")
            If answer = 1 Then
                exitnormal = _TRUE: keystrokeexit% = -1
            End If
        Case 115, 83: ' s or S, save image as PNG using dialog box
            saveimage: keystrokeexit% = 0
        Case 104, 72: ' h or H, display help screen
            showinfo:: keystrokeexit% = -1
        Case 114, 82: ' r or R, zoom out to initial view
            xl = xlini: xu = xuini
            yl = ylini: yu = yuini
            keystrokeexit% = -1
        Case 85, 117: ' u or U, undo previous zoom
            If xl <> xlold Or xu <> xuold Or yl <> ylold Or yu <> yuold Then
                xl = xlold: xu = xuold: yl = ylold: yu = yuold
                keystrokeexit% = -1
            End If
    End Select
End Function

' save the image on screen to a PNG file
Sub saveimage
    Dim As String filecompletepath

    filecompletepath = filepath + "\" + filename 'complete path as default choice
    ' display "save as" dialog box allowing to change path and filename
    filecompletepath = _SaveFileDialog$("Save image", filecompletepath, "*.png", "Image files")
    ' if user did not cancel, save image
    If filecompletepath <> "" Then _SaveImage filecompletepath, handle
End Sub

' show help info
Sub showinfo
    Dim As Integer r, c, i
    r = 4: c = 20
    Cls
    Color _RGB32(100, 100, 255)
    Locate 1 + r, c + 8: Print "Mandelbrot fractal viewer"
    Locate 3 + r, c: Print "Zoom in:               Hold left mouse button and drag"
    Locate 5 + r, c: Print "Zoom out :             Click right mouse button"
    Locate 7 + r, c: Print "Undo zoom:             Hit U key"
    Locate 9 + r, c: Print "Zoom out completely:   Hit R key"
    Locate 11 + r, c: Print "Pan in 4 directions:   Use arrow keys"
    Locate 13 + r, c: Print "Save image file:       Hit S key"
    Locate 15 + r, c: Print "Display this:          Hit H key"
    Locate 17 + r, c: Print "Exit:                  Hit Escape key"
    Locate 20 + r, c: Print "Hit any key or mouse button to continue"
    Locate 23 + r, c + 45: Print "K Moerman"
    Do
        _Limit 200
        If InKey$ <> "" Then Exit Do ' key press: leave info screen
        i = _MouseInput ' read mouse info
        If _MouseButton(1) Or _MouseButton(2) Then Exit Do ' left mouse button press: leave info screen
    Loop

End Sub

' pan in 4 possible directions by adjusting x and y boundaries
Sub panfractal (direction As String)
    Dim As Double yspan, xspan

    yspan = yu - yl: xspan = xu - xl
    Select Case direction
        Case "up":
            yl = yl + yspan * panstepsize
            yu = yu + yspan * panstepsize
        Case "down":
            yl = yl - yspan * panstepsize
            yu = yu - yspan * panstepsize
        Case "right":
            xl = xl + xspan * panstepsize
            xu = xu + xspan * panstepsize
        Case "left":
            xl = xl - xspan * panstepsize
            xu = xu - xspan * panstepsize
    End Select
End Sub

' zoom out by adjusting x and y boundaries
Sub zoomout
    Dim As Double yspan, xspan

    yspan = yu - yl: xspan = xu - xl
    xl = xl - xspan / 2: xu = xu + xspan / 2
    yl = yl - yspan / 2: yu = yu + yspan / 2
End Sub
