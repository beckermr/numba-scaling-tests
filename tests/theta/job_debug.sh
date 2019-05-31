#!/bin/bash
#COBALT -t 60
#COBALT -n 1
#COBALT -q debug-cache-quad
#COBALT --attrs mcdram=cache:numa=quad
#COBALT -A darkskyml_aesp
#COBALT --debuglog myjob.oe
#COBALT --output myjob.oe
#COBALT --error myjob.oe

module load miniconda-3.6/conda-4.5.12
unset PYTHONPATH

source activate theta

aprun -n 1 -N 1 python -m cProfile -s cumtime ../numba-test-script 1 >& data1_knl.txt
aprun -n 1 -N 2 python -m cProfile -s cumtime ../numba-test-script 1 >& data2_knl.txt

for nc in 1 2 4 8 16 32 64
do
    aprun -n 1 -N ${nc} python -m cProfile -s cumtime ../numba-test-script 1 >& data${nc}_knl.txt
done
