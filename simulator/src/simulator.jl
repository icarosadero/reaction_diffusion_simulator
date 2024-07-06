module simulator

export load_seed, laplacian, solve_square, solve_square_dict, solve_t_pseudonnana, cartesian_to_polar, polar_to_cartesian, initialize_blobs, waterfall

include("differential.jl")
using .differential

include("common.jl")
using .common

include("automata.jl")
using .automata

end # module