# Cell Lists Benchmarks
Scripts for running [CellListsBenchmarks.jl](https://github.com/jaantollander/CellListsBenchmarks.jl) from the command line and plotting the results.

The [`benchmarks/run.jl`](./benchmarks/run.jl) file contains the script to run benchmarks from the command line. We can test the commands locally with [`benchmarks/test.sh`](./benchmarks/test.sh). The test script also demonstrates how to use the commands.


## Usage on Aalto Triton Cluster
First, lets connect to [Aalto VPN](https://scicomp.aalto.fi/aalto/remoteaccess/#vpn-web-proxy).

```bash
sudo openconnect https://vpn.aalto.fi
```

Then, we can connect to Triton using SSH.

```bash
ssh USERNAME@triton.aalto.fi
```

Let's navigate to the work directory and clone the repository.

```bash
cd $WRKDIR
git clone https://github.com/jaantollander/cell-lists-benchmarks.git
```

Then, we can navigate the repository directory and load the Julia module.

```bash
cd cell-lists-benchmarks
module load julia
```

We need to install `CellLists.jl` and `CellListsBenchmarks.jl` manually from GitHub and then activate the environment to install other dependencies from `Project.toml`. Open the Julia REPL by typing `julia` the command line.

```julia-repl
julia> ]
pkg> add https://github.com/jaantollander/CellLists.jl
pkg> add https://github.com/jaantollander/CellListsBenchmarks.jl
pkg> add ArgParse Dates Random JLD
```

We should start by changing our working directory to `benchmarks` and create the `output` directory.

```bash
cd benchmarks
mkdir output
```

Then, we can submit a batch jobs to the Slurm scheduler with the `sbatch` command.

```bash
sbatch brute_force.sh
sbatch cell_lists.sh
sbatch cell_list_constructor_serial.sh
sbatch cell_list_constructor_parallel.sh
sbatch near_neighbors_serial.sh
sbatch near_neighbors_parallel.sh
```

We can access the benchmark data on Triton by remote mount the work directory to our local computer. We can [remote mount](https://scicomp.aalto.fi/triton/tut/storage/#remote-mounting-using-sshfs) our work directory using `sshfs`.

```bash
mkdir ~/triton_work
sshfs USERNAME@triton.aalto.fi:/scratch/work/USERNAME ~/triton_work
```
