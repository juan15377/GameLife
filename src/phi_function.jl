include("game_life_rule.jl")

function get_neighborhood(grid::Matrix{Bool}, x::Int, y::Int)
    rows, columns = size(grid)
    neighborhood = Neighborhood(zeros(Bool, 3, 3))
    for i in -1:1
        for j in -1:1
            neighborhood[i + 2, j + 2] = grid[mod(x + i - 1, rows) + 1, mod(y + j - 1, columns) + 1]
        end
    end
    return neighborhood
end

@inline function ϕ(n::Neighborhood, rule::Rule)
    return rule[Isotropics_Neighborhoods[n]]
end 

function Φ(grid::Matrix{Bool}, rule::Rule)
    indices = CartesianIndices(grid)
    @inbounds new_grid = map(y->ϕ(y, rule),map(x->get_neighborhood(grid ,x[1], x[2]), indices))
    return new_grid
end 

# ! functions to help 

# generar tablero 


function generate_grid(size ,porcent)
    grid=fill(false,size ,size)
    f(x) = rand(1)[1] < porcent ? true : false
    grid = map(x->f(x), grid)
    return grid
end

generate_grid(100, .1)

# ? cuadricular una matriz 

function normalize_grid(grid::Matrix{Bool})
    nums_rows,nums_cols = size(grid)
    if nums_rows == nums_cols
        return grid
    end
    if nums_rows > nums_cols
        new_grid = fill(false, nums_rows, nums_cols + (nums_rows-nums_cols))
        new_grid[1:nums_rows, 1:nums_cols] = grid
        return new_grid
    end

    if nums_cols > nums_rows
        new_grid = fill(false, nums_rows + (nums_cols - nums_rows), nums_rows)
        new_grid[1:nums_rows, 1:nums_cols] = grid
        return new_grid
    end 
end 

