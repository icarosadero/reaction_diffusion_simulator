module common
using Images

export load_seed, cartesian_to_polar, polar_to_cartesian

"""
    load_seed(path, pad_percentage = 0.5)

Load an image from the specified `path` and convert it to a grayscale image. 
The image is then padded with zeros on all sides by a percentage of its size specified by `pad_percentage`.

# Arguments
- `path`: The path to the image file.
- `pad_percentage`: The percentage of padding to be added to the image. Default is 0.5.

# Returns
- `img`: The padded grayscale image as a matrix of type `Matrix{Float64}`.

"""
function load_seed(path, pad_percentage = 0.5)
    img = Gray.(Images.load(path))
    L = size(img, 1)
    n = floor(Int, pad_percentage*L)
    img = convert(Matrix{Float64}, img)
    img = padarray(img, Fill(0, (n,n)))
    img = Matrix(collect(img))
    return img
end


"""
    cartesian_to_polar(img)

Converts an image from polar coordinates to cartesian coordinates assuming that the center of the image is the origin.

# Arguments
- `img`: The input image in polar coordinates.

# Returns
- `C`: The converted image in cartesian coordinates.

"""
function cartesian_to_polar(img)
    M = ceil.(Int,img)
    c = size(M)./2
    D = maximum(size(M))
    R = ceil(Int, D*sqrt(2)/2)
    C = R
    C_int = ceil(Int, C)
    P = zeros(Int, C_int, R)
    @debug "Center: $c"
    @debug size(P)
    #Map polar coordinates to cartesian coordinates while assuming that the center of the image is the origin
    for θ in axes(P,1)
        for r in axes(P,2)
            x = r*cos(2*pi*θ/C)
            y = r*sin(2*pi*θ/C)
            x_original = floor(Int, x + c[2])
            y_original = floor(Int, y + c[1])
            if x_original >= 1 && x_original <= size(M,2) && y_original >= 1 && y_original <= size(M,1)
                P[θ, r] = M[y_original, x_original]
            end
        end 
    end
    return P
end

function polar_to_cartesian(img_polar)
    P = copy(img_polar)
    R = size(P, 2)
    C = size(P, 1)
    L = floor(Int, 2*R/sqrt(2))
    M = zeros(Int, L, L)
    c = size(M)./2
    for y in axes(M, 1)
        for x in axes(M, 2)
            r = sqrt((y - c[1])^2 + (x - c[2])^2)
            θ = atan(y - c[1], x - c[2]) + pi
            T = C*θ/(2*pi)
            r = floor(Int, r) + 1
            r = r > R ? R : r
            T = floor(Int, T) + 1
            T = T > C ? C : T
            M[y, x] = P[T, r]
        end
    end
    return M
end
end