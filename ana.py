#! /usr/bin/env python
"""ana.py.py

Description:
    Calculate the deflection of a nominally thick plate (agrees to about 1/2 d)

Usage:
    ana.py [options] --radius=<val> --thickness=<val> --pressure=<val> --young=<val> --poisson=<val>

    ana.py.py -h | --help

Options:
  --help                        Show this screen.
  --radius=<val>                Radius of the circle
  --elements=<val>              Take the first instance at or equal to this value
  --outer_nodes=<val>           Number of on the outer ring
  --inner_nodes=<val>           Number of on the inner ring (not the center)
  --young=<val>                 Young's modulus (material related)
  --poisson=<val>               Poisson's ratio (material related)
  --thickness=<val>             Thickness of plate
  --pressure=<val>              Uniform pressure on surface
"""

import os
import numpy as np
from docopt import docopt


def main():
    args = docopt(__doc__)
    
    # gather arguments
    # gather the optional arguments
    r = float(args['--radius'])
    z = float(args['--thickness'])
    p = float(args['--pressure'])
    E = float(args['--young'])
    v = float(args['--poisson'])

    # calculate the deflection
    w = 3.0*(1-v)*(5+v)*p*r**4/E/z**3/16

    if os.path.isfile('ana.dat'):
        f = open('ana.dat', 'a')
    else:
        f = open('ana.dat', 'a')
        f.write('# PIMCID: 234567891\n')
        f.write('#  nodes  elems                 w             thick             young           poisson            radius          pressure\n')

    f.write('       0      1  %18.17E  %18.17E  %18.17E  %18.17E  %18.17E  %18.17E\n' % (w,z,E,v,r,p))
    f.close()

# ----------------------------------------------------------------------
if __name__ == "__main__": 
    main()
