#!/bin/sh
TIMESTAMP=$(date -Iseconds)

julia run.jl "brute_force" --ns "[100]" -d 2 -r 0.01 -i 1 -s 1.0 --dir "output/brute_force_$TIMESTAMP"

julia run.jl "cell_lists" --ns "[100]" -d 2 -r 0.01 -i 1 -s 1.0 --dir "output/cell_lists_$TIMESTAMP"

julia run.jl "cell_list_serial" --ns "[100]" -d 2 -r 0.1 -i 1 -s 1.0 --dir "output/cell_list_constructor_serial_$(date -Iseconds)"

julia -t 2 run.jl "cell_list_parallel" --ns "[100]" -d 2 -r 0.1 -i 1 -s 1.0 --dir "output/cell_list_constructor_parallel_$(date -Iseconds)"

julia run.jl "near_neighbors_serial" --ns "[100]" -d 2 -r 0.01 -i 1 -s 1.0 --dir "output/near_neighbors_serial_$(date -Iseconds)"

julia -t 4 run.jl "near_neighbors_parallel" --ns "[100]" -d 2 -r 0.01 -i 1 -s 1.0 --dir "output/near_neighbors_parallel_$(date -Iseconds)"
