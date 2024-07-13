begin
using Pkg
Pkg.activate("./simulator")
#Pkg.instantiate()
using simulator
using Plots, Colors
end

begin
function evolve(canvas)
    M = float.(canvas)
    for i in 2:last(axes(M, 1))
        for j in axes(M, 2)
            if M[i-1, j] > 0
                left_j = j - 1 < 1 ? size(M, 2) : j - 1
                right_j = j + 1 > size(M, 2) ? 1 : j + 1
                if M[i, j] == 0
                    M[i, j] = 1
                elseif (M[i, j] == -1) && !(M[i, left_j] == -1) && !(M[i, right_j] == -1) && !(M[i - 1, left_j] == -1) && !(M[i - 1, right_j] == -1)
                    M[i, left_j] = 1
                    M[i, right_j] = 1
                elseif (M[i, j] == -1) && (M[i - 1, left_j] == -1) && !(M[i - 1, right_j] == -1) && !(M[i, left_j] == -1)
                    M[i, right_j] = 1
                elseif (M[i, j] == -1) && (M[i - 1, right_j] == -1) && !(M[i - 1, left_j] == -1) && !(M[i, right_j] == -1)
                    M[i, left_j] = 1
                elseif (M[i, j] == -1) && (M[i, left_j] == -1) && !(M[i, right_j] == -1) && !(M[i - 1, left_j] == -1)
                    M[i, right_j] = 1
                    M[i - 1, left_j] = 1
                elseif (M[i, j] == -1) && (M[i, right_j] == -1) && !(M[i, left_j] == -1) && !(M[i - 1, right_j] == -1)
                    M[i, left_j] = 1
                    M[i - 1, right_j] = 1
                elseif (M[i, j] == -1) && (M[i, right_j] == -1) && (M[i, left_j] == -1) && !(M[i - 1, right_j] == -1) && !(M[i - 1, left_j] == -1)
                    M[i - 1, right_j] = 1
                    M[i - 1, left_j] = 1
                end
            end
        end
    end
    #Flip horizontally
    M = M[:, end:-1:1]
    return M
end
end

begin
img = load_seed("seeds/annulus.png");
blobs = initialize_blobs(10, 2000, size(img)..., -1)
canvas = zeros(size(img))
for i in axes(canvas, 1)
    for j in axes(canvas, 2)
        if img[i, j] > 0
            canvas[i, j] = 1
        else
            canvas[i, j] = blobs[i, j]
        end
    end
end
img_polar = cartesian_to_polar(canvas);
end

begin
sim = transpose(copy(img_polar))
for _ in 1:100
    sim = evolve(sim)
end
end

begin
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
    