#!/bin/bash

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod u+x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b -p /scratch/miniconda3

/scratch/miniconda3/bin/conda create -n test python=3.6 numba numpy -y

source activate /scratch/miniconda3/envs/test

echo `which python`
echo `which pip`

pip install mpi4py --no-deps --force-reinstall --no-cache-dir

pth=`pwd`
cd ../..

pip install -e .

cd $pth

export I_MPI_FABRICS=shm:ofi

srun -n 1 python -m cProfile -s cumtime ../numba-test-script 1 >& data1_cpu.txt
srun -n 2 python -m cProfile -s cumtime ../numba-test-script 1 >& data2_cpu.txt

for nc in 1 2 4 8 16 32
do
    srun -n ${nc} python -m cProfile -s cumtime ../numba-test-script 1 >& data${nc}_cpu.txt
done

# turn off numba

export NUMBA_DISABLE_JIT=1

srun -n 1 python -m cProfile -s cumtime ../numba-test-script 1 >& data1_cpu_nn.txt
srun  -n 2 python -m cProfile -s cumtime ../numba-test-script 1 >& data2_cpu_nn.txt

for nc in 1 2 4 8 16 32
do
    srun -n ${nc} python -m cProfile -s cumtime ../numba-test-script 1 >& data${nc}_cpu_nn.txt
done
