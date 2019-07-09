#!/usr/bin/env bash

mpirun -n 1 python -m cProfile -s cumtime ../numba-test-script 1 >& data1_cpu.txt
mpirun -n 2 python -m cProfile -s cumtime ../numba-test-script 1 >& data2_cpu.txt

for nc in 1 2
do
    mpirun -n ${nc} python -m cProfile -s cumtime ../numba-test-script 1 >& data${nc}_cpu.txt
done

# turn off numba

export NUMBA_DISABLE_JIT=1

mpirun -n 1 python -m cProfile -s cumtime ../numba-test-script 1 >& data1_cpu_nn.txt
mpirun  -n 2 python -m cProfile -s cumtime ../numba-test-script 1 >& data2_cpu_nn.txt

for nc in 1 2
do
    mpirun -n ${nc} python -m cProfile -s cumtime ../numba-test-script 1 >& data${nc}_cpu_nn.txt
done
