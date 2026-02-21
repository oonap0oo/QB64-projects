# QB64-projects
coding in basic language using [QB64](https://qb64.com/) or [QB64 PE](https://www.qb64phoenix.com/)

## Julia fractal

Code: [julia4.bas](julia4.bas)

This basic code generates a plot of the Julia Fractal.

    The colors depend how fast the iterative formula diverges 
    z² + c  --> z
    where z and c are complex values
    initial value of z varies with coordinates in the image
    c is a constant

![julia2_screenshot2.png](julia2_screenshot2.png)

![julia2_screenshot1.png](julia2_screenshot1.png)

## Julia legacy version

A legacy version for old times' sake. Using screen 12 from the legacy QBASIC which has 640x480 resolution and a color palette with 16 attributes. The code also uses line numbers refering back to even older basic versions.

This updated version replaces x^2 operators with simple multiplcation x*x for a big speed increase. This was suggested by Simon Harris in Facebook groep 'BASIC Programming Language'. 

The code: [julia_16_2a.bas](julia_16_2a.bas)

![julia_16_screenshot.png](julia_16_screenshot.png)

## Mandelbrot fractal

Code: [mandelbrot.bas](mandelbrot.bas)

Similar to the Julia fractal, however initial value of z is now a constant and c varies with coordinates in the image.

![mandelbrot_screenshot1.png](mandelbrot_screenshot1.png)
![mandelbrot_screenshot2.png](mandelbrot_screenshot2.png)
![mandelbrot_screenshot3.png](mandelbrot_screenshot3.png)

## Sierpinski triangle

Code: [sierpinski3.bas](sierpinski3.bas)

This piece of code plots a Sierpinski triangle using the method called 'Chaos game'. 

From [wikipedia](https://en.wikipedia.org/wiki/Sierpi%C5%84ski_triangle#Chaos_game)

 1. Take three points in a plane to form a triangle.
 2. Randomly select any point inside the triangle and consider that your current position.
 3. Randomly select any one of the three vertex points.
 4. Move half the distance from your current position to the selected vertex.
 5. Plot the current position.
 5. Repeat from step 3.

![sierpinski3_screenshot.png](sierpinski3_screenshot.png)

## Logistic map

Code: [logistic.bas](logistic.bas)

A bifurcation diagram of the logistic map is plotted.

![logistic_screenshot.png](logistic_screenshot.png)

## Lorenz System

This script draws a sample solution to the Lorenz System. it uses a simple Euler method to calculate the values. Then it uses rotation matrices to rotate the 3D values around the z axis. A 2D representation is plotted using projection.

Code: [lorenz_3D3.bas](lorenz_3D3.bas)

lorenz system with three 1st order differential equations:

    dx/dt = sigma * (y - x) 
    dy/dt = x * (rho - z) - y
    dz/dt = x * y - beta * z

Used parameters of the Lorenz system:

    sigma = 10 
    beta = 8 / 3
    rho = 28

Initial conditions:

    x = 1.0
    y = 1.0
    z = 0.0

This is a GIF screen recording of the output, the real output tends to be smoother.

![lorenz_3D3.gif](lorenz_3D3.gif)

 ## King's Dream fractal

 Code: [kings_dream.bas](kings_dream.bas)

The following equations are iterated to find successive x,y values. The more often a x,y point is visited, the brighter the color is made.

    Sin(a * x) + b * Sin(a * y)    ->  x
    Sin(c * x) + d * Sin(c * y)    ->  y

Parameters:

    a = 2.879879 
    b = -0.765145
    c = -0.966918
    d = 0.744728

Initial values:
    x0 = 2.0, y0 = 2.0

![kings_dream_screenshot.png](kings_dream_screenshot.png)

## Hopalong Fractal

The code: [hopalong.bas](hopalong.bas)

A variation of the code for the 'King's dream fractal' yields this 'hopalong' fractal. This script draws the fractal defined by iterating the x,y values through the following function

    x = y - 1 - sqrt(abs(bx - 1 - c)) . sign(x-1)
    y = a - x - 1

The parameters a,b,c can be any value between 0.0 and 10.0. The initial values for x and y also change the fractal.
A lot of combinations seem to give an intresting fractal.

![hopalong1.png](hopalong1.png)

![hopalong2.png](hopalong2.png)

![hopalong3.png](hopalong3.png)

![hopalong3.png](hopalong3.png)

![hopalong4.png](hopalong4.png)

![hopalong5.png](hopalong5.png)

![hopalong6.png](hopalong6.png)

## Gumowski-Mira fractal

The code: [gumowski_mira.bas](gumowski_mira.bas)

This Gumowski-Mira fractal seems very sensitive to parameter and intial values.
This script draws the fractal defined by iterating the x,y values through the following function

        f(x) = ax + 2(1-a). x² / (1+x²)²
        xn+1 = by + f(xn)
        yn+1 = f(xn+1) - xn

with constants for example, they can be varied to give different fractals

        a = -0.7  a should be within [-1,1]
        b = 1.0 should be 1.0 (or very close?)

and initial values of x=-5.5, y=-5.0, they should be in [-20,20]

![gumowski_mira1.png](gumowski_mira1.png)

![gumowski_mira4.png](gumowski_mira4.png)

![gumowski_mira6.png](gumowski_mira6.png)

![gumowski_mira19.png](gumowski_mira19.png)

## Quadrup Two

The code: [quadruptwo.bas](quadruptwo.bas)

A further variation of the code for the 'King's dream fractal' yields the 'Quadrup Two' fractal. This script draws the fractal defined by iterating the x,y values through the following function

    x = y - sgn(x) * sin(ln|b * x - c|) * atan( (c * xn - b)2 )
    y = a - x

The constants a,b,c and inital values for x and y can be varied to yield different results.

![QuadrupTwo7.png](QuadrupTwo7.png)

![QuadrupTwo2.png](QuadrupTwo2.png)

![QuadrupTwo3png](QuadrupTwo3.png)

![QuadrupTwo4.png](QuadrupTwo4.png)

![QuadrupTwo1.png](QuadrupTwo1.png)

## 3D surface graph

Code: [3dsurfpr5.bas](3dsurfpr5.bas)

A 3D surface graph is drawn of 

    z(x,y)=sin(√(x²+y²))/√(x²+y²)

Parts of the surface which are to be hidden are erased using the _MapTriangle() function of QB64. 
Using projection, a vanishing point is added to the image.

![3dsurfpr5_screenshot.png](3dsurfpr5_screenshot.png)

## Clock with 7 segment display

Code: [7segment_clock2.bas](7segment_clock2.bas)

The display is drawn, no Fonts are used.

![7segment_record.gif](7segment_record.gif)

## Gingerbread Man Fractal

Code: [gingerbread_man.bas](gingerbread_man.bas)

This fractal is defined by the successive points obtained through:

    1 - y + Abs(x) -> x
    x -> y
    an initial point x0,y0

In this code the points are colored based in the distance between successive points

![gingerbread_man_screenshot.png](gingerbread_man_screenshot.png)

## Animated Lissajou

An animated lissajou image is created similar to an analog oscilloscope with 2 sine wave signals which are not phase locked. 

The code uses two images: one containing the white scale which has alpha transparency, a second on which the lissajou is drawn. 
The phase difference between the x and y signal is continuously increased which gives an animated result. 

The code also uses the _Display statement to delay update of the visible image until drawing is completed. 

Code: [lissajou2.bas](lissajou2.bas)

![lissajou2_recording.gif](lissajou2_recording.gif)

## Lotka-Volterra predator-prey model

According to Wikipedia:

The Lotka–Volterra equations, also known as the Lotka–Volterra predator–prey model, are a pair of first-order nonlinear differential equations, frequently used to describe the dynamics of biological systems in which two species interact, one as a predator and the other as prey. The populations change through time according to the pair of equations

    du/dt = alpha.u - beta.u.v
    dv/dt = -gamma.v + delta.u.y
    
    u is the prey population density
    v is the predator population density
    alpha is the maximum prey per capita growth rate
    beta is the effect of the presence of predators on the prey death rate
    gamma is the predator's per capita death rate
    delta is the effect of the presence of prey on the predator's growth rate

This piece of code calculates a solution and displays graphs of u and v versus time, also v versus u is plotted. The code uses the Euler method to numerically calculate a solution to the set of two ODEs.

The code: [lotka.bas](lotka.bas)

![lotka_screenshot.png](lotka_screenshot.png)

## Modular multiplication circle

Found on the web: "A modular multiplication circle is a visualization that uses a circle to represent numbers in a specific modulus and draws lines to connect points based on a multiplication pattern. "

This code draws a series of modular multiplication circles with interesting combinations of m and p variables.

Code: [mod_circle3.bas](mod_circle3.bas)

<img src="mod_circle_screenshot (1).png"> <img />

<img src="mod_circle_screenshot (3).png"> <img />

<img src="mod_circle_screenshot (5).png"> <img />

<img src="mod_circle_screenshot (8).png"> <img />

<img src="mod_circle_screenshot (9).png"> <img />

Also see the more extensive examples coded in Python: [https://github.com/oonap0oo/Modular-multiplication-circle](https://github.com/oonap0oo/Modular-multiplication-circle)

## Spirograph

Drawing images similar to those created using a physical Spirograph

The code: [spirograph3.bas](spirograph3.bas)

    x = (R - tau) * cos(alpha + offset) + rho * cos( (R - tau) / tau * alpha )
    y = (R - tau) * sin(alpha + offset) - rho * sin( (R - tau) / tau * alpha )
    alpha: independant variable, is angle of larger wheel
    offset: inner wheel starts at offset angle for each set of turns
    R: radius outer wheel is also related to number of teeth
    tau: radius smaller inner wheel is also related to number of teeth
    rho: distance position drawing pen from center of smaller wheel

![spirograph_screenshot9.png](spirograph_screenshot9.png)
![spirograph_screenshot2.png](spirograph_screenshot2.png)
![spirograph_screenshot3.png](spirograph_screenshot3.png)
![spirograph_screenshot5.png](spirograph_screenshot5.png)
![spirograph_screenshot6.png](spirograph_screenshot6.png)

## Basic Calculator

A very basic calculator, it has a user interface with buttons which are implemented in QB64.

The code: [calc3.bas](calc3.bas)

![calc_recording.gif](calc_recording.gif)

## Rabinovich-Fabrikant System
This piece of code will only compile with the [QB64 Phoenix edition](https://www.qb64phoenix.com/) due to the use of the _Min() and _Max() functions. These could be replaced with suitable if..then statements to accomplish the same functionality.

The [Rabinovich-Fabrikant equations](https://en.wikipedia.org/wiki/Rabinovich%E2%80%93Fabrikant_equations) are 3 coupled differential equations:

    dx/dt = y * (z - 1 + x * x) + gamma * x
    dy/dt = x * (3 * z + 1 - x * x) + gamma * y
    dz/dt = -2 * z * (alpha + x * y)
    alpha, gamma are parameters

It graphs a solution to the Rabinovich-Fabrikant equations which have three unknowns x,y z. The code then uses rotations and projection to convert each x,y,z point into a 2D representation for graphing. 

The code: [Rabinovich_Fabrikant.bas](Rabinovich_Fabrikant.bas)

Two examples:

![Rabinovich_Fabrikant1.png](Rabinovich_Fabrikant1.png)
![Rabinovich_Fabrikant2.png](Rabinovich_Fabrikant2.png)

## Aizawa Attractor
This piece of code will only compile with the [QB64 Phoenix edition](https://www.qb64phoenix.com/) due to the use of the _Min() and _Max() functions. These could be replaced with suitable if..then statements to accomplish the same functionality.

The code: [aizawa_attractor_rnd.bas](aizawa_attractor_rnd.bas)

The Aizawa attractor can give a spherical appearance, it is defined by the following coupled differential equations:

    dx/dt = (z - b) * x - d * y 
    dy/dt = d * x + (z - b) * y
    dz/dt = c + a * z - z * z * z / 3.0 - (x * x + y * y) * (1 + e * z) + f * z * x * x * x
    There are 5 parameters, the follwing values were used:
    a = 0.95 
    b = 0.7
    c = 0.6
    d = 3.5
    e = 0.25
    f = 0.1

The code graphs a set of solutions to the equations of the Aizawa attractor which have three unknowns x,y and z. It uses randomised initial conditions for the x parameter. The code then uses rotations and projection to convert each x,y,z point into a 2D representation for graphing. For each solution run a random color is used.

![aizawa_attractor_rnd1.png](aizawa_attractor_rnd1.png)
![aizawa_attractor_rnd2.png](aizawa_attractor_rnd2.png)

## Aizawa Attractor, rotating

This version displays an animated image of a rotating Aizawa Attractor.

The code: [aizawa_attractor_rotate.bas](aizawa_attractor_rotate.bas)

![aizawa_attractor_rotate.gif](aizawa_attractor_rotate.gif)

## Pascal's Triangle

This code prints the last digit of the values of the Pascal's triangle.

The odd values are marked with color, by doing this a Sierpinksy's triangle appears.

The code: [pascals_triangle2.bas](pascals_triangle2.bas)

![pascals_triangle2_2.png](pascals_triangle2_2.png)

## Thomas Attractor

The code graphs solution to the equations of the Thomas attractor which have three unknowns x,y and z. The 3D figure is rotated and projected to give an animated 2D representation.

The code: [Thomas_attractor4.bas](Thomas_attractor4.bas)

The Thomas attractor is defined by the following coupled differential equations:

    dx/dt = Sin(y) - b * x  
    dy/dt = Sin(z) - b * y
    dz/dt = Sin(x) - b * z
    There are one parameter
    b = 0.185
    The following initial values are used:
    x0 = 0.2 
    y0 = 0.5
    z0 = 0.3

This is a GIF screen recording of the output, the real output tends to be smoother.

<a href="Thomas_attractor4_recording.gif">
<img src="Thomas_attractor4_recording.gif" width="500"></img>
</a>


