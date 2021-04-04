#!/bin/sh
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=1000
#SBATCH --ouput=output/brute_force_serial_%j
module load julia
srun julia run.jl --ns "[1, 5, 10:10:100...]" -d 2 -r 0.01 -i 1 --dir "output/brute_force_serial_%j" --algorithm "brute_force"
srun julia run.jl --ns "[1, 5, 10:10:100...]" -d 3 -r 0.01 -i 1 --dir "output/brute_force_serial_%j" --algorithm "brute_force"
srun julia run.jl --ns "[1, 5, 10:10:200...]" -d 4 -r 0.01 -i 1 --dir "output/brute_force_serial_%j" --algorithm "brute_force"
srun julia run.jl --ns "[1, 5, 10:10:300...]" -d 5 -r 0.01 -i 1 --dir "output/brute_force_serial_%j" --algorithm "brute_force"
