
module Rules 

export game_life_rule


include("isotropics_neighborhoods.jl")
using.Isotropics

export Rule
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

