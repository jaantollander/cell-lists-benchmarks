#!/bin/sh
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=1000
#SBATCH --output=output/cell_list_constructor_threads2_%j.out
module load julia
srun julia -t 2 run.jl "cell_list_threads" --ns "[1, 10, 25, 35, 50, 75, 100:50:1000...]" -d 2 -r 0.1 -i 1 -s 1.0 --dir "output/cell_list_constructor_threads2_$(date -Iseconds)"
