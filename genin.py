#!/usr/bin/env python
"""genin.py

Description:
    Generates (circular, fixed) INPUT files for the 'plate' algorithm

Usage:
    genin.py [options] --radius=<val> --outer_nodes=<val> --inner_nodes=<val>

    genin.py -h | --help

Options:
  --help                        Show this screen.
  --radius=<val>                Radius of the circle
  --outer_nodes=<val>           Number of on the outer ring
  --inner_nodes=<val>           Number of on the inner ring (not the center)
  --young=<val>                 Young's modulus (material related)
  --poisson=<val>               Poisson's ratio (material related)
  --thickness=<val>             Thickness of plate
  --pressure=<val>              Uniform pressure on surface
  --plot                        Plot the surface elements
"""

from __future__ import print_function
import matplotlib.pyplot as mpl

import os
import numpy as np
from docopt import docopt

def main():
    # parse the command line options
    args = docopt(__doc__)

    # gather all required arguments
    r = float(args['--radius'])
    ni = int(args['--inner_nodes'])
    nf = int(args['--outer_nodes'])

    # gather the optional arguments
    E = 5000.0
    if args['--young']:
        E = float(args['--E'])
    v = 0.3
    if args['--poisson']:
        v = float(args['--poisson'])
    z = 10.0
    if args['--thickness']:
        z = float(args['--thickness'])
    p = 1.0
    if args['--pressure']:
        p = float(args['--pressure'])

    # how many nodes and elements total?
    nodes = 1;
    for i in range(ni, nf+1):
        nodes += i
    elems = ni-1;
    for i in range(ni, nf):
        elems += 2*i-1

    # determine number of constrained nodes
    cnodes = int(nf + 2*(nf - ni + 1) - 1)
    
    # the idea area of an average element
    dR = r/(nf-ni+1)

    # time to generate our nodes our nodes
    node_dict = {1: [0.0,0.0]} # x and y coordinates
    node = 1                   # the node we are working on

    # may as well write our first node
    node_dict[node] = [0.0,0.0]
    
    # going to create a dictionary of rings as well
    ring_dict_x = {}
    ring_dict_y = {}

    # now deal with the remaining rings (except the last one)
    ri = 0.0
    for Nn in range(ni,nf+1):
        ri += dR

        # calculate outer positions
        theta = 3.0*np.pi/2.0
        
        # storing these for the dictionary
        x = np.array(np.zeros(Nn))
        y = np.array(np.zeros(Nn))
        for i in range(0,Nn):
            # we are creating a new node
            node += 1
            x[i] = ri*np.cos(theta)
            y[i] = ri*np.sin(theta)
            
            # store node in dictionary
            node_dict[node] = [x[i],y[i]]

            # iterate theta
            theta += np.pi/(Nn-1)
        ring_dict_x[Nn] = x
        ring_dict_y[Nn] = y

    # next up elements
    elem_dict = {}
    elem = 0

    # need to deal with the innermost ring first
    for i in range(2,ni+1):
        elem += 1
        elem_dict[elem] = [1,i,i+1]

    # now to deal with the remaining rings
    Nn = ni
    n1 = 2
    n2 = n1 + 1
    n3 = n1 + Nn
    n4 = n3 + 1
    nl = n1 + Nn - 1
    while n1 <= nodes-nf:
        if n2 <= nl:
            elem += 1
            elem_dict[elem] = [n1,n3,n4]
            elem += 1
            elem_dict[elem] = [n1,n4,n2]
        elif n2 == nl+1:
            elem += 1
            elem_dict[elem] = [n1,n3,n4]
        else:
            Nn += 1
            nl = n1 + Nn -1
            n1 -= 1
            n2 -= 1
        n1 += 1
        n2 += 1
        n3 += 1
        n4 += 1

    # now we can write the actual input file!
    string  = '/ TITLE /\n'
    string += 'CHECK DATA --- CIRCULAR PANEL, SIMPLY SUPPORTED EDGE, UNIFORM PRESSURE\n'
    string += '/ NODES / ELEMENTS / CONSTRAINED NODES / MATERIALS /\n'
    string += '  {:<5}   {:<8}   {:<17}   1\n'.format(int(nodes), int(elems), int(cnodes))
    string += '/ MATERIAL NO. / YOUNG\'S MODULUS / POISSON\'S RATIO /\n'
    string += '  1              {:<1.5e}       {:<1.5e}\n'.format(E, v)

    # nodes
    string += '/ NODE NO. /   X   /   Y   /\n'
    for i in range(1,nodes+1):
        x = node_dict[i][0]
        y = node_dict[i][1]
        if x < 0.0 and y < 0.0:
            string += '  {:>3}  {:<1.5e}  {:<1.5e}\n'.format(i,x,y)
        elif x < 0.0:
            string += '  {:>3}  {:<1.5e}   {:<1.5e}\n'.format(i,x,y)
        elif y < 0.0:
            string += '  {:>3}   {:<1.5e}  {:<1.5e}\n'.format(i,x,y)
        else:
            string += '  {:>3}   {:<1.5e}   {:<1.5e}\n'.format(i,x,y)

    # elems
    string += '/ ELEM. NO. / NODE1 / NODE2 / NODE3 / THICKNESS / MATERIAL NO. / SHEAR FACTOR /\n'
    for i in range(1,elems+1):
        n1 = elem_dict[i][0]
        n2 = elem_dict[i][1]
        n3 = elem_dict[i][2]
        string += '  {:>3}         {:>3}     {:>3}    {:>3}      {:>1.3e}   1              {:>1.6e}\n'.format(i,n1,n2,n3,z,0.83333333)

    # boundary conditions
    string += 'BOUNDARY CONDITION / NODE NO. / CONSTRAINT  /\n'
    string += '                     {:>3}        {:>3}\n'.format(1,'011') # center
    string += '                     {:>3}        {:>3}\n'.format(nodes-nf+1,'110') # corner
    string += '                     {:>3}        {:>3}\n'.format(nodes,'110') # corner
    count = 2
    for i in range(ni, nf):
        string += '                     {:>3}        {:>3}\n'.format(count,'010') # straight edge
        string += '                     {:>3}        {:>3}\n'.format(count+i-1,'010') # straight edge
        count += i
    for i in range(nodes-nf+2,nodes):
        string += '                     {:>3}        {:>3}\n'.format(i,'100') # straight edge

    # forces on nodes
    string += 'FORCES ON NODES / NODE NO. /   FZ   /   MX   /   MY   /\n'
    string += '                 {:>3}          0.0      0.0      0.0\n'.format(nodes)

    # pressure on elements
    string += 'PRESSURE ON ELEMENTS / ELEMENT NO. / PRESSURE /\n'
    for i in range(1,elems+1):
        string += '                       {:>3}           {:<1.2e}\n'.format(i,p)

    print(string)
    
    if args['--plot']:
        print(elem_dict)
        for i in range(1,elems+1):
            en = elem_dict[i]
            nx = [node_dict[en[0]][0],node_dict[en[1]][0],node_dict[en[2]][0],node_dict[en[0]][0]]
            ny = [node_dict[en[0]][1],node_dict[en[1]][1],node_dict[en[2]][1],node_dict[en[0]][1]]
            mpl.plot(nx,ny)
        for i in range(1,nodes+1):
            mpl.text(node_dict[i][0], node_dict[i][1], '%i' % i)
        mpl.xlim(-r,r)
        mpl.ylim(-r,r)
        mpl.show()

# ----------------------------------------------------------------------
if __name__ == "__main__": 
    main()
