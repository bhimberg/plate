#! /usr/bin/env sh
mplot_scalar.py -p poisson -ew fem-vv.dat -td ana-vv.dat --title "Deflection Error from Poisson's Ratio" --savefig nu_scaling_err.pdf
mplot_scalar.py -p thick -ew fem-vt.dat -td ana-vt.dat --title 'Deflection Error from Spatial Parameters' --savefig tr_scaling_err.pdf
mplot_scalar.py -p young -ew fem-vy.dat -td ana-vy.dat --title "Deflection Error from Young's Modulus" --savefig ym_scaling_err.pdf
mplot_scalar.py -p pressure -ew fem-vp.dat -td ana-vp.dat --title 'Deflection Error from Pressure' --savefig yp_scaling_err.pdf --rtitle
mplot_scalar.py -p elems -ew fem-ve.dat -td ana-ve.dat --title 'Deflection Error from Element Count' --savefig ve_scaling_err.pdf
mplot_scalar.py -p elems -ew -tp fem-ve.dat --title 'Finite Element Scaling for Deflection' --savefig ve_scaling.pdf
