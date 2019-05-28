#!/usr/bin/env bash

mpirun -n 1 python -m cProfile -s cumtime ../numba-test-script 1 >& data1.txt
mpirun -n 2 python -m cProfile -s cumtime ../numba-test-script 1 >& data2.txt
