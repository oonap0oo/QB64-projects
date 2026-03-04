' Conway's Game of Life
' =====================

' from Wikipedia:

' Rules
'
' The universe of the Game of Life is an infinite, two-dimensional orthogonal grid of square cells,
' each of which is in one of two possible states, live or dead (or populated and unpopulated, respectively).
' Every cell interacts with its eight neighbours, which are the cells that are horizontally,
' vertically, or diagonally adjacent. At each step in time, the following transitions occur:
'
'     Any live cell with fewer than two live neighbours dies, as if by underpopulation.
'     Any live cell with two or three live neighbours lives on to the next generation.
'     Any live cell with more than three live neighbours dies, as if by overpopulation.
'     Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
'
' The initial pattern constitutes the seed of the system.
' The first generation is created by applying the above rules simultaneously to every cell in the seed,
' live or dead; births and deaths occur simultaneously,
' and the discrete moment at which this happens is sometimes called a tick.
' [nb 1] Each generation is a pure function of the preceding one.
' The rules continue to be applied repeatedly to create further generations.

' Rules for Game of life per number of neighbours
' alive/occupied = 1;   dead/empty = 0
' n neigbours        | new generation if 1      | new generation if 0
' .................................................................
' 0                  | 0                        | 0
' 1                  | 0                        | 0
' 2                  | 1                        | 0
' 3                  | 1                        | 1
' 4                  | 0                        | 0
' 5                  | 0                        | 0
' 6                  | 0                        | 0
' 7                  | 0                        | 0
' 8                  | 0                        | 0


Option _Explicit

Const title = "Conway's Game of Life"
Const Nrow = 75, Ncol = 125 'number of cells in 2 dimensions
Const size = 9 'size of one square cell in pixels
Const dt = 50E-3 ' time pause between each generation
Const gridcolor = _RGB32(60, 60, 60), cellcolor = _RGB32(255, 0, 0)

' the 'universe' or field is represented by a 2 dimensional array of unsigned bits
' unsigned bits can be 0 or 1 meaning 'dead' or 'alive'
' two arrays are used, one to hold current generation, other to receive next generation
' the two arrays swap these roles after each generation
Dim As _Unsigned _Bit cfield1(Nrow, Ncol), cfield2(Nrow, Ncol)
Dim Shared xmax, ymax As Integer ' dimensions of window
Dim Shared As Long handle, generation
Dim Shared As Integer glider(10), toad(12), blinker(6), gospergun(72) ' shape information


' data of different known shapes which exhibit interesting behaviour
' format; row,col,row,col,..

' gliders: move diagonally as generations pass
dataglider:
Data 1,0,2,1,2,2,1,2,0,2

' blinkers: oscillate between vertical and horizontal orientation
datablinker:
Data 0,0,1,0,2,0

' toads: oscillate in place
datatoad:
Data 1,0,1,1,1,2,0,1,0,2,0,3

' Gosper's gun = large shape generates gliders  while going through oscillations
datagospergun:
Data 5,1,5,2,6,1,6,2,5,11,6,11,7,11,4,12,8,12,3,13,9,13,3,14,9,14,6,15,4
Data 16,8,16,5,17,6,17,7,17,6,18,3,21,4,21,5,21,3,22,4,22,5,22,2,23,6,23
Data 1,25,2,25,6,25,7,25,3,35,4,35,3,36,4,36

' read data for shapes and store in arrays
readshapedata

' Adding shapes to the field
' format:
' addshape field(), shape(), row, column, horiz. direction, vert. direction

addshape cfield1(), gospergun(), 10, 10, 1, 1 ' at 10,10 normal orientation

addshape cfield1(), gospergun(), 14, 108, -1, 1 ' at 14,108 and flipped horizontally

' generate screen for display
createscreen

' main loop
generation = 0
Do
    _Delay dt ' wait dt in seconds, release cpu time to system
    drawfield cfield1() ' display cfield1 on screen
    nextgeneration cfield1(), cfield2() ' fill in cfield2 based on cfield1
    _Delay dt ' wait dt in seconds, release cpu time to system
    drawfield cfield2() ' display cfield2 on screen
    nextgeneration cfield2(), cfield1() ' fill in cfield1 based on cfield2
Loop Until InKey$ <> ""



