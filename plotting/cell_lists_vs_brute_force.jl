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
dir_brute_force = "output/brute_force_serial_2021-04-04T13:22:24+0300/"
dir_cell_lists = "output/cell_lists_serial_2021-04-04T13:48:33+0300/"

for file in files
    lb = load(joinpath(dir_brute_force, file))
    lc = load(joinpath(dir_cell_lists, file))
    d, r, ns = lb["d"], lb["r"], lb["ns"]
    tb = lb["trials"]
    tc = lc["trials"]
    mb = [median.(tb[n]) for n in ns]
    mc = [median.(tc[n]) for n in ns]
    meanb = [mean(gettime.(v)) for v in mb]
    meanc = [mean(gettime.(v)) for v in mc]

    p1 = plot(legend=false)
    plot!(p1, ns, meanb, markershape=:circle, markersize=2, linestyle=:dash)
    plot!(p1, ns, meanc, markershape=:circle, markersize=2, linestyle=:dash)

    p2 = plot(legend=false)
    plot!(p2, ns, meanb./meanc, markershape=:circle, markersize=2, linestyle=:dash)

    directory = joinpath("figures", "cell_lists_vs_brute_force")
    if !isdir(directory)
        mkpath(directory)
    end

    savefig(p1, joinpath(directory, "d$d-r$r-n$(ns[end]).svg"))
    savefig(p2, joinpath(directory, "d$d-r$r-n$(ns[end])-ratio.svg"))
end
