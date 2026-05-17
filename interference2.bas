' Interference        K Moerman 2026
' ----------------------------------
' Made for QB64 Phoenix Edition
' Made only to generate a visual effect, not a accurate simulation of a physics phenomenon
' Based on the general idea of two moving point sources with an interference pattern
' Note: _hypot(x,y) is a QB64 function which implements sqr(x*x+y*y)
Option _Explicit

Const w = 640, h = 400 ' image dimensions
Const hw = w / 2, hh = h / 2 ' middle of image
Const lambda = 56 ' wavelength related to point a and b
Const lanbda_2pi = lambda / (_Pi * 2)
Const Tper = .45 ' time period of point a and b
Const T_2pi = Tper / (_Pi * 2)
Const Na = 1000, Nb = 550 ' number of frames in one revolution of point a and b
Const Ra = 6 * hh / 7, Rb = Ra - 4 * lanbda_2pi ' radius of circular motion of point a and b
Const dta = 2 * _Pi / Na, dtb = 2 * _Pi / Nb ' increment step for ta and tb
Const dt = 1 / 60 ' time step

Dim As Single x, y, xa, ya, xb, yb, da, db, wave, ta, tb, t
Dim As Integer r, g, b, abswave

Screen _NewImage(w, h, 32): _Title "Interference" 'new display window 32 bit color
Window (-hw, -hh)-(hw, hh) ' put coord. x=0, y=0 in middle of display window

ta = 0: tb = 0: t = 0
Do
    _Limit 60 ' pace animation and release any remaining CPU
    xa = Ra * Cos(ta): ya = Ra * Sin(ta) ' update coord. of point a
    xb = -Rb * Cos(tb): yb = -Rb * Sin(tb) ' update coord. of point b
    For x = -hw To hw ' iterate through frame
        For y = -hh To hh
            da = _Hypot(x - xa, y - ya) ' distance pixel from point a
            wave = Sin(da / lanbda_2pi - t / T_2pi) ' wave emanating from point a
            db = _Hypot(x - xb, y - yb) ' distance pixel from point b
            wave = wave + Sin(db / lanbda_2pi - t / T_2pi) ' add wave emanating from point b
            abswave = CInt(Abs(wave) * 128) ' colors depend on abs value of wave
            r = abswave Mod 256: g = (abswave Mod 129) * 2: b = (abswave Mod 65) * 4
            If wave < 0 Then Swap r, b ' colors depend also on sign of wave
            PSet (x, y), _RGB32(r, g, b) 'plot the point
        Next y
    Next x
    _Display ' only display graphical changes at this point, runs smoother
    ta = ta + dta: If ta >= 2 * _Pi Then ta = 0 ' update angles for movement
    tb = tb + dtb: If tb >= 2 * _Pi Then tb = 0 ' of point a and b
    t = t + dt ' update time
Loop