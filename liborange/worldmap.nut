//TODO: yeah
/*local worldmap = add_module("worldmap")

//worldmap.save_state <- function() {}
//worldmap.load_state <- function() {}

local current_sector = "main"

local get_table = function() {
    if(!("liborange" in state)) state.liborange <- {
        tilemaps = {}
    }
    if(!(current_sector in state.liborange)) state.liborange[current_sector] <- {}
    return state.liborange[current_sector]
}

worldmap.set_sector <- function(sect)
    current_sector = sect

worldmap.save_tilemap <- function(name, showing = true) {
    local table = get_table()
    table.tilemaps[name] <- {
        visible = showing
    }
}

worldmap.load_tilemaps <- function() {
    local table = get_table().tilemaps
    foreach(v in [name]) {

    }
}
*/