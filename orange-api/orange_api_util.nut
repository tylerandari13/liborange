::liborange <- class { // not a table so that ::display(sector) doesnt flood the console with orange api stuff
	other_data = {}
}

function get_sector() {
	try {
		return sector
	} 	catch(e) {
		try {
			return worldmap
		} catch(e) {
			return {}
		}
	}
}

function api_table() {
	if(!("liborange" in get_sector())) get_sector().liborange <- liborange
	return liborange
}
function api_storage() return api_table().other_data
function api_sector_storage() {
	if(!("_liborange_other_data" in get_sector())) get_sector()._liborange_other_data <- class{}
	return get_sector()._liborange_other_data
}

function help() display_text_file("orange-api/help.stxt")

function distance_from_point_to_point(...) {
	local x1 = 0
	local y1 = 0
	local x2 = 0
	local y2 = 0
	switch(vargv.len()) {
		case 2: // distance_from_point_to_point(pos1, pos2)
			x1 = vargv[0].x
			x2 = vargv[1].x
			y1 = vargv[0].y
			y2 = vargv[1].y
		break
		case 4: // distance_from_point_to_point(x1, y1, x2, y2)
			x1 = vargv[0]
			x2 = vargv[2]
			y1 = vargv[1]
			y2 = vargv[3]
		break
		default:
			throw "wrong number of parameters"
		break
	}
	return sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2))
}

function get_players(include_OObjects = true) {
    local arroy = {}
    foreach(i, v in get_sector()) if("use_scripting_controller" in v || (include_OObjects && "is_OObject" in v && "use_scripting_controller" in v.object))
		arroy[i] <- v
    return arroy
}

function get_nearest_player(x, y) {
	local closest_pos = -1
	local closest_object
	foreach(i, v in get_players()) {
		local new_pos = distance_from_point_to_point(x, y, v.get_x(), v.get_y())
		if(new_pos < closest_pos || closest_pos < 0) {
			closest_object = v
			closest_pos = new_pos
		}
	}
	return closest_object
}

function objects_collided(x1, y1, w1, h1, x2, y2, w2, h2, direction = "auto")
	return ((direction == "up" || direction == "top" || direction == "auto") && (y1 + h1 <= y2 + 1))
	|| ((direction == "down" || direction == "bottom" || direction == "auto") && (y1 >= y2 + h2 - 1))
	|| ((direction == "left" || direction == "auto") && (x1 >= x2 + w2 - 1))
	|| ((direction == "right" || direction == "auto") && (x1 + w1 <= x2 + 1))

function collided_with_any_player(x1, y1, w1, h1, direction = "auto") {
	local collided = {}
	foreach(i, player in get_players())
		if(objects_collided(player.get_x(), player.get_y(), 32, (player.get_bonus() == "none" ? 32 : 64), x1, y1, w1, h1, direction))
			collided[1] <- player
	return collided
}

// some scripts shouldnt trigger on the worldmap. any scripts that shouldnt trigger should have some sorta `if(WORLDMAP_GUARD)` somewhere in it
// this variable is true if youre not on the worldmap
function WORLDMAP_GUARD() {
	try {
		return sector != null
	} catch(e) return false
}
::WORLDMAP_GUARD <- WORLDMAP_GUARD()
::SECTOR_GUARD <- !WORLDMAP_GUARD
