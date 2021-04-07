#!/bin/sh
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=1500
#SBATCH --output=output/near_neighbors_parallel_%j.out
module load julia
srun julia -t 4 run.jl --ns "[20000]" -d 2 -r 0.01 -i 100 --dir "output/near_neighbors_parallel_$(date -Iseconds)" --benchmark "near_neighbors_parallel"
