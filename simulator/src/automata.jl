module automata

export waterfall, initialize_blobs

"""
    waterfall(canvas)

Apply the downward stream rule to the given `canvas` and return the updated canvas.

The downward stream rule is applied to each cell in the `canvas` starting from the second row. If the cell above is 1, and the current cell is 0, it changes the current cell to 1. If the current cell is -1, it also checks the neighboring cells. If any of the neighboring cells are 0, it changes them to 1.

# Arguments
- `canvas`: A 2D array representing the current state of the automata.

# Returns
The updated `canvas` after applying the downward stream rule.

"""
function waterfall(canvas)
    M = copy(canvas)
    for i in 2:last(axes(M, 1))
        for j in axes(M, 2)
            if M[i-1, j] == 1
                if M[i, j] == 0
                    M[i, j] = 1
                elseif M[i, j] == -1
                    left_j = j - 1 < 1 ? size(M, 2) : j - 1
                    right_j = j + 1 > size(M, 2) ? 1 : j + 1
                    if M[i, left_j] == 0
                        M[i, left_j] = 1
                    end
                    if M[i, right_j] == 0
                        M[i, right_j] = 1
                    end
                end
            end
        end
    end
    #Flip horizontally
    M = M[:, end:-1:1]
    return M
end


"""
    initialize_blobs(radius, num_blobs, width, height)

Create and initialize a list of blobs with random positions.

# Arguments
- `radius`: The radius of each blob.
- `num_blobs`: The number of blobs to create.
- `width`: The width of the grid.
- `height`: The height of the grid.

# Returns
A list of blobs, where each blob is represented as a 2D array of integers.
"""
function initialize_blobs(radius, num_blobs, width, height)
    blobs  = zeros(Int, width, height)
    for _ in 1:num_blobs
        x = rand(1:width)
        y = rand(1:height)
        for j in -radius:radius
            for k in -radius:radius
                if (j^2 + k^2) <= radius^2
                    blobs[mod1(x+j, width), mod1(y+k, height)] = 1
                end
            end
        end
    end
    return blobs
end

end