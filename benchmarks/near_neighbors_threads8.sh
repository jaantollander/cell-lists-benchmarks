#!/bin/sh
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=1500
#SBATCH --output=output/near_neighbors_threads8_%j.out
module load julia
srun julia -t 8 run.jl "near_neighbors_threads" --ns "[20000]" -d 2 -r 0.01 -i 100 -s 5.0 --dir "output/near_neighbors_threads8_$(date -Iseconds)"
