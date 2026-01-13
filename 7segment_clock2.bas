' Digital clock with 7 segment display
' display is drawn, no Fonts are used

Option _Explicit

Const XMAX = 850 ' image dimensions
Const YMAX = 250
Const XU = 10, YU = 25 ' location of upper left corner of display
Const GAP = 12, SLENGTH = 50, SWIDTH = 10 ' dimensions of segment and gap between segments
Const FGCOL = _RGB32(255, 0, 0), BFCOL = _RGB32(0, 0, 0) ' forground and background colors

Dim logic(10) As String, segment(7) As String
Dim As Integer number, k, l, x, y, dx, dy, spacing, position, toggle
Dim As Long col, handle
Dim As String t, char

' segment switching logic is kept in a array of strings
' the number to be displayed is the index
' seven 1 or 0 characters represent the on/off state of the segments
' the segments are arranged in the strings as folllows:
'    ---1---
'   |       |
'   2       3
'   |       |
'    ---4---
'   |       |
'   5       6
'   |       |
'    ---7---
logic(0) = "1110111"
logic(1) = "0010010"
logic(2) = "1011101"
logic(3) = "1011011"
logic(4) = "0111010"
logic(5) = "1101011"
logic(6) = "1101111"
logic(7) = "1010010"
logic(8) = "1111111"
logic(9) = "1111011"

' Information how to draw each of 7 segments
' x,y,dx,dy
segment(0) = "0010"
segment(1) = "0001"
segment(2) = "1001"
segment(3) = "0110"
segment(4) = "0101"
segment(5) = "1101"
segment(6) = "0210"

' generate window with 32bit color mode
handle = _NewImage(XMAX, YMAX, 32)
Screen handle
_Title "7 Segment Clock"
Cls

spacing = SLENGTH + 2 * SWIDTH + 4 * GAP ' distance betwee two characters
toggle = 1 ' variable defines on or of state of duoble points
Do
    position = 0
    t = Time$
    For l = 1 To 8
        char = Mid$(t, l, 1)
        If char = ":" Then ' draw double point using circle() and paint()
            If toggle = 1 Then col = FGCOL Else col = BFCOL
            x = position + GAP + XU
            y = SLENGTH + GAP + YU
            Circle (x, y), SWIDTH, col
            Paint (x, y), col
            y = SLENGTH + GAP * 5 + YU
            Circle (x, y), SWIDTH, col
            Paint (x, y), col
            position = position + spacing / 3
        Else ' a number has to be drawn
            number = Val(char)
            For k = 0 To 6 ' loop through all 7 segments
                If Mid$(logic(number), k + 1, 1) = "1" Then
                    col = FGCOL ' segment is ON
                Else
                    col = BFCOL ' segment is OFF
                End If
                x = Val(Mid$(segment(k), 1, 1))
                y = Val(Mid$(segment(k), 2, 1))
                dx = Val(Mid$(segment(k), 3, 1))
                dy = Val(Mid$(segment(k), 4, 1))
                x = 10 + (SLENGTH + 2 * GAP) * x + GAP * dx + position + XU
                y = 10 + (SLENGTH + 2 * GAP) * y + GAP * dy + YU
                dx = SWIDTH + dx * SLENGTH
                dy = SWIDTH + dy * SLENGTH
                Line (x, y)-(x + dx, y + dy), col, BF
            Next k
            position = position + spacing
        End If
    Next l
    toggle = -toggle
    _Delay .5
Loop While InKey$ = ""
