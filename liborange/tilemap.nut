/**
 * @file Houses functions related to getting data from a tilemap.
 */

local tilemap = add_module("tilemap")

/**
 * @function get_width
 * @param {instance} map
 * @return {float}
 * @description Returns the width of the given tilemap.
 */
tilemap.get_width <- function(map) {
	local inc = 0
	while(true) {
		local old_id = map.get_tile_id(inc, 0)
		map.change(inc, 0, 1)
		if(map.get_tile_id(inc, 0) == 1) {
			map.change(inc, 0, old_id)
			inc++
		} else {
			break
		}
	}
	return inc
}

/**
 * @function get_height
 * @param {instance} map
 * @return {float}
 * @description Returns the height of the given tilemap.
 */
tilemap.get_height <- function(map) {
	local inc = 0
	while(true) {
		local old_id = map.get_tile_id(0, inc)
		map.change(0, inc, 1)
		if(map.get_tile_id(0, inc) == 1) {
			map.change(0, inc, old_id)
			inc++
		} else {
			break
		}
	}
	return inc
}
