/** \class OObject oobject.nut "oobject.nut"
 * @class OObject
 * @summary Base class for everything that uses the overwriting capabilities of liborange.
 *
 * If `obj` is a string it will overwrite `sector[obj]` with the new OObject. For example if you had a scripted object named `scripted_object0` in the sector you could call `OObject("scripted_object0")`. Now `scripted_object0` is an OObject.
 * If `obj` is an instance it wont overwrite it in the sector, but will still give you an OObject like how a normal class works. For example if you had a scripted object named `scripted_object0` in the sector you could call `local object = OObject(sector.scripted_object0)`. `scripted_object0` is not an OObject in the sector but `object` is.
 */
class OObject {
	/**
	 * @property {bool} is_OObject This means that the object is an OObject. When checking whether an instance is an oobject please use `if("is_OObject" in object)`.
	 */
	static is_OObject = true

	/**
	 * @property {instance} object A reference to the original object that was overtaken.
	 */
	object = null
	/**
	 * @property {string} object_name The name of the OObject. It can be gotten using get_name(). If the original object had a `get_name()` function it will be whatever that returns, else it will be whatever `obj` was.
	 */
	object_name = ""
	/**
	 * @property {table} odata Extra data stored in the OObject. Data is usually set via metamethods, and not by editing the table directly.
	 */
	odata = null

	// sector_ref = null

	/**
	 * @function constructor
	 * @param {string|instance} obj The object to be initialized by the OObject.
 	*/
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

	/**
	 * @function display Wrapper for SuperTuxs `display()` function. For convenience.
	 * @param {ANY} ANY The value to be displayed.
	 */
	function display(ANY) ::display(ANY)
	/**
	 * @function display Wrapper for SuperTuxs `print()` function. For convenience.
	 * @param {ANY} object The value to be printed.
	 */
	function print(object) ::print(object)

	/**
	 * @function set_everything Allows for setting a lot of `set_*()` functions at once.
	 * @param {table} stuff The table of stuff. Example: `{color = [0, 0, 0, 0]}`
	 * @deprecated This is a stupid function. Please dont use it.
	 */
	function set_everything(stuff) foreach(i, v in stuff) if("set_" + i in this) this["set_" + i].acall([object].extend(type(v) == "array" ? v : [v]))

	// no `get_everything()` because it would be kinda complicated considering i cant iterate over a class instance

	// function in_current_sector() return sector_ref != null && sector_ref == ::get_sector()

	/**
	 * @function get_name Gets the name of the OObject. (Basically returns object_name)
	 */
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
