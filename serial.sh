#!/bin/sh
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=1000
module load julia
srun julia benchmark.jl -n 20000 -d 2 -r 0.01 -i 1
