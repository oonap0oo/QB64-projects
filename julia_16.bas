_FULLSCREEN
10 REM Julia Fractal on legacy screen 12
15 REM Old school approach using line numbers, goto, gosub
20 SCREEN 12
25 GOSUB 270
30 LET width% = 640
40 LET height% = 480
55 LET ci# = 0.5213
60 LET cr# = -0.5125
70 FOR y% = 0 TO height%
80 FOR x% = 0 TO width%
90 LET zr# = x% / (width% - 2) * 3 - 1.5
100 LET zi# = y% / (height% - 2) * 2 - 1
130 LET i% = 0
140 REM start of loop which calculates z values
150 LET zrnew# = zr# ^ 2 - zi# ^ 2 + cr#
160 LET zi# = 2 * zr# * zi# + ci#
170 LET zr# = zrnew#
180 LET i% = i% + 1
190 IF (i% < 510) AND ((zr# ^ 2 + zi# ^ 2) < 4) THEN GOTO 150
220 PSET (x%, y%), i% / 32
230 NEXT x%
240 NEXT y%
250 SLEEP
260 END
265 REM subroutine to modify palette color attributes
270 FOR k% = 0 TO 15
280 LET blue% = k% ^ 2 / 4
290 LET red% = SQR(k%) * 16
300 LET green% = k% * 4 + 3
310 PALETTE k%, red% + green% * 256 + blue% * 65536
320 NEXT k%
330 RETURN
