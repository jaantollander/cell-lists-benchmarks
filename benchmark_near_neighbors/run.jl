using Base.Sys: cpu_info
using Base.Threads
using ArgParse
using Dates
using JLD
using Random
using CellLists
using CellListsBenchmarks

@info cpu_info()


# --- Arguments ---
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
    "--parallel"
        action = :store_true
    "--dir"
        default = "output"
        arg_type = AbstractString
end
args = parse_args(s)


# --- Parameters ---
n = args["n"]
d = args["d"]
r = args["r"]
seed = args["seed"]
iterations = args["iterations"]
seconds = args["seconds"]
parallel = args["parallel"]
directory = args["dir"]


# --- Trials ---
f = if parallel p_near_neighbors else near_neighbors end
trials = benchmark_near_neighbors(f, n, d, r, seed, iterations, seconds)


# --- IO ---
if !isdir(directory)
    mkpath(directory)
end

filepath = joinpath(directory, "n$(n)-d$(d)-r$(r)-nthreads$(nthreads()).jld")
@info "Saving results to $(filepath)"
JLD.save(
    filepath,
    "n", n, "d", d, "r", r, "nthreads", nthreads(),
    "seed", seed, "iterations", iterations, "parallel", parallel,
    "trials", trials, "timestamp", now()
)
