include("phi_function.jl")
include("game_life_rule.jl")

using JLD
using GameZero
using Colors
using Random
using .Rules
using .Isotropics
using .Φ_function

# ! Config before show screen 

rule = game_life_rule
grid = generate_grid(100, .2)


SIZE_CELD = 4


CELD_COLOR = RGB(1, 1, 1)
BACKGROUND_COLOR = RGB(0, 0, 0)

# Guardar datos
save("src/config.jld", 
"grid", grid, 
"rule", rule,
"size_celd", SIZE_CELD,
"cell_color", CELD_COLOR,
"background_color", BACKGROUND_COLOR)

rungame("show_screen.jl")

