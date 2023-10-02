import("orange-api/orange_api_util.nut")

get_api_table().tilemap_get_width <- function(tilemap) {
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

get_api_table().tilemap_get_height <- function(tilemap) {
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
