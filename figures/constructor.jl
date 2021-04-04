using JLD
using BenchmarkTools
using Dates
using Plots

filepath_serial = "/home/jaan/Triton/cell-lists-benchmarks/benchmark_algorithm/output/cell_list_constructor_serial_2021-04-04T13:27:39+0300/n1000-d2-r0.1.jld"
filepath_parallel = "/home/jaan/Triton/cell-lists-benchmarks/benchmark_algorithm/output/cell_list_constructor_parallel_2021-04-04T13:27:40+0300/n1000-d2-r0.1.jld"

ls = load(filepath_serial)
lp = load(filepath_parallel)
d, r, ns = ls["d"], ls["r"], ls["ns"]
ts = ls["trials"]
tp = lp["trials"]

ms = [median.(ts[n]) for n in ns]
mp = [median.(tp[n]) for n in ns]

gettime(x) = getfield(x, :time)
gettime_nogc(x) = getfield(x, :time) - getfield(x, :gctime)

means = [mean(gettime.(v)) for v in ms]
meanp = [mean(gettime.(v)) for v in mp]

p1 = plot(legend=false)
plot!(p1, ns, means, markershape=:circle, markersize=1, linestyle=:dash)
plot!(p1, ns, meanp, markershape=:circle, markersize=1, linestyle=:dash)

p2 = plot(legend=false)
plot!(p2, ns, means./meanp, markershape=:circle, markersize=1, linestyle=:dash)

directory = joinpath("output", "constructor")
if !isdir(directory)
    mkpath(directory)
end

savefig(p1, joinpath(directory, "d$d-r$r-n$(ns[end]).svg"))
savefig(p2, joinpath(directory, "d$d-r$r-n$(ns[end])-ratio.svg"))
