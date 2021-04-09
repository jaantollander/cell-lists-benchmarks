using JLD
using BenchmarkTools
using Dates
using Plots

gettime(x) = getfield(x, :time)
gettime_nogc(x) = getfield(x, :time) - getfield(x, :gctime)

files = [
    "n100-d2-r0.01.jld",
    "n100-d3-r0.01.jld",
    "n200-d4-r0.01.jld",
    "n300-d5-r0.01.jld"
]
dir_cell_lists = "output/cell_lists_2021-04-09T08:28:29+0300/"

function foo(file)
    lc = load(joinpath(dir_cell_lists, file))["benchmarks"]
    d = getfield(lc[1], :d)
    r = getfield(lc[1], :r)
    ns = getfield.(lc, :n)
    tc = getfield.(lc, :trials)
    mc = [median.(t) for t in tc]
    meanc = [mean(gettime.(v)) for v in mc]
    return ns, meanc, d, r
end

vs = [foo(file) for file in files]
ns, y, d, r = vs[1]

p1 = plot(legend=:topleft)
m = ns .≤ 100
plot!(p1, ns[m], y[m], markershape=:circle, markersize=2, linestyle=:dash, label="d=$d")
for (ns2, y2, d2, r2) in vs[2:end]
    m2 = ns2 .≤ 100
    plot!(p1, ns2[m2], y2[m2], markershape=:circle, markersize=2, linestyle=:dash, label="d=$d2")
end

p2 = plot(legend=:topleft)
m = ns .≤ 100
plot!(p2, ns[m], y[m]./y[m], markershape=:circle, markersize=2, linestyle=:dash, label="d=$d")
for (ns2, y2, d2, r2) in vs[2:end]
    m2 = ns2 .≤ 100
    plot!(p2, ns2[m2], y2[m2]./y[m], markershape=:circle, markersize=2, linestyle=:dash, label="d=$d2")
end

directory = joinpath("figures", "dimensionality")
if !isdir(directory)
    mkpath(directory)
end

savefig(p1, joinpath(directory, "absolute.svg"))
savefig(p2, joinpath(directory, "ratio.svg"))
