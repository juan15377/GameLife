include("phi_function.jl")


using GameZero
using Colors
using Random


global rule = game_life_rule
global grid = generate_grid(100, .2)


# las funciones anteriores sirven para generar una particion bajo la relacion de equivalencia 
# entre vecindades simetricas 
#la funcion sub_simetrias me da una lista de todos los conjuntos de vecindades respecto a sus simetria 
# ejemplo: sub_simetrias me da un conjunto de conjuntos donde en cada subconjunto se encuentran
# donde aquellas vecindades son equivalentes de manera simetrica 
# se hace una lista de listas donde cada una contiene a las vecindades
# que son equivalentes 



global rows,cols = size(grid)


global k=10

global color = RGB(1,1,1)


BACKGROUND_COLOR = colorant"black"
const size_celd = 4

WIDTH_SCREEN  = tamaño*filas + tamaño
HEIGHT_SCREEN = tamaño*columnas + tamaño


function update_grid()
    sleep(.01)
    global grid = Φ(grid, rule)
end


function update(g::Game)
    update_grid()
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

