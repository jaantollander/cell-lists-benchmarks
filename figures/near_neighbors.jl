using JLD
using BenchmarkTools
using Plots

filepath_serial = "/home/jaan/Triton/cell-lists-benchmarks/output/2021-04-02T12:44:52.387/near_neighbors/n20000-d2-r0.01-nthreads1.jld"
filepath_parallel = "/home/jaan/Triton/cell-lists-benchmarks/output/2021-04-02T12:44:54.636/near_neighbors/n20000-d2-r0.01-nthreads4.jld"

ls = load(filepath_serial)
lp = load(filepath_parallel)
d, r, n = ls["d"], ls["r"], ls["n"]
ts = ls["trials"]
tp = lp["trials"]

gettime(x) = getfield(x, :time)
gettime_nogc(x) = getfield(x, :time) - getfield(x, :gctime)
ms = median.(ts)
mp = median.(tp)

p1 = plot(legend=false)
bar!(p1, gettime.(ms), alpha=0.5)
bar!(p1, gettime.(mp), alpha=0.5)

rt = gettime_nogc.(ms) ./ gettime_nogc.(mp)
p2 = scatter(rt, legend=false)
plot!(p2, 1:length(rt), fill(mean(rt), length(rt)))

directory = joinpath("output", "near_neighbors")
if !isdir(directory)
    mkpath(directory)
end

savefig(p1, joinpath(directory, "d$d-r$r-n$n.svg"))
savefig(p2, joinpath(directory, "d$d-r$r-n$n-ratio.svg"))
