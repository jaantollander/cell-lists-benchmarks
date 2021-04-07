#!/bin/sh
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=1000
#SBATCH --output=output/cell_list_constructor_serial_%j.out
module load julia
srun julia run.jl --ns "[1, 10, 25, 35, 50, 75, 100:50:1000...]" -d 2 -r 0.1 -i 1 --dir "output/cell_list_constructor_serial_$(date -Iseconds)" --benchmark "cell_list_serial"
