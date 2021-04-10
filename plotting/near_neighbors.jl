using JLD
using BenchmarkTools
using Dates
using Base.Sys
using CellListsBenchmarks
using Plots

gettime(x) = getfield(x, :time)
gettime_nogc(x) = getfield(x, :time) - getfield(x, :gctime)

filepath_serial = "output/near_neighbors_serial_2021-04-05T11:47:02+0300/n20000-d2-r0.01-nthreads1.jld"
filepath_parallel = "output/near_neighbors_parallel_2021-04-05T11:47:16+0300/n20000-d2-r0.01-nthreads4.jld"

ls = load(filepath_serial)["benchmarks"]
lp = load(filepath_parallel)["benchmarks"]

d = getfield(ls[1], :d)
r = getfield(ls[1], :r)
n = getfield(ls[1], :n)
ts = getfield(ls[1], :trials)
tp = getfield(lp[1], :trials)

ms = gettime_nogc.(median.(ts))
mp = gettime_nogc.(median.(tp))

p1 = plot(legend=false)
bar!(p1, ms, alpha=0.5)
bar!(p1, mp, alpha=0.5)

rt = ms ./ mp
p2 = scatter(rt, legend=false)
plot!(p2, 1:length(rt), fill(mean(rt), length(rt)))

directory = joinpath("figures", "near_neighbors")
if !isdir(directory)
    mkpath(directory)
end

savefig(p1, joinpath(directory, "d$d-r$r-n$n.svg"))
savefig(p2, joinpath(directory, "d$d-r$r-n$n-ratio.svg"))
