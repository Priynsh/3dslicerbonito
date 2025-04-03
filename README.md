# Bonito Sphere Slicer

## Overview
This project is an interactive **Sphere slicer** built with **Bonito** and **WGLMakie** in Julia.   
The app allows users to visualize a sphere whose temperature decreases as we move away from the equator and increases toward its core.   
One can visualize this using a Slicer, which allows the user to view just a slice of the 3D data dynamically.   
Also, one can analyse 3D volume plots for x,y, and z axes with the temperatures.   

## Features
- Interactive 3D visualization of volumetric data
- Adjustable slicing along **X**, **Y**, and **Z** axes using sliders
- Real-time updates of the 3D view and 2D projections
- Fully web-based interface using Bonito
## Demo
![Demo](https://github.com/Priynsh/3dslicerbonito/blob/main/3d.gif)

## Installation
Ensure you have Julia installed (version 1.9 or later recommended). Then, install the required dependencies:

```julia
using Pkg
Pkg.add(["Bonito", "WGLMakie", "LinearAlgebra", "HTTP", "WebSockets"])
```

## Running the Application
To start the server, run the following command in Julia:

```julia
include("volume_slicer.jl")
```


