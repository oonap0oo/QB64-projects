# QB64-projects
coding in basic language using [QB64](https://qb64.com/) 

## Julia fractal

Code: [julia2.bas](julia2.bas)

This basic code generates a plot of the Julia Fractal.

    The colors depend how fast the iterative formula diverges 
    z² + c  --> z
    where z and c are complex values
    initial value of z varies with coordinates in the image
    c is a constant

![julia2_screenshot2.png](julia2_screenshot2.png)

![julia2_screenshot1.png](julia2_screenshot1.png)

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

Code: [lorenz.bas](lorenz.bas)

This script draws a sample solution to the Lorenz System. it uses a simple Euler method to calculate the values.

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

![lorenz_screenshot.png](lorenz_screenshot.png)

 ## King's Dream fractal

 Code: [kings_dream.bas](kings_dream.bas)

The following equations are iterated to find successive x,y values. The color of each x,y point is made brighter

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

## 3D surface graph

Code: [3dsurf2.bas](3dsurf2.bas)

A 3D surface graph is drawn of 

    z(x,y)=sin(√(x²+y²))/√(x²+y²)

Parts of the surface which are to be hidden are erased using the _MapTriangle() function of QB64

![3dsurf2_screenshot.png](3dsurf2_screenshot.png)



