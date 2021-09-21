#!/bin/sh
TIMESTAMP=$(date -Iseconds)

julia run.jl "cell_lists" --ns "[20000]" -d 2 -r 0.01 -i 1 -s 10.0 --dir "output/cell_lists_float64_$TIMESTAMP"

julia run.jl "cell_lists" --ns "[20000]" -d 2 -r 0.01 -i 1 -s 10.0 --dir "output/cell_lists_float32_$TIMESTAMP" --float32
