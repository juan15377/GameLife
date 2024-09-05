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

