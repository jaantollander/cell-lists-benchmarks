Scripts for running `CellListsBenchmarks.jl` on Aalto Triton.

---

We need to install `CellLists.jl` and `CellListsBenchmarks.jl` manually from GitHub and then activate the environment to install other dependencies from `Project.toml`.

```julia-repl
pkg> add https://github.com/jaantollander/CellLists.jl
pkg> add https://github.com/jaantollander/CellListsBenchmarks.jl
pkg> activate .
```

---

We can test the `benchmark.jl` script with the commands:

```bash
module load julia
julia -t 4 benchmark.jl -n 2000 -d 2 -r 0.1
```

---

We can submit a batch job with commands:

```bash
sbatch benchmark.sh
```
