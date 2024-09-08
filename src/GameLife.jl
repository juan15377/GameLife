using Colors
using GameZero
using Random

module Isotropics

export Neighborhood

mutable struct  Neighborhood 
    m::Matrix{Bool}
end 


# add methods getindex and setindex! for Neighborhood
function Base.getindex(n::Neighborhood, i1::Int, i2::Int)
    return n.m[i1, i2]
end

function Base.setindex!(n::Neighborhood, value::Bool, i1::Int, i2::Int)
    n.m[i1, i2] = value
end

# Implementamos el método == para comparar dos objetos Neighborhood
function Base.:(==)(a::Neighborhood, b::Neighborhood)
    return a.m == b.m
end

# Implementamos el método hash para permitir que Neighborhood sea usado como clave
function Base.hash(n::Neighborhood, h::UInt)
    return hash(n.m, h)
end

"""
    generate_neighborhoood(indx::Integer)

generate neighborhood that a index `indx`.

# Arguments
- `indx::Integer`: index of neighborhood

# Returns
- `Neighborhood`: The neighborhood that generated of `indx

# Example
```julia
neighborhood(1)  #= Returns Neighborhood(Bool[0 0 0;
                                              0 0 0; 
                                              0 0 0]) =#

neighborhood(512) #= Returns Neighborhood(Bool[1 1 1; 
                                               1 1 1; 
                                               1 1 1]) =#


```
"""
function generate_neighborhoood(indx::Integer)

    function rotate_90(mat)
        transpose(mat)[end:-1:1, :]
    end 

    function all_rotations(mat)
        [mat, rotate_90(mat), rotate_90(rotate_90(mat)), rotate_90(rotate_90(rotate_90(mat)))]
    end 

    function reflect(mat)
        return mat[:, end:-1:1]  # Reflect matrix
    end 

    function binary_str(num) 
        num_str = string(num, base = 2)
        return "0"^(9 - length(num_str)) * num_str # normalize to length of nine digits
    end 

    binary_vector = [digit == '0' ? false : true for digit ∈ binary_str(indx-1)]
    neighborhood = Neighborhood(reshape(binary_vector, (3,3)))
    return neighborhood
end

export generate_neighborhoood

"""
    all_equivalent_neighborhoods(neighborhood)

Generates all equivalent neighborhoods by applying rotations and reflections to the input neighborhood matrix.

# Arguments
- `neighborhood`: An object containing a matrix `m`, representing the neighborhood. This matrix is assumed to be a 2D array.

# Returns
- A `Set` containing all unique matrices that are equivalent to the input neighborhood matrix after applying rotations and reflections.

# Description
This function calculates all matrices that are equivalent to the input neighborhood matrix by considering its possible rotations (90, 180, 270 degrees) and reflections.

## Internal Functions
- `rotate_90(mat)`: Returns the matrix `mat` rotated 90 degrees clockwise.
- `all_rotations(mat)`: Returns a list containing the original matrix and its rotations by 90, 180, and 270 degrees.
- `reflect(mat)`: Returns the matrix `mat` reflected along the vertical axis.

## Process
1. The input neighborhood matrix and its reflected version are considered.
2. For each of these matrices, all possible rotations are generated.
3. Each unique rotation is added to the set of equivalent neighborhoods.

# Example
```julia
neighborhood = Neighborhood([0 0 0;
                             0 1 0;
                             0 0 0])
equivalent_neighs = all_equivalent_neighborhoods(neighborhood) # returns Set(Neighborhood([0 0 0; 0 1 0; 0 0]))
```
"""
function all_equivalent_neighborhoods(neighborhood)

    set_neigh::Set{Neighborhood} = Set()

    function rotate_90(mat)
        transpose(mat)[end:-1:1, :]
    end 

    function all_rotations(mat)
        [mat, rotate_90(mat), rotate_90(rotate_90(mat)), rotate_90(rotate_90(rotate_90(mat)))]
    end 

    function reflect(mat)
        return mat[:, end:-1:1]  # Reflect matrix
    end 

    for matrix in [neighborhood.m, reflect(neighborhood.m)]
        for rotation in all_rotations(matrix)
            push!(set_neigh, Neighborhood(rotation))
        end
    end 

    return set_neigh

end
"""
    are_neighborhoods_equivalent(neighborhood_1::Neighborhood, neighborhood_2::Neighborhood) -> Bool

Determines if two neighborhood matrices are equivalent by checking if the first neighborhood is among the set of all equivalent neighborhoods of the second.

# Arguments
- `neighborhood_1`: A `Neighborhood` object containing a matrix `m` to be compared.
- `neighborhood_2`: A `Neighborhood` object containing a matrix `m` to be compared.

# Returns
- `Bool`: `true` if `neighborhood_1` is equivalent to `neighborhood_2` by rotation or reflection, `false` otherwise.

# Description
This function checks if two neighborhoods are equivalent by generating all possible rotations and reflections of `neighborhood_2` and then checking if `neighborhood_1` is among those. Equivalence is defined by the neighborhood matrices being identical after a sequence of rotations or reflections.

# Example
```julia
neighborhood1 = Neighborhood(rand(3, 3))
neighborhood2 = Neighborhood(rand(3, 3))

if are_neighborhoods_equivalent(neighborhood1, neighborhood2)
    println("The neighborhoods are equivalent.")
else
    println("The neighborhoods are not equivalent.")
end
```
"""
function are_neighborhoods_equivalent(neighborhood_1::Neighborhood, neighborhood_2::Neighborhood)
    return neighborhood_1 ∈ all_equivalent_neighborhoods(neighborhood_2)
