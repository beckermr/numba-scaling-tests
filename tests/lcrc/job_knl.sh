#!/bin/bash
#SBATCH -J run-test
#SBATCH -A mtashear
#SBATCH --partition=knlall
#SBATCH --constraint knl,quad,cache
#SBATCH -N 1
#SBATCH -o myjob.oe
#SBATCH -t 00:10:00

module load intel-parallel-studio
export I_MPI_FABRICS=shm:ofi

echo $CONDA_EXE
source activate lcrc

echo `which python`

srun -n 1 python -m cProfile -s cumtime ../numba-test-script 1 >& data1.txt
srun -n 2 python -m cProfile -s cumtime ../numba-test-script 1 >& data2.txt
