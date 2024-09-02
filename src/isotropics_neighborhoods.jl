
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