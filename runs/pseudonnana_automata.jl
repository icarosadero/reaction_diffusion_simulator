begin
using Pkg
Pkg.activate("./simulator")
#Pkg.instantiate()
using simulator
using Plots, Colors
end

begin
img = load_seed("seeds/annulus.png");
blobs = -1 .* initialize_blobs(10, 1000, size(img)...)
img = img + blobs
img_polar = cartesian_to_polar(img);
end

begin
sim = waterfall_scalar(transpose(img_polar))
sim_cartesian = polar_to_cartesian(transpose(sim))
end

begin
heatmaps = []
for I in [img, img_polar, sim, sim_cartesian]
    push!(heatmaps, heatmap(I, aspect_ratio=1, color=:hot))
end
plot(heatmaps..., layout=(2,2))
savefig("runs/plots/annulus_automata.svg")
end
    