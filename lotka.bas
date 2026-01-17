' Lotka-Volterra predator-prey model
' ----------------------------------
' du/dt = alpha.u - beta.u.v
' dv/dt = -gamma.v + delta.u.y
' u is the prey population density
' v is the predator population density
' alpha is the maximum prey per capita growth rate
' beta is the effect of the presence of predators on the prey death rate
' gamma is the predator's per capita death rate
' delta is the effect of the presence of prey on the predator's growth rate

Option _Explicit

Const XMAX = 1600, YMAX = 700 ' image dimensions
Const top_margin = 120 ' upper margin left for text placement
Const CO1 = _RGB32(100, 255, 100), CO2 = _RGB32(255, 100, 100) 'colors for plots
Const CO3 = _RGB32(100, 100, 255), white = _RGB32(255, 255, 255)
Const font_path = "C:\Windows\Fonts\Cour.ttf" ' path to TTF font to use for printing on plot
Const title = "Lotka-Volterra predator-prey model"

' parameters Lotka-Volterra eq.
Const alpha = 2
Const beta = 1
Const gamma = 2
Const delta = 0.95

' initial conditions
Const u0 = 6, v0 = 2 ' different values will yield different graph

' parameters script
Const N = 1E5 ' total number of iterations
Const T = 15 ' time interval covered
Const value_low_limit = 0, value_low_high_range = 6.2 ' low limit and range for calculated model values u and v

' declare variables
Dim As Long handlegraph, counter
Dim As Integer xscr, yscr1, yscr2, plot_interval, yscr1_old, yscr2_old, xtplotwidth
Dim Shared As Double u, v, h

' new image for graph in 32bit mode
handlegraph = _NewImage(XMAX, YMAX, 32)
Screen handlegraph
_Title title
Cls

h = T / N ' time step for Euler mthod
u = u0: v = v0 ' start with initial values
xtplotwidth = XMAX - (YMAX - top_margin) ' width of region for u,v vs time plot
plot_interval = N / xtplotwidth ' every plot_interval iterations a set of points is added to graph
xscr = 0
For counter = 0 To N
    euler_lotka ' update u and v values
    If (counter Mod plot_interval) = 0 Then 'time to update graph with new set of points
        yscr1 = calc_yscr#(u): yscr2 = calc_yscr#(v) ' calc. y coord. out of u and v
        If counter > 0 Then
            Line (xscr - 1, yscr1_old)-(xscr, yscr1), CO1 ' plot u versus time
            Line (xscr - 1, yscr2_old)-(xscr, yscr2), CO2 ' plot v versus time
            Line (XMAX - yscr1_old + top_margin, yscr2_old)-(XMAX - yscr1 + top_margin, yscr2), CO3 ' plot v versus u
        End If
        yscr1_old = yscr1 ' remember prev. values
        yscr2_old = yscr2
        xscr = xscr + 1 ' advance horizontal coord.
    End If
Next counter

' text output
placetext XMAX / 2, 10, title, 32, white
placetext xtplotwidth / 2, 60, "u and v versus time", 30, white
placetext XMAX - YMAX / 2, 60, "v versus u", 30, white
placetext xtplotwidth / 4, 95, "u = prey population density", 26, CO1
placetext xtplotwidth * 3 / 4, 95, "v = predator population density", 26, CO2

Sleep

' Euler method applied on Lotka Volterra system
' returns next values for u and v based on prev. ones
Sub euler_lotka
    Dim As Double du_dt, dv_dt
    du_dt = alpha * u - beta * u * v ' 2 ODEs for Lotka Volterra
    dv_dt = -gamma * v + delta * u * v
    u = u + du_dt * h ' use euler method to calc. next u and v values
    v = v + dv_dt * h
End Sub

' calc. screen coord. out of Lotka Volterra value
Function calc_yscr# (z As Double)
    calc_yscr# = YMAX - (YMAX - top_margin) * (z - value_low_limit) / value_low_high_range
End Function

' output center aligned text at x,y coord. with color co and size fontsize
Sub placetext (x As Integer, y As Integer, txt As String, fontsize As Integer, co As Long)
    _Font _LoadFont(font_path, fontsize, "MONOSPACE")
    Color co
    _PrintString (x - _PrintWidth(txt) / 2, y), txt
End Sub

