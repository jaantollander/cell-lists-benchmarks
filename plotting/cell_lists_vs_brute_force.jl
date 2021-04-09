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
dir_brute_force = "output/brute_force_2021-04-09T08:28:23+0300/"
dir_cell_lists = "output/cell_lists_2021-04-09T08:28:29+0300/"

for file in files
    lb = load(joinpath(dir_brute_force, file))["benchmarks"]
    lc = load(joinpath(dir_cell_lists, file))["benchmarks"]

    d = getfield(lb[1], :d)
    r = getfield(lc[1], :r)
    ns = getfield.(lb, :n)
    tb = getfield.(lb, :trials)
    tc = getfield.(lc, :trials)

    mb = [median.(t) for t in tb]
    mc = [median.(t) for t in tc]

    meanb = [mean(gettime.(v)) for v in mb]
    meanc = [mean(gettime.(v)) for v in mc]

    p1 = plot(legend=:topleft)
    plot!(p1, ns, meanb, markershape=:circle, markersize=2, linestyle=:dash, label="brute force")
    plot!(p1, ns, meanc, markershape=:circle, markersize=2, linestyle=:dash, label="cell lists")

    p2 = plot(legend=:topleft)
    plot!(p2, ns, meanb./meanc, markershape=:circle, markersize=2, linestyle=:dash, label="brute force/cell lists")

    directory = joinpath("figures", "cell_lists_vs_brute_force")
    if !isdir(directory)
        mkpath(directory)
    end

    savefig(p1, joinpath(directory, "d$d-r$r-n$(ns[end]).svg"))
    savefig(p2, joinpath(directory, "d$d-r$r-n$(ns[end])-ratio.svg"))
end
