#!/bin/sh
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=1000
#SBATCH --output=output/cell_lists_%j.out
TIMESTAMP=$(date -Iseconds)
module load julia
srun julia run.jl --ns "[1, 5, 10:10:100...]" -d 2 -r 0.01 -i 10 --dir "output/cell_lists_$TIMESTAMP" --benchmark "cell_lists"
srun julia run.jl --ns "[1, 5, 10:10:100...]" -d 3 -r 0.01 -i 10 --dir "output/cell_lists_$TIMESTAMP" --benchmark "cell_lists"
srun julia run.jl --ns "[1, 5, 10:10:200...]" -d 4 -r 0.01 -i 10 --dir "output/cell_lists_$TIMESTAMP" --benchmark "cell_lists"
srun julia run.jl --ns "[1, 5, 10:10:300...]" -d 5 -r 0.01 -i 10 --dir "output/cell_lists_$TIMESTAMP" --benchmark "cell_lists"