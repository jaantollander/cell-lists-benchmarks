using JLD
using BenchmarkTools
using Dates
using Plots

gettime(x) = getfield(x, :time)
gettime_nogc(x) = getfield(x, :time) - getfield(x, :gctime)

filepath_serial = "output/near_neighbors/n20000-d2-r0.01-nthreads1.jld"
filepath_parallel = "output/near_neighbors/n20000-d2-r0.01-nthreads4.jld"

ls = load(filepath_serial)
lp = load(filepath_parallel)
d, r, n = ls["d"], ls["r"], ls["n"]
ts = ls["trials"]
tp = lp["trials"]

ms = median.(ts)
mp = median.(tp)

p1 = plot(legend=false)
bar!(p1, gettime.(ms), alpha=0.5)
bar!(p1, gettime.(mp), alpha=0.5)

rt = gettime_nogc.(ms) ./ gettime_nogc.(mp)
p2 = scatter(rt, legend=false)
plot!(p2, 1:length(rt), fill(mean(rt), length(rt)))

directory = joinpath("figures", "near_neighbors")
if !isdir(directory)
    mkpath(directory)
end

savefig(p1, joinpath(directory, "d$d-r$r-n$n.svg"))
savefig(p2, joinpath(directory, "d$d-r$r-n$n-ratio.svg"))
