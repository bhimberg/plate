# PLATE
   Uses Finite Element Method (FEM) to simulate displacement at the center of clamped plate (circular disk).

## Compilation
   Modify `Makefile` to select your Fortran compiler, then run `make` to compile `plate.e`.

## `fem.py`
### Description:
   Generates (circular, fixed) INPUT files for, and launches, `plate`
### Usage:
   `fem.py [options] --radius=<val> --outer_nodes=<val> --inner_nodes=<val>`  
   `fem.py [options] --radius=<val> --elements=<val>`  
   `fem.py -h | --help`  
### Options:
   ```--help                        Show this screen.  
   --radius=<val>                Radius of the circle.  
   --elements=<val>              Take the first instance at or equal to this value.  
   --outer_nodes=<val>           Number of nodes on the outer ring.  
   --inner_nodes=<val>           Number of nodes on the inner ring (not the center).  
   --young=<val>                 Young's modulus (material related).  
   --poisson=<val>               Poisson's ratio (material related).  
   --thickness=<val>             Thickness of plate.  
   --pressure=<val>              Uniform pressure on surface.  
   --plot                        Plot the surface elements.  
   --savefig=<string>             Name of the file to save the fig to.
   ```
