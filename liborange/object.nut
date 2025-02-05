/**
 * @file Houses the OObject.
 */

local object = add_module("object")

::o <- add_module("o")
get_sector().o <- o

/**
 * @class OBase
 * @description Abstract base class for all OObjects.
 */
class OBase {
	/**
	 * @member {bool} is_oobject
	 * @default is_oobject true
	 * @description This object is an OObject!
	 * When checking for if an object is an OObject please check for if this member exists, not whether its true.
	 */
	is_oobject = true

	/**
	 * @get_object
	 * @returns {instance}
	 * @description Returns the object the OObject has taken over.
	 */
	function get_object() {
		return {}
	}

	function _get(key) {
		if(key in get_object()) {
			if(typeof get_object()[key] == "function") {
				return get_object()[key].bindenv(get_object())
			} else {
				return get_object()[key]
			}
		}
		if(key == "object") return get_object()
		throw null
	}

	function _set(key, value) {
		if(key in get_object())
			return get_object()[key] = value
		throw null
	}
}

/**
 * @classend
 */

/**
 * @class OObject
 * @description The core of liborange's custom scripting.
 * Allows you to "take over" objects in the sector and inject your own custom code and functionality.
 */
class OObject extends OBase {
	/**
	 * @member {string} name
	 * @description The name of the object this OObject has taken over. If you ever need to access the original object explicitly use `sector[name]`.
	 */
	name = null

	/**
	 * @constructor
	 * @param {string} name The name of the object in the sector you want to overtake.
	 */
	constructor(_name) {
		name = _name
		::o[_name] <- this
	}

	function get_object() {
		return ::get_sector()[name]
	}
}

/**
 * @classend
 */

/**
 * @class OAnonObject
 * @description An anonymous version of the OObject that holds a direct reference to the object its taking over.
 */
class OAnonObject extends OBase {
	/**
	 * @member {instance} original
	 * @description The instance this OObject has taken over.
	 */
	original = null

	/**
	 * @constructor
	 * @param {instance} name The object you want to overtake.
	 */
	constructor(obj) {
		original = obj
	}

	function get_object() {
		return original
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
