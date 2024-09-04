
mutable struct  Neighborhood 
    m::Matrix{Bool}
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
