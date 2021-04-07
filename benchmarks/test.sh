#!/bin/sh
TIMESTAMP=$(date -Iseconds)

julia run.jl --ns "[100]" -d 2 -r 0.01 -i 1 --dir "output/brute_force_$TIMESTAMP" --benchmark "brute_force"

julia run.jl --ns "[100]" -d 2 -r 0.01 -i 1 --dir "output/cell_lists_$TIMESTAMP" --benchmark "cell_lists"

julia run.jl --ns "[100]" -d 2 -r 0.1 -i 1 --dir "output/cell_list_constructor_serial_$(date -Iseconds)" --benchmark "cell_list_serial"

julia -t 2 run.jl --ns "[100]" -d 2 -r 0.1 -i 1 --dir "output/cell_list_constructor_parallel_$(date -Iseconds)" --benchmark "cell_list_parallel"

julia run.jl --ns "[100]" -d 2 -r 0.01 -i 1 --dir "output/near_neighbors_serial_$(date -Iseconds)" --benchmark "near_neighbors_serial"

julia -t 4 run.jl --ns "[100]" -d 2 -r 0.01 -i 1 --dir "output/near_neighbors_parallel_$(date -Iseconds)" --benchmark "near_neighbors_parallel"
