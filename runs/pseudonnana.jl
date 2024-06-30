begin
using Pkg
Pkg.activate("./simulator")
# Pkg.instantiate()
# Pkg.add("YAML")
# Pkg.add("Colors")
end

begin
using simulator
using SparseArrays
using Images
using Plots, Colors
import YAML
end

begin
"""
    solve_t_pseudonnana(parameter_path, seed_path, steps, dt)

Solves a reaction-diffusion system using the pseudonanna model.

# Arguments
- `parameters::Dict`: Dictionary containing parameters to be used in the simulation. Must have diffusion constants (DI, D1, D2), k_in, k_out, k_s, Ic, and h.
- `seed_path::AbstractString`: The path to the file containing the initial seed for the simulation.
- `steps::Integer`: The number of simulation steps to perform.

# Returns
An array representing the evolution of the system over time.
"""
function solve_t_pseudonnana(seed_path, parameters, steps, dx=1.0, dt=1.0)
    D_max = max(parameters["DI"], parameters["D1"], parameters["D2"])
    #dx*dx/(2 * D_max)
    @info "Steps" dt dx D_max

    seed = load_seed(seed_path)

    fields = zeros(4, size(seed)...) #Order: S1, S2, I, S
    fields[1, :, :] = ones(size(seed))
    fields[2, :, :] = copy(seed)

    function rhs(F, dx)
        S1 = F[1,:,:]
        S2 = F[2,:,:]
        I = F[3,:,:]
        H = (parameters["Ic"]^parameters["h"]) ./ ((parameters["Ic"]^parameters["h"]) .+ I.^parameters["h"])
        @assert size(H) == size(seed)
        @assert any(isnan, H) || !any(isfinite, H) == false
        dS1 = parameters["D1"].*laplacian(S1, dx) - H.*S2.*S2.*S1 .+ parameters["kin"] - parameters["kout"].*S1
        dS2 = parameters["D2"].*laplacian(S2, dx) + H.*S1.*S2.*S2 - parameters["ks"].*S2
        dI = parameters["DI"].*laplacian(I, dx) + parameters["ks"].*S2
        dS = parameters["ks"].*S2
        result = permutedims(cat(dS1, dS2, dI, dS, dims=3), (3,1,2))
        return result
    end

    return solve_square(fields, rhs, dx, dt, steps)
end
end

begin
params = YAML.load_file("params.yaml")
result = solve_t_pseudonnana("seeds/annulus.png", params, 25000);
S1 = result[1,:,:]
S2 = result[2,:,:]
I = result[3,:,:]
S = result[4,:,:]
end

begin
heatmaps = []
for i in 1:4
    push!(heatmaps, heatmap(result[i,:,:], aspect_ratio=1, color=:hot))
end
plot(heatmaps..., layout=(2,2))
savefig("runs/plots/pseudonnana_annulus.svg")
end

begin
params = YAML.load_file("params.yaml")
result = solve_t_pseudonnana("seeds/annulus_thin.png", params, 25000);
S1 = result[1,:,:]
S2 = result[2,:,:]
I = result[3,:,:]
S = result[4,:,:]
end

begin
heatmaps = []
for i in 1:4
    push!(heatmaps, heatmap(result[i,:,:], aspect_ratio=1, color=:hot))
end
plot(heatmaps..., layout=(2,2))
savefig("runs/plots/pseudonnana_annulus_thin.svg")
end

begin
params = YAML.load_file("params.yaml")
result = solve_t_pseudonnana("seeds/stubby.png", params, 25000);
S1 = result[1,:,:]
S2 = result[2,:,:]
I = result[3,:,:]
S = result[4,:,:]
end

begin
heatmaps = []
for i in 1:4
    push!(heatmaps, heatmap(result[i,:,:], aspect_ratio=1, color=:hot))
end
plot(heatmaps..., layout=(2,2))
savefig("runs/plots/stubby.svg")
end