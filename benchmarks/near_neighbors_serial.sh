#!/bin/sh
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=1000
#SBATCH --output=output/near_neighbors_serial_%j.out
module load julia
srun julia run.jl "near_neighbors_serial" --ns "[20000]" -d 2 -r 0.01 -i 100 --dir "output/near_neighbors_serial_$(date -Iseconds)" --seconds 7.0
