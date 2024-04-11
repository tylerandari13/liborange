class OObject {
	static is_OObject = true

	object = null
	object_name = ""
	odata = null

	// sector_ref = null

	constructor(obj) {
		odata = {} // we dont want all odatas to point to the same table
		if(::type(obj) == "string") {
			if("is_OObject" in ::get_sector()[obj]) {
				object = ::get_sector()[obj].object
			} else object = ::get_sector()[obj]
			delete ::get_sector()[obj]
			::get_sector()[obj] <- this
		} else {
			if("is_OObject" in obj) {
				object = obj.object
			} else object = obj
		}
		if("get_name" in object) {
			object_name = object.get_name()
		} else object_name = obj.tostring()

		// sector_ref = ::get_sector()
	}

	function display(ANY) ::display(ANY) // for convenience
	function print(object) ::print(object)

	function set_everything(stuff) foreach(i, v in stuff) if("set_" + i in this) this["set_" + i].acall([object].extend(type(v) == "array" ? v : [v]))

	// no `get_everything()` because it would be kinda complicated considering i cant iterate over a class instance

	// function in_current_sector() return sector_ref != null && sector_ref == ::get_sector()

	function get_name() return object_name

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

api_table().Object <- OObject
api_table().OObject <- OObject

api_table().convert_to_OObject <- function(sector = get_sector())
	foreach(i, v in sector)
		if(type(v) == "instance" && !("is_OObject" in v))
			OObject(i)

api_table().init_objects <- function(obj_name, obj_class, ...) {
	local params = (vargv.len() > 0 && type(vargv[0]) == "array") ? vargv[0] : vargv
	foreach(i, v in sector)
		if(startswith(i, obj_name) && !("is_OObject" in v))
			obj_class.instance().constructor.acall([obj_class.instance(), i].extend(params))
}
