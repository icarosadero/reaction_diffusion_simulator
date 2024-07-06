module differential
using Images
using ProgressLogging
import YAML

export laplacian, solve_square, solve_square_dict, solve_t_pseudonnana

"""
    laplacian(grid, dx)

    Compute the discrete Laplacian of a grid using the finite difference method.

# Arguments
- `grid`: A 2D array representing the grid.
- `dx`: The grid spacing.

# Returns
- `lap`: A 2D array representing the Laplacian of the grid.
"""
function laplacian(grid, dx)
    return (circshift(grid, (0, 1)) .+ circshift(grid, (0, -1)) .+ circshift(grid, (1, 0)) .+ circshift(grid, (-1, 0)) .- 4 .* grid) ./ dx^2
end

"""
    solve_square(fields_initial, rhs, dx, dt, steps)

On a square domain, this function solves a nonlinear PDE in the form
\$\$\\frac{\\mathrm{d}}{\\mathrm{d} t}F = D(F)\$\$
where \$D\$ is a differential operator and F is a vector of fields.
"""
function solve_square(fields_initial, rhs, dx, dt, steps)
    F = copy(fields_initial)
    @progress for _ in 1:steps
        F += dt .* rhs(F, dx)
    end
    return F
end

function solve_square_dict(fields_initial, rhs, dx, dt, steps)
    F = copy(fields_initial)
    @progress for _ in 1:steps
        for key in keys(F)
            F[key] += dt .* rhs(F, dx)[key]
        end
    end
    return F
end
end