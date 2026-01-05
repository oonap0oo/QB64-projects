' Lorenz System
Option _Explicit

Dim Shared As Double x, y, z, sigma, rho, beta, h
Dim As Integer x_scr, y_scr, co
Dim As Double x_low, x_high, y_low, y_high, z_low, z_high
Dim title As String
Dim As Long N, k

Const XMAX = 1300, YMAX = 900 ' image dimensions
title = "Lorenz System"
Screen _NewImage(XMAX, YMAX, 32): _Title title
Cls

sigma = 10 ' parameters Lorenz system
beta = 8 / 3
rho = 28
x = 1.0: y = 1.0: z = 0.0 'initial cond.
h = 0.005 ' time step for euler method
N = 40000 ' number of steps
x_low = -22: x_high = 22 ' viewing window
y_low = -20: y_high = 20
z_low = -1: z_high = 53

For k = 0 To N - 1 ' main loop for drawing
    euler_lorenz
    x_scr = XMAX * norm(x, x_low, x_high)
    y_scr = YMAX * (1 - norm(z, z_low, z_high))
    co = 255 * norm(y, y_low, y_high) ' variable y is used for color
    If k = 0 Then
        PSet (x_scr, y_scr)
    End If
    Line -(x_scr, y_scr), _RGB(255 - co, Abs(co - 127) * 2, co)
Next k

Sleep

Sub euler_lorenz ' calculate next x,y,z values using Euler method
    Dim As Double dx_dt, dy_dt, dz_dt, x_new, y_new, z_new
    dx_dt = sigma * (y - x) ' lorenz system with three 1st order diff. eq.
    dy_dt = x * (rho - z) - y
    dz_dt = x * y - beta * z
    x = x + dx_dt * h ' Euler method
    y = y + dy_dt * h
    z = z + dz_dt * h
End Sub

Function norm (v As Double, v_low As Double, v_high As Double) ' map value v in 0..1 interval
    norm = (v - v_low) / (v_high - v_low)
End Function