end 
"""
   generate_dict_isotropics_neighborhoods() -> Dict()

Calculate and determine the mapping in Rule for each of the 512 neighborhoods, ensuring that two neighborhoods are considered equivalent if and only if their mappings are identical.

# Returns
- A `Dict` containing all mapping of 512 neighborhood in 101 values in Rule.


## Internal Functions
- `find_mapping_rule(neighborhood)`: Returns the mapping of the neighborhood if other neighborhood equivalent added in dict_mapping_rule

# Example
```julia
isotropics_neighborhoods = generate_dict_isotropics_neighborhoods() # returns "pendiente"
```
"""
function generate_dict_isotropics_neighborhoods()
    set_of_added_neigh::Set{Neighborhood} = Set()
    dict_mapping_rule::Dict{Neighborhood, Int} = Dict() # diccionario de donde una vencidad mepea a una regla de 101 valores

    function find_mapping_rule(neighborhood)
        for neigh in keys(dict_mapping_rule)
            if are_neighborhoods_equivalent(neigh, neighborhood)
                return dict_mapping_rule[neigh]
            end 
        end 
    end 

    mapping = 0

    for i in 1:512
        neighborhood = generate_neighborhoood(i)
        if neighborhood in set_of_added_neigh
            dict_mapping_rule[neighborhood] = find_mapping_rule(neighborhood)
        else
            union!(set_of_added_neigh, all_equivalent_neighborhoods(neighborhood))
            mapping += 1
            new_mapping_position = mapping 
            dict_mapping_rule[neighborhood] = new_mapping_position
        end
    end 
    return dict_mapping_rule
end 

const Isotropics_Neighborhoods = generate_dict_isotropics_neighborhoods()
export Isotropics_Neighborhoods

end



module Rules 

using ..Isotropics

export game_life_rule, Rule


mutable struct Rule
    mapping :: Array{Bool}

    function Rule(mapping::AbstractArray{Bool})
        if length(mapping) != 102 
            error("the lenght of mapping should be equal of length of isotropics_neighborhoods")
        end 
        new(mapping)
    end 
end 

function Base.getindex(r::Rule, i::Int) 
    if i > 102 || i < 0
        error("the index is not in 1:102")
    end
    return r.mapping[i]
end

function Base.setindex!(r::Rule, new_value::T, index::Int) where {T<:Union{Int, Bool}}
    if index > 102 || index < 0
        error("the index not in 1:102")
    end
    r.mapping[index] = new_value
end

Base.sum(n::Neighborhood) = sum(n.m) - n.m[2,2] # sum grid excluyendo el centro 

function rules_game_life(n::Neighborhood)::Bool

    if_live_cell_center(n::Neighborhood)::Bool = n.m[2, 2]

    if if_live_cell_center(n) 
        if (sum(n) == 2 || sum(n) == 3) # sum with method sum(neighborhood)
            return true 
        end 
        return false
    end 
    if ! if_live_cell_center(n)
        if sum(n) == 3
            return true 
        end 
        return false 
    end 
end 

function generate_game_life_rule()
    game_life_rule = Rule(fill(false, 1, 102))

    for i in 1:512 
        neighborhood = generate_neighborhoood(i)
        
        if rules_game_life(neighborhood)
            indx_mapping = Isotropics_Neighborhoods[neighborhood]
            game_life_rule[indx_mapping] = true 
        end 
    end 
    return game_life_rule
end 

export game_life_rule

const game_life_rule = generate_game_life_rule()

end 


module Φ_function 

export Φ

using ..Isotropics
using ..Rules

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

export generate_grid

function generate_grid(size ,porcent)
    grid=fill(false,size ,size)
    f(x) = rand(1)[1] < porcent ? true : false
    grid = map(x->f(x), grid)
    return grid
end


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

end


using .Isotropics
using .Φ_function
using .Rules

global rule = game_life_rule
global grid = generate_grid(50, .2)
global cell_size = 5
global BACKGROUND = RGB(0, 0, 0)

n_rows, n_cols = size(grid)

global k=10

global cell_color = RGB(1, 1, 1)

WIDTH = cell_size * n_rows + cell_size
HEIGHT = cell_size * n_cols + cell_size

global grid_0 = grid
function setup(g::Game)
    # Aumentar la velocidad del juego a 120 FPS
    game.speed = 1
end


function actualiza()
    if c%2 ==0
    global grid = Φ(grid, rule)
    end 
    global c=c+1
end


function update(g::Game)
    actualiza()
end 


function draw(g::Game)
    for i in 1:n_rows
        for j in 1:n_cols
            if grid[i,j]==1 
                draw(Rect(j*cell_size + 1 ,i*cell_size + 1, cell_size,cell_size), cell_color, fill=true)
            end
        end 
    end
end 

function on_keydown(key)
    if key == Key.DOWN
        global k=k+1
    end
end

function on_keydown(key)
    if key == Key.UP
        global k=k-1
    end
end

