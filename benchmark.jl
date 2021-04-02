using Pkg
Pkg.activate(pwd())
using CellListsBenchmarks
using Base.Threads
using ArgParse
using Dates
using JLD
using Random

s = ArgParseSettings()
@add_arg_table s begin
    "-n"
        default = 20000
        arg_type = Int
    "-d"
        default = 2
        arg_type = Int
    "-r"
        default = 0.01
        arg_type = Float64
    "--seed"
        default = 1
        arg_type = Int
    "--iterations", "-i"
        default = 1
        arg_type = Int
    "--seconds", "-s"
        default = 5.0
        arg_type = Float64
    "--dir"
        default = pwd()
        arg_type = AbstractString
end
args = parse_args(s)

# Parameters
seed = args["seed"]
iterations = args["iterations"]
seconds = args["seconds"]
n = args["n"]
d = args["d"]
r = args["r"]

rng = MersenneTwister(seed)
ts, tp = benchmark_parallel_near_neighbors(rng, n, d, r, iterations, seconds)

# --- IO ---
directory = joinpath(
    args["dir"],
    "output",
    string(now()),
    "parallel_near_neighbors"
)
if !ispath(directory)
    mkpath(directory)
end

filepath = joinpath(
    directory,
    "n$(n)-d$(d)-r$(r)-nthreads$(nthreads()).jld"
)
@info "Saving results to $(filepath)"
JLD.save(
    filepath,
    "n", n, "d", d, "r", r, "nthreads", nthreads(),
    "seed", seed, "iterations", iterations,
    "ts", ts, "tp", tp
)
