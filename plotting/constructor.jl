using JLD
using BenchmarkTools
using Dates
using Base.Sys
using CellListsBenchmarks
using Plots

gettime(x) = getfield(x, :time)
gettime_nogc(x) = getfield(x, :time) - getfield(x, :gctime)

filepath_serial = "output/cell_list_constructor_serial_2021-04-09T08:28:43+0300/n1000-d2-r0.1.jld"
filepath_parallel = "output/cell_list_constructor_parallel_2021-04-09T08:28:47+0300/n1000-d2-r0.1.jld"

ls = load(filepath_serial)["benchmarks"]
lp = load(filepath_parallel)["benchmarks"]

d = getfield(ls[1], :d)
r = getfield(ls[1], :r)
ns = getfield.(ls, :n)
ts = getfield.(ls, :trials)
tp = getfield.(lp, :trials)

ms = [median.(t) for t in ts]
mp = [median.(t) for t in tp]

means = [mean(gettime.(v)) for v in ms]
meanp = [mean(gettime.(v)) for v in mp]

p1 = plot(legend=:topleft)
plot!(p1, ns, means, markershape=:circle, markersize=2, linestyle=:dash, label="serial")
plot!(p1, ns, meanp, markershape=:circle, markersize=2, linestyle=:dash, label="parallel")

p2 = plot(legend=:bottomright)
plot!(p2, ns, means./meanp, markershape=:circle, markersize=2, linestyle=:dash, label="serial/parallel")

directory = joinpath("figures", "constructor")
if !isdir(directory)
    mkpath(directory)
end

savefig(p1, joinpath(directory, "d$d-r$r-n$(ns[end]).svg"))
savefig(p2, joinpath(directory, "d$d-r$r-n$(ns[end])-ratio.svg"))
