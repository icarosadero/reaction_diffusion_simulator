begin
using Pkg
Pkg.activate("./simulator")
# Pkg.instantiate()
using simulator
using Plots, Colors
ENV["JULIA_DEBUG"] = Base
end

begin
img = zeros(Bool, 500, 500)
c = size(img) ./ 2
for i in 1:size(img, 1)
    for j in 1:size(img, 2)
        r = sqrt((i - c[1])^2 + (j - c[2])^2)
        img[i, j] = mod(floor(Int,r/25.0), 3) == 0
    end
end
end


begin
img_polar = cartesian_to_polar(img)
end

begin
img_reverse = polar_to_cartesian(img_polar)
end

begin
heatmaps = []
for I in [img, img_polar, img_reverse]
    push!(heatmaps, heatmap(I, aspect_ratio=1, color=:hot))
end
plot(heatmaps..., layout=(2,2))
savefig("runs/plots/polar_transformation_test.svg")
end
