using Base.Sys: cpu_info
using Base.Threads
using ArgParse
using Dates
using JLD
using Random
using CellListsBenchmarks


# --- Arguments ---
s = ArgParseSettings()
@add_arg_table s begin
    "benchmark"
        help = "Choose one of : $(keys(benchmark_functions))"
        arg_type = String
        required = true
    "--ns"
        help = "String that is evaluates to `Vector{Int}` type. For example: [1, 10, 100:50:200...]"
        arg_type = String
        required = true
    "-d"
        help = "Dimension. Positive integer."
        arg_type = Int
        required = true
    "-r"
        help = "Radius. Positive float."
        arg_type = Float64
        required = true
    "--seed"
        default = 1
        arg_type = Int
    "--iterations", "-i"
        default = 1
        arg_type = Int
    "--seconds", "-s"
        default = 1.0
        arg_type = Float64
    "--dir"
        default = "output"
        arg_type = AbstractString
end
args = parse_args(s)


# --- Parameters ---
d = args["d"]
r = args["r"]
ns = Vector{Int}(eval(Meta.parse(args["ns"])))
seed = args["seed"]
iterations = args["iterations"]
seconds = args["seconds"]
directory = args["dir"]
benchmark = args["benchmark"]


# --- Validate parameters ---
length(ns) < 1 && throw(DomainError(""))
d < 1 && throw(DomainError(""))
r ≤ 0 && throw(DomainError(""))


# --- Trials ---
function cpus()
    dict = Dict{String, Int}()
    for cpu in cpu_info()
        if haskey(dict, cpu.model)
            dict[cpu.model] += 1
        else
            dict[cpu.model] = 1
        end
    end
    return dict
end

@info "Julia version: $VERSION"
for (model, num) in cpus()
    @info "$(num) × $(model)"
end


benchmarks = [Benchmark(benchmark, n, d, r, seed, iterations, seconds) for n in ns]


# --- IO ---
if !ispath(directory)
    mkpath(directory)
end

filepath = joinpath(directory, "n$(ns[end])-d$(d)-r$(r).jld")
@info "Saving results to $(filepath)"
JLD.save(filepath, "benchmarks", benchmarks)
