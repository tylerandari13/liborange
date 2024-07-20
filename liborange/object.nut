/**
 * @file Houses the OObject.
 */

add_module("object")

local meta = {}

/**
 * @class OObject
 * @classdesc The core of liborange's custom scripting.
 * Allows you to "take over" objects in the sector and inject your own custom code and functionality.
 */
class OObject {
	/**
	 * @member {bool} is_oobject
	 * @default true
	 * @description This object is an OObject!
	 * When checking for if an object is an OObject please check for if this member exists, not whether its true.
	 */
	is_oobject = true

	/**
	 * @member {instance} object
	 * @description The raw object this OObject has taken over. If you ever need to access the original object explicitly its right here.
	 */
	object = null

	/**
	 * @constructor
	 * @param {string} obj The name of the object in the sector you want to overtake.
	 */
	/**
	 * @constructor
	 * @param {instance} obj The object you would like to Tuen into an OObject.
	 */
	constructor(obj) {
		meta[this] <- {}

		if(type(obj) == "string") {
			object = get_sector()[obj]
			get_sector()[obj] = this
		} else {
			object = obj
		}
	}

	/**
	 * @function has_meta
	 * @param {string} key
	 * @return {bool}
	 * @description Checks if any metadata with the given key exists for this object.
	 */
	function has_meta(key) {
		return key in meta[this]
	}

	/**
	 * @function get_meta
	 * @param {string} key
	 * @param {ANY} default_value If the metadata was not found it will return this instead.
	 * @default null
	 * @return {ANY}
	 * @description Finds metadata with the given key for this object and returns it.
	 */
	function get_meta(key, default_value = null) {
		return has_meta(key) ? meta[this][key] : default_value
	}

	/**
	 * @function set_meta
	 * @param {string} key
	 * @param {ANY} value
	 * @description Sets the metadata for this object with the given key to the given value.
	 * If the key doesnt exist it is created.
	 */
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

/**
 * @classend
 */
