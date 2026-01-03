' Bifurcation diagram of Logistic Map
' https://en.wikipedia.org/wiki/Logistic_map
' https://en.wikipedia.org/wiki/Bifurcation_diagram

Option _Explicit

Const XMAX = 1500, YMAX = 1000 ' image dimensions
Const a_start = 3.5, a_end = 4.0 ' interval parameter a
Const scale_factor = 7 ' makes map appear brighter
Const number_iterations = 6000 ' number of iterations of logistic formula
Dim As Long handle, co
Dim As Double a_span, z, a
Dim As Integer x, y, log_map(YMAX), index, k
Dim As String title, fontfile

title = "Bifurcation diagram of Logistic Map"
handle = _NewImage(XMAX, YMAX, 32)
Screen handle: _Title title
Cls

a_span = a_end - a_start
For x = 0 To XMAX - 1
    a = a_start + a_span * x / (XMAX - 1) ' parameter a increases with x
    z = 0.5 ' initial value of variable z
    For k = 1 To number_iterations
        z = a * z * (1.0 - z) ' logistic formula iterated
        index = z * (YMAX - 1)
        log_map(index) = log_map(index) + 1 ' keep score of which z values occured in array
    Next k
    For y = 0 To YMAX - 1 ' plot values in array as grey scale values in y direction
        co = log_map(y) * scale_factor
        If co > 255 Then co = 255
        PSet (x, YMAX - y), _RGB(co, co, co)
        log_map(y) = 0 ' make array ready for next x iteration
    Next y
Next x
Sleep






