add_module("object")

local meta = {}

class OObject {
	is_oobject = true

	object = null

	constructor(obj) {
		meta[this] <- {}

		if(type(obj) == "string") {
			object = get_sector()[obj]
			get_sector()[obj] = this
		} else {
			object = obj
		}
	}

	function has_meta(key) {
		return key in meta[this]
	}

	function get_meta(key, default_value = null) {
		return has_meta(key) ? meta[this][key] : default_value
	}

	function set_meta(key, value) {
		meta[this][key] <- value
	}

	function _get(key) {
		if(key in object) {
			if(type(object[key]) == "function") {
				return object[key].bindenv(object)
			} else {
				return object[key]
			}
		}
		throw null
	}

	function _set(key, value) {
		if(key in object)
			return object[key] = value
		throw null
	}
}
