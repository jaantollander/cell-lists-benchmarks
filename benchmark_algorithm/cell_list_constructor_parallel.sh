#!/bin/sh
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=1000
#SBATCH --ouput=output/cell_list_constructor_parallel_%j
module load julia
srun julia -t 2 run.jl --ns "[1, 10, 25, 35, 50, 75, 100:50:1000...]" -d 2 -r 0.1 -i 1 --dir "output/cell_list_constructor_parallel_%j" --algorithm "cell_list_parallel"
