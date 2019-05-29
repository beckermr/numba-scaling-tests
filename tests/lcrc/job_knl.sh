#!/bin/bash
#SBATCH -J run-test
#SBATCH -A metashear
#SBATCH --partition=knlall
#SBATCH --constraint knl,quad,cache
#SBATCH -N 1
#SBATCH -o myjob_knl.oe
#SBATCH -t 02:00:00

module load intel-parallel-studio
export I_MPI_FABRICS=shm:ofi

echo $CONDA_EXE
source activate lcrc

echo `which python`

srun -n 1 python -m cProfile -s cumtime ../numba-test-script 1 >& data1_knl.txt
srun -n 2 python -m cProfile -s cumtime ../numba-test-script 1 >& data2_knl.txt

for nc in `seq 1 64`
do
    srun -n ${nc} python -m cProfile -s cumtime ../numba-test-script 1 >& data${nc}_knl.txt
done
