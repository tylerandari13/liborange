add_module("object")
add_module("meta") // metadata

class OObject {
	is_oobject = true

	object = null

	constructor(obj) {
		get_module("meta")[this] <- {}

		if(type(obj) == "string") {
			object = get_sector()[obj]
			get_sector()[obj] = this
		} else {
			object = obj
		}
	}

	function has_meta(key) {
		return key in get_module("meta")[this]
	}

	function get_meta(key, default_value = null) {
		return has_meta(key) ? get_module("meta")[this][key] : default_value
	}

	function set_meta(key, value) {
		get_module("meta")[this][key] <- value
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
