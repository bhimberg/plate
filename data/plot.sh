#! /usr/bin/env sh
mplot_scalar.py -p poisson -ew fem-vv.dat -td ana-vv.dat --title "Deflection Error from Poisson's Ratio" --savefig nu_scaling_err.pdf
mplot_scalar.py -p thick -ew fem-vt.dat -td ana-vt.dat --title 'Deflection Error from Thickness' --savefig tr_scaling_err.pdf
