#!/bin/bash
#COBALT -t 30
#COBALT -n 1
#COBALT -q debug-cache-quad
#COBALT --attrs mcdram=cache:numa=quad
#COBALT -A darkskyml_aesp

module load miniconda-3.6/conda-4.5.12
unset PYTHONPATH

source activate theta

aprun -n 1 -N 1 python ../numba-test-script 1
