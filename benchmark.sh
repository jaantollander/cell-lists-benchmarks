#!/bin/sh
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=1000
module load julia
srun julia -t 4 benchmark.jl --dir $WRKDIR -i 100
