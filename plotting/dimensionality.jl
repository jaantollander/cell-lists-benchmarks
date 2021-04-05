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
dir_cell_lists = "output/cell_lists_serial_2021-04-04T13:48:33+0300/"

function foo(file)
    lc = load(joinpath(dir_cell_lists, file))
    d, r, ns = lc["d"], lc["r"], lc["ns"]
    tc = lc["trials"]
    ns2 = collect(filter(x -> x≤100, ns))
    mc = [median.(tc[n]) for n in ns2]
    meanc = [mean(gettime.(v)) for v in mc]
    return ns2, meanc, d, r
end

vs = [foo(file) for file in files]
ns, y, d, r = vs[1]

p1 = plot(legend=false)
plot!(p1, ns, y, markershape=:circle, markersize=2, linestyle=:dash)
for (ns2, y2, d, r) in vs[2:end]
    plot!(p1, ns2, y2, markershape=:circle, markersize=2, linestyle=:dash)
end

p2 = plot(legend=false)
plot!(p2, ns, y./y, markershape=:circle, markersize=2, linestyle=:dash)
for (ns2, y2, d, r) in vs[2:end]
    plot!(p2, ns2, y2./y, markershape=:circle, markersize=2, linestyle=:dash)
end

directory = joinpath("figures", "dimensionality")
if !isdir(directory)
    mkpath(directory)
end

savefig(p1, joinpath(directory, "absolute.svg"))
savefig(p2, joinpath(directory, "ratio.svg"))
