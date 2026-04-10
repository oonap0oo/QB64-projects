' Arneodo Attractor on simulated analog oscilloscope  K Moerman 2026
'
' Inspired by Facebook post by Bernd Ulmann who used an analog computer
' and analog oscilloscope to visualise a solution to the Arneodo attractor.
' Differential equations:
' dx/dt = y
' dy/dt = z
' dz/dt = a * x - c * x^3 - b * y - z
' The program uses Euler method to calculate real time a solution to the 3
' differential equations, the value Z is plotted as function of x.
' Points are plotted with a high transparency (low alpha), pixels plotted more
' then one time become brighter. After a number of points an overlay with black transparent
' background is added which decreases the brightness of all points. The overlay also contains
' all grid lines and text, it is drawn 1 time before animation starts. This cycle is
' repeated continuously. This gives the illusion of a crt screen with some persistence.

Option _Explicit

'Arneodo Attractor parameters
Const a = 5.5, b = 3.5, c = 1.0 ' parameters of Arneodo Attractor System
Const x0 = 1.0, y0 = 1.0, z0 = 0.0 ' initial values of the three variables
Const DT = 0.005, N = 15000 ' time step for Euler and number of iterations before overlay is added

' graphing parameters
Const SW = 750, SH = 600, BRD = 30 ' image dimensions in pixels, border in pixels
Const XMAX = 4.5, YMAX = 14, FPS = 60 ' maximum x and y values, tipes per second the overlay is added
Const COLOVL = _RGB32(0, 10), COLPLOT = _RGBA32(20, 255, 20, 12) '32 bit color values with transparancy
Const COSCALE = _RGB32(80) ' opaque color for scale grid lines

Dim Shared As Double x, y, z, xnew, ynew, znew
Dim As Long counter, handlegraph, handleovl
Dim As Integer t1

handleovl = generate_overlay& ' Prepare the overlay on seperate image

handlegraph = _NewImage(SW, SH, 32): _ScreenMove 0, 0 ' generate 32bit image for screen output
Screen handlegraph: _Title "Arneodo Attractor on simulated analog oscilloscope  K Moerman 2026"
Window (-XMAX, -YMAX)-(XMAX, YMAX) ' automatically scale coord.

t1 = _FreeTimer: On Timer(t1, 60) refresh: Timer(t1) On 'reload initial conditions now and then

x = x0: y = y0: z = z0 ' load initial values
Do
    _Limit FPS ' pace animation and release remaining CPU
    For counter = 1 To N ' calc and draw (N) points
        xnew = x + DT * y ' calc new x,y,z values using Euler method
        ynew = y + DT * z
        znew = z + DT * (a * x - c * x * x * x - b * y - z)
        Line (x, z)-(xnew, znew), COLPLOT 'draw newly calculated point
        x = xnew: y = ynew: z = znew
    Next counter
    _PutImage , handleovl, handlegraph ' after number of iterations put overlay on screen
Loop ' Until InKey$ <> ""

'reload initial conditions now and then
Sub refresh
    x = x0: y = y0: z = z0 ' load initial values
End Sub

'generate overlay with scale and low alpha black background, return handle
Function generate_overlay&
    Dim handleovl As Long
    Dim As Integer counter, xscr, yscr

    handleovl = _NewImage(SW, SH, 32) ' make a 32bit image for overlay
    _Dest handleovl ' all output to the overlay image
    Line (0, 0)-(SW, SH), COLOVL, BF ' low alpha background
    Line (BRD, SH / 2)-(SW - BRD, SH / 2 + 1), COSCALE, BF ' hor. center scale line
    Line (SW / 2, BRD)-(SW / 2 + 1, SH - BRD), COSCALE, BF ' ver. center scale line
    Line (BRD, BRD)-(SW - BRD, SH - BRD), COSCALE, B ' outer rectangle
    Line (BRD + 1, BRD + 1)-(SW - BRD - 1, SH - BRD - 1), COSCALE, B ' outer rectangle 1 pixel smaller for thicker lines
    For counter = 1 To 50 ' small grid lines on horizontal axis
        xscr = counter / 50 * (SW - 2 * BRD) + BRD
        Line (xscr, SH / 2 - 10)-(xscr, SH / 2 + 10), COSCALE
    Next counter
    For counter = 1 To 40 ' small grid lines on vertical axis
        yscr = counter / 40 * (SH - 2 * BRD) + BRD
        Line (SW / 2 - 10, yscr)-(SW / 2 + 10, yscr), COSCALE
    Next counter
    For counter = 1 To 9 ' main grid lines on hor. axis
        xscr = counter / 10 * (SW - 2 * BRD) + BRD
        Line (xscr, BRD)-(xscr, SH - BRD), COSCALE
    Next counter
    For counter = 1 To 7 ' main grid lines on ver. axis
        yscr = counter / 8 * (SH - 2 * BRD) + BRD
        Line (BRD, yscr)-(SW - BRD, yscr), COSCALE
    Next counter
    Color COSCALE ' set color for text
    _PrintString (BRD + 1, 10), "QBScope  -  XY"
    _PrintString (BRD + 1, SH - BRD + 2), "CH1: 500mV/DIV   CH2: 2V/DIV"
    generate_overlay& = handleovl 'return handle to overlay image
End Function
