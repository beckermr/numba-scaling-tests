#!/bin/bash

echo $CONDA_EXE
source activate bnl

echo `which python`

mpirun -n 1 python -m cProfile -s cumtime ../numba-test-script 1 >& data1_bnl.txt
mpirun -n 2 python -m cProfile -s cumtime ../numba-test-script 1 >& data2_bnl.txt

for nc in 1 2 4 8
do
    mpirun -n ${nc} python -m cProfile -s cumtime ../numba-test-script 1 >& data${nc}_bnl.txt
done

# turn off numba

export NUMBA_DISABLE_JIT=1

mpirun -n 1 python -m cProfile -s cumtime ../numba-test-script 1 >& data1_bnl_nn.txt
mpirun -n 2 python -m cProfile -s cumtime ../numba-test-script 1 >& data2_bnl_nn.txt

for nc in 1 2 4 8
do
    mpirun -n ${nc} python -m cProfile -s cumtime ../numba-test-script 1 >& data${nc}_bnl_nn.txt
done
