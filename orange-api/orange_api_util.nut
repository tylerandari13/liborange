function get_sector() {
	try {
		return sector
	} catch(e) {
		try {
			return worldmap
		} catch(e) {
			return {}
		}
	}
}

if(!("liborange" in getroottable())) getroottable().liborange <- {}
if(!("liborange_data" in getroottable())) getroottable().liborange_data <- {}

function api_table() return getroottable().liborange
function api_storage() return getroottable().liborange_data

if(!("orange_api" in getroottable())) getroottable().orange_api <- class {
	theref = null
	constructor(weak) {
		theref = weak
	}
	function _get(key) {
		::display(@"The function `""orange-api." + key + @"()""` is deprecated, please use `liborange." + key + "()` instead.")
		return theref[key]
	}
}(api_table().weakref())


function help() display_text_file("orange-api/help.stxt")

function distance_from_point_to_point(x1, y1, x2, y2) return sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2))

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

class OObject {
	static is_OObject = true

	object = null
	object_name = null
	odata = null

	constructor(obj) {
		odata = {} // we dont want all odatas to point to the same table
		if(::type(obj) == "string") {
			if("is_OObject" in get_sector()[obj]) {
				object = get_sector()[obj].object
			} else object = get_sector()[obj]
			delete get_sector()[obj]
			get_sector()[obj] <- this
		} else {
			if("is_OObject" in obj) {
				object = obj.object
			} else object = obj
		}
		if("get_name" in object) {
			object_name = object.get_name()
		} else object_name = obj
	}

	function display(ANY) { // for convenience
		::display(ANY)
	}

	function _get(key) { // Returning just the function doesnt work. We need to bind the object to the enviroment to get it to work.
		if(key == "get_x" && "get_pos_x" in object) {
			return object.get_pos_x.bindenv(object)
		} else if(key == "get_y" && "get_pos_y" in object) {
			return object.get_pos_y.bindenv(object)
		} else if(key in object) {
			if(::type(object[key]) == "function") {
				return object[key].bindenv(object)
			} else {
				return object[key]
			}
		} else if(key in odata) {
			return odata[key]
// Godot-like get_*() and set_*() functions. if theres a variable in an OObject called `value` then typing `OObject.get_value()` will return `value`
		} /*else if(key.slice(0, 4) == "get_") {
			return function[this]() return this[key.slice(4)]
		}else if(key.slice(0, 4) == "set_") {
			return function[this](value) return this[key.slice(4)] = value
		}*/
		throw null
	}

	function _set(key, value) {
		if(key in odata) return odata[key] = value
		throw null
	}

	function _newslot(key, value) {
		return odata[key] <- value
	}

	function _delslot(key) {
		return delete odata[key]
    }
}

class OThread extends OObject {
	constructor(func) {
		if(::type(func) == "string") {
			base.constructor(::newthread(compilestring(func)))
		} else base.constructor(::newthread(func))
		if(!("OThreads" in ::api_storage())) ::api_storage().OThreads <- []
		::api_storage().OThreads.push(object)
	}
	function _get(key) {
		try {
			return function(...) {
				return object[key].acall([object].extend(vargv))
			}
		} catch(e) {
			return base._get(key)
		}
		throw null
	}
}

// convert all instances to OObjects
//foreach(i, v in get_sector()) if(::type(v) == "instance") OObject(i)