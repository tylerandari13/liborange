/**
 * @file Houses the OObject.
 */

local object = add_module("object")

::o <- add_module("o")
get_sector().o <- o

local meta = {}

/**
 * @class OObject
 * @description The core of liborange's custom scripting.
 * Allows you to "take over" objects in the sector and inject your own custom code and functionality.
 */
class OObject {
	/**
	 * @member {bool} is_oobject
	 * @default is_oobject true
	 * @description This object is an OObject!
	 * When checking for if an object is an OObject please check for if this member exists, not whether its true.
	 */
	is_oobject = true

	/**
	 * @member {string} name
	 * @description The name of the object this OObject has taken over. If you ever need to access the original object explicitly use `sector[name]`.
	 */
	name = null

	/**
	 * @constructor
	 * @param {string} obj The name of the object in the sector you want to overtake.
	 */
	/**
	 * @constructor
	 * @param {instance} obj The object you would like to turn into an OObject.
	 */
	constructor(obj) {
		if(typeof obj == "string") {
			name = obj
		} else {
			name = obj.get_name()
		}

		::o[name] <- this
		meta[name] <- {}
	}

	/**
	 * @function has_meta
	 * @param {string} key
	 * @return {bool}
	 * @description Checks if any metadata with the given key exists for this object.
	 */
	function has_meta(key) {
		return key in meta[name]
	}

	/**
	 * @function get_meta
	 * @param {string} key
	 * @param {ANY} default_value If the metadata was not found it will return this instead.
	 * @default default_value null
	 * @return {ANY}
	 * @description Finds metadata with the given key for this object and returns it.
	 */
	function get_meta(key, default_value = null) {
		return has_meta(key) ? meta[name][key] : default_value
	}

	/**
	 * @function set_meta
	 * @param {string} key
	 * @param {ANY} value
	 * @description Sets the metadata for this object with the given key to the given value.
	 * If the key doesnt exist it is created.
	 */
	function set_meta(key, value) {
		meta[name][key] <- value
	}

	function _get(key) {
		if(key in ::get_sector()[name]) {
			if(typeof ::get_sector()[name][key] == "function") {
				return ::get_sector()[name][key].bindenv(::get_sector()[name])
			} else {
				return ::get_sector()[name][key]
			}
		}
		throw null
	}

	function _set(key, value) {
		if(key in ::get_sector()[name])
			return ::get_sector()[name][key] = value
		throw null
	}
}

/**
 * @classend
 */

/**
 * @function init
 * @param {string} obj_prefix The prefix that will be searched when finding the objects.
 * @param {class} obj_class Not the instance, the actual class.
 * @description Finds all objects in the sector with the given prefix and turns them all into OObject of the specified class.
 * The class' constructor's first parameter must be the name of the object it will spawn, otherwise this function wont work with the class.
 */
object.init <- function(obj_prefix, obj_class, ...) {
	foreach(name, obj in sector)
		if(startswith(name, obj_prefix) && !("is_OObject" in obj)) {
			local cls = obj_class.instance()
			cls.constructor.acall([cls, name].extend(vargv))
		}
}
