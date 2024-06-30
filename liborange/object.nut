add_module("object")
add_module("meta") // metadata

local META_GUARD = function(obj) {
	if(!(obj in liborange.meta)) liborange.meta[obj] <- {}
}

class OObject {
	is_oobject = true

	object = null

	constructor(obj) {
		if(type(obj) == "string") {
			object = get_sector()[obj]
			get_sector()[obj] = this
		} else {
			object = obj
		}
	}

	function has_meta(key) {
		META_GUARD(this)

		return key in liborange.meta[this]
	}

	function get_meta(key, default_value = null) {
		META_GUARD(this)

		return has_meta(key) ? liborange.meta[this][key] : default_value
	}

	function set_meta(key, value) {
		META_GUARD(this)

		liborange.meta[this][key] <- value
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
		if(key in object) {
				return object[key] = value
		}
		throw null
	}
}