' read various shapes from data lines and add them to their designated arrays
Sub readshapedata
    Dim As Integer r, c, k
    Restore dataglider
    For k = LBound(glider) To UBound(glider) - 1 Step 2
        Read r, c
        glider(k) = r: glider(k + 1) = c ' added to arrays: row,column,..
    Next k
    Restore datablinker
    For k = LBound(blinker) To UBound(blinker) - 1 Step 2
        Read r, c
        blinker(k) = r: blinker(k + 1) = c
    Next k
    Restore datatoad
    For k = LBound(toad) To UBound(toad) - 1 Step 2
        Read r, c
        toad(k) = r: toad(k + 1) = c
    Next k
    Restore datagospergun
    For k = LBound(gospergun) To UBound(gospergun) - 1 Step 2
        Read r, c
        gospergun(k) = r: gospergun(k + 1) = c
    Next k
End Sub

' add shape stored in array to the field with given position and orientation
' f(): the field to add shape to
' shepe(): array containing row,column coordinates of a shape
' row,col: position of left top cell of shape
' hdir,vdir: are either +1 or -1 to alter orientation of shape if wanted
Sub addshape (f() As _Unsigned _Bit, shape() As Integer, row As Integer, col As Integer, hdir As Integer, vdir As Integer)
    Dim k As Integer
    For k = LBound(shape) To UBound(shape) - 1 Step 2
        f(shape(k) * vdir + row, shape(k + 1) * hdir + col) = 1
    Next k
End Sub

' draw a field on screen
Sub drawfield (f() As _Unsigned _Bit)
    Dim As Integer c, r
    Cls
    ' draw alive cells
    For r = 0 To Nrow - 1
        For c = 0 To Ncol - 1
            If f(r, c) = 1 Then ' draw a cell when value is 1
                PReset (c * size, r * size)
                Line -Step(size, size), cellcolor, BF
            End If
        Next c
    Next r
    ' draw grid lines
    For r = 0 To Nrow - 1
        Line (0, r * size)-Step(xmax, 0), gridcolor
    Next r
    For c = 0 To Ncol - 1
        Line (c * size, 0)-Step(0, ymax), gridcolor
    Next c
    ' update window title showing generation number
    _Title title + "  -  Generation " + Str$(generation)
    _Display ' wait to display all graphic commands until this point, runs smoother
End Sub

' determine the number of alive neighbours around a cell
Function neighbours% (f() As _Unsigned _Bit, r As Integer, c As Integer)
    Dim As Integer c2, r2, csource, rsource, n
    n = 0
    For r2 = -1 To 1
        For c2 = -1 To 1
            rsource = r + r2: csource = c + c2
            Select Case rsource ' make the system 'wrap around' the edges of field
                Case -1: rsource = Nrow - 1
                Case Nrow: rsource = 0
            End Select
            Select Case csource
                Case -1: csource = Ncol - 1
                Case Ncol: csource = 0
            End Select
            n = n + f(rsource, csource)
        Next c2
    Next r2
    neighbours% = n - f(r, c) 'do not count the center cell itself as a neighbour
End Function

' determine which cells live in next generation based on previous
' generation in array fsource and store next generation in array fdest
' Any live cell with fewer than two live neighbours dies, as if by underpopulation.
' Any live cell with two or three live neighbours lives on to the next generation.
' Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
' Any live cell with more than three live neighbours dies, as if by overpopulation.
Sub nextgeneration (fsource() As _Unsigned _Bit, fdest() As _Unsigned _Bit)
    Dim As Integer c, r
    For r = 0 To Nrow - 1
        For c = 0 To Ncol - 1
            Select Case neighbours%(fsource(), r, c)
                Case 2: ' two neighbours -> stays alive when already living
                    If fsource(r, c) = 1 Then fdest(r, c) = 1 Else fdest(r, c) = 0
                Case 3: ' three neighbours -> always alive
                    fdest(r, c) = 1
                Case Else: ' fewer then 2 or more then 3 neighbours -> not alive
                    fdest(r, c) = 0
            End Select
        Next c
    Next r
    ' keep track of number of generations
    generation = generation + 1
End Sub

'generate screen for display
Sub createscreen
    xmax = Ncol * size: ymax = Nrow * size ' number of cells times cell size in pixels
    handle = _NewImage(xmax, ymax, 32)
    Screen handle
    _ScreenMove 0, 0 ' position window so it is completely visible without manually moving
End Sub
