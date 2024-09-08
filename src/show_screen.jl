using JLD
using GameZero
using Colors
using Random
include("phi_function.jl")
using .Rules
using .Isotropics
using .Φ_function


config = load("src/config.jld")

global rule = config["rule"]
global grid = config["grid"]
global cell_size = config["size_celd"]
global BACKGROUND = config["background_color"]

n_rows, n_cols = size(grid)

global k=10

global cell_color = config["cell_color"]

WIDTH = cell_size * n_rows + cell_size
HEIGHT = cell_size * n_cols + cell_size

global grid_0 = grid
function setup(g::Game)
    # Aumentar la velocidad del juego a 120 FPS
    game.speed = 1
end


function actualiza()
    if c%2 ==0
    global grid = Φ(grid,regla)
    end 
    global c=c+1
end


function update(g::Game)
    actualiza()
end 


function draw(g::Game)
    for i in 1:filas
        for j in 1:columnas 
            if tablero[i,j]==1 
                draw(Rect(j*tamaño+1 ,i*tamaño+1,tamaño,tamaño),color,fill=true)
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

