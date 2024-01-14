local alternating_tiles = []

function tilemap_get_width(tilemap) {
	local inc = 0
	while(true) {
		local oldid = tilemap.get_tile_id(inc, 0)
		tilemap.change(inc, 0, 1)
		if(tilemap.get_tile_id(inc, 0) == 1) {
			tilemap.change(inc, 0, oldid)
			inc++
		} else break
	}
	tilemap.change(0, 1, 0)
	return inc
}

function tilemap_get_height(tilemap) {
	local inc = 0
	while(true) {
		local oldid = tilemap.get_tile_id(0, inc)
		tilemap.change(0, inc, 1)
		if(tilemap.get_tile_id(0, inc) == 1) {
			tilemap.change(0, inc, oldid)
			inc++
		} else break
	}
	tilemap.change(0, 1, 0)
	return inc
}

function alternate_tile(tilemap, x, y, framerate, ids, ...) {
	local tile_ids = []
	if(type(ids) == "array") {
		tile_ids = ids
	} else {
		tile_ids.push(ids)
		foreach(v in vargv) tile_ids.push(v)
	}
	alternating_tiles.push({
		tilemap = tilemap
		x = x
		y = y
		framerate = framerate
		ids = tile_ids
		current_id = 0
	})

	if(!("alternating_tiles_thread" in api_storage())) {
		api_storage().alternating_tiles_thread <- OThread(function(table) {
			local i = 0
			while(true) {
				foreach(v in table.ref()) {
					if(i % v.framerate == 0) {
						v.tilemap.change(v.x, v.y, v.ids[v.current_id % v.ids.len()])
						v.current_id++
					}
				}
				i = /*i > 60 ? 0 :*/ i + 1
				wait(0.01)
			}
		})
		api_storage().alternating_tiles_thread.call(alternating_tiles.weakref())
	}
}

api_table().alternate_tiles <- function(tilemap, id, framerate, ids, ...) {
	local tile_ids
	if(type(ids) == "array") {
		tile_ids = ids
	} else {
		tile_ids = [ids].extend(vargv)
	}
	for(local x = 0; x < tilemap_get_width(tilemap); x++)
		for(local y = 0; y < tilemap_get_height(tilemap); y++)
			if(tilemap.get_tile_id(x, y) == id) alternate_tile(tilemap, x, y, framerate, tile_ids)
}

api_table().tilemap_get_width <- tilemap_get_width
api_table().tilemap_get_height <- tilemap_get_height
api_table().alternate_tile <- alternate_tile
