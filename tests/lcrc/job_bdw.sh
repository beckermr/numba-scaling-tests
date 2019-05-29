#!/bin/bash
#SBATCH -J run-test
#SBATCH -A metashear
#SBATCH -p bdwall
#SBATCH -N 1
#SBATCH -o myjob_bdw.oe
#SBATCH -t 01:00:00

module load intel-parallel-studio
export I_MPI_FABRICS=shm:ofi

echo $CONDA_EXE
source activate lcrc

echo `which python`

srun -n 1 python -m cProfile -s cumtime ../numba-test-script 1 >& data1_bdw.txt
srun -n 2 python -m cProfile -s cumtime ../numba-test-script 1 >& data2_bdw.txt

for nc in `seq 1 36`
do
    srun -n ${nc} python -m cProfile -s cumtime ../numba-test-script 1 >& data${nc}_bdw.txt
done

# turn off numba

export NUMBA_DISABLE_JIT=0

srun -n 1 python -m cProfile -s cumtime ../numba-test-script 1 >& data1_bdw_nn.txt
srun -n 2 python -m cProfile -s cumtime ../numba-test-script 1 >& data2_bdw_nn.txt

for nc in `seq 1 36`
do
    srun -n ${nc} python -m cProfile -s cumtime ../numba-test-script 1 >& data${nc}_bdw_nn.txt
done
