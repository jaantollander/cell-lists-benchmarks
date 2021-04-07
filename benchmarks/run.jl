using Base.Sys: cpu_info
using Base.Threads
using ArgParse
using Dates
using JLD
using Random
using CellListsBenchmarks

@info cpu_info()

const benchmark_functions = Dict(
    "cell_list_serial" => benchmark_cell_list_serial,
    "cell_list_parallel" => benchmark_cell_list_parallel,
    "brute_force" => benchmark_brute_force,
    "cell_lists" => benchmark_cell_lists,
    "near_neighbors_serial" => benchmark_near_neighbors_serial,
    "near_neighbors_parallel" => benchmark_near_neighbors_parallel,
)

# --- Arguments ---
s = ArgParseSettings()
@add_arg_table s begin
    "--ns"
        help = "String that is evaluates to `Vector{Int}` type."
        default = "[1, 10, 100]"
        arg_type = String
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
        default = 1.0
        arg_type = Float64
    "--benchmark"
        help = "Choose one of : $(keys(benchmark_functions))"
        arg_type = String
        required = true
    "--dir"
        default = "output"
        arg_type = AbstractString
end
args = parse_args(s)


# --- Parameters ---
d = args["d"]
r = args["r"]
ns = Vector{Int}(eval(Meta.parse(args["ns"])))
length(ns) < 1 && throw(DomainError(""))
seed = args["seed"]
iterations = args["iterations"]
seconds = args["seconds"]
directory = args["dir"]
benchmark = args["benchmark"]


# --- Trials ---
b = benchmark_functions[benchmark]
trials = Dict(
    n => run_benchmark(b, n, d, r, seed, iterations, seconds) for n in ns
)


# --- IO ---
if !ispath(directory)
    mkpath(directory)
end

filepath = joinpath(directory, "n$(ns[end])-d$(d)-r$(r).jld")
@info "Saving results to $(filepath)"
JLD.save(
    filepath,
    "ns", ns, "d", d, "r", r, "nthreads", nthreads(),
    "seed", seed, "iterations", iterations,
    "trials", trials, "timestamp", now(), "cpu_info", cpu_info()
)
