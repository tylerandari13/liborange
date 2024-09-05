/**
 * @file Houses functions that tell you where you are in the game..
 */

local location = add_module("location")

location.in_sector <- function() {
	local retval = false
	try {
		retval = sector != null
	} catch(e) {}
	return retval
}

location.in_worldmap <- function() {
	local retval = false
	try {
		retval = worldmap != null
	} catch(e) {}
	return retval
}
