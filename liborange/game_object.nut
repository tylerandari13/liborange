/**
 * @file Houses the OGameObject.
 * @requires sexp
 */
require("sexp")

add_module("game_object")

local RAW = rand() + "" + rand()

/**
 * @class OGameObject
 * @description Not to be confused with the OObject, the OGameObject is an alternative to `sector.settings.add_object()`
 * that allows for spawning in game objects with ease.
 */
class OGameObject {
	/**
	 * @member {table} data
	 * @description The data for this game object. Prefer using the functions or metamethods for setting data in this table.
	 */
	data = null

	//TODO: document where a list of objects can be found.
	/**
	 * @constructor Constructs an OGameObject.
	 * @param {string} class_name The class name of the object the OGameObject will spawn.
	 */
	constructor(class_name) {
		data = {
			class_name = class_name
			name = ""
			x = 0
			y = 0
			direction = "auto"
		}
	}

	/**
	 * @function add_data
	 * @param {string} item The item you want to set the data of.
	 * @param {ANY} data
	 * @description Adds data to the object. Check the objects in the level files to see what can be applied.
	 */
	function add_data(item, _data) {
		data[item] <- _data
	}

	/**
	 * @function get_data
	 * @param {string} item
	 * @description Gets data from the object.
	 */
	function get_data(item) {
		return data[item]
	}

	/**
	 * @function get_data
	 * @param {string} item
	 * @description Gets data from the object.
	 */
	function has_data(item) {
		return item in data
	}

	/**
	 * @function remove_data
	 * @param {string} item
	 * @description Removes data from the object.
	 * Can also remove data added with `add_raw_data` by passing in the data you originally passed.
	 */
	function remove_data(item) {
		delete data[item]
	}

	/**
	 * @function add_raw_data
	 * @param {string} data
	 * @description Adds data in the form of raw s-expression. An example of such would be `(color 1 0 1 1)`.
	 */
	function add_raw_data(_data) {
		data[_data] <- RAW
	}

	/**
	 * @function initialize
	 * @param {table} overrides
	 * @param {bool} return_object
	 * @default return_object true
	 * @description Adds data in the form of raw s-expression. An example of such would be `(color 1 0 1 1)`.
	 */
	function initialize(overrides = {}, return_object = true) {
		local actual_data = {}
		foreach(i, v in data) actual_data[i] <- v
		foreach(i, v in overrides) actual_data[i] <- v
		local data_array = [""]
		foreach(i, v in actual_data) data_array.push([i, v])
		local sexp_data = ::get_sector().liborange.sexp.from_array(data_array).slice(2, -1)

		local unexposed = (actual_data.name == "" || actual_data.name == null)
		if(unexposed) actual_data.name = "unexposeme-" + ::rand()

		::get_sector().settings.add_object(actual_data.class_name, actual_data.name, actual_data.x, actual_data.y, actual_data.direction, sexp_data)

		if(!return_object) return
		while(!(actual_data.name in ::get_sector())) ::wait(0)

		local obj = ::get_sector()[actual_data.name]
		if(unexposed) ::get_sector()[actual_data.name] = null // cant delete the key because itll throw errors
		return obj
	}

	function _get(key) {
		return get_data(key)
	}

	function _set(key, value) {
		return add_data(key, value)
	}
}

/**
 * @classend
 */
