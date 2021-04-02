Scripts for running `CellListsBenchmarks.jl` on Aalto Triton.

---

First, load the Julia module.

```bash
module load julia
```

We need to install `CellLists.jl` and `CellListsBenchmarks.jl` manually from GitHub and then activate the environment to install other dependencies from `Project.toml`.

```julia-repl
pkg> add https://github.com/jaantollander/CellLists.jl
pkg> add https://github.com/jaantollander/CellListsBenchmarks.jl
pkg> add ArgParse Dates Random JLD
```

---

We can test the `benchmark.jl` script with the commands:

```bash
julia -t 4 benchmark.jl -n 2000 -d 2 -r 0.1 -i 2
```

---

We can submit a batch job with commands:

```bash
sbatch serial.sh
sbatch parallel.sh
```

---

Easiest way to access the benchmark data on Triton is to remote mount the work directory to our local computer. First, lets use `openconnect` to connect to [Aalto VPN](https://scicomp.aalto.fi/aalto/remoteaccess/#vpn-web-proxy)

```bash
sudo openconnect https://vpn.aalto.fi
```

Then, we can [remote mount](https://scicomp.aalto.fi/triton/tut/storage/#remote-mounting-using-sshfs) our work directory using `sshfs`.

```bash
mkdir triton_work
sshfs USERNAME@triton.aalto.fi:/scratch/work/USERNAME triton_work
```
