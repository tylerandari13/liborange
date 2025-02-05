/**
 * @file Houses the OMovingObject, and functions related to object holding.
 * @requires rect
 * @requires object
 * @requires signal
 */
require("rect")
require("object")
require("signal")

local moving_object = add_module("moving_obejct")
local internal = add_module("_moving_obejct")

/**
 * @class OMovingObject
 * @extends OObject
 * @description The parallel to SuperTux's MovingObject. Allows you to use OVectors to manipulate its position.
 */
class OMovingObject extends OObject {
	/**
	 * @function get_pos
	 * @returns {OVector}
	 * @description Returns the object's position as an OVector.
	 */
	function get_pos() {
		return OVector(get_x(), get_y())
	}

	/**
	 * @function get_size
	 * @returns {OVector}
	 * @description Returns the object's size as an OVector.
	 */
	function get_size() {
		return OVector(get_width(), get_height())
	}

	/**
	 * @function get_rect
	 * @returns {ORect}
	 * @description Returns the object's position and size as an ORect.
	 */
	function get_rect() {
		return ORect(get_pos(), get_size())
	}

	/**
	 * @function set_pos
	 * @param {OVector} pos
	 * @description Sets the position to the specified OVector.
	 */
	function set_pos(...) {
		object.set_pos.acall([object].extend(OVector._wrapper(vargv)))
	}

	/**
	 * @function move
	 * @param {OVector} amount
	 * @description Sets the position to the objects current position plus the specified OVector.
	 */
	function move(...) {
		object.move.acall([object].extend(OVector._wrapper(vargv)))
	}
}

/**
 * @classend
 */

internal.held_objects <- []

moving_object.hold <- @(name) internal.held_objects.push(name)
moving_object.stop_holding <- @(name) internal.held_objects.remove(internal.held_objects.find(name))

liborange.signal.process.connect(function() {
	local offset = -64
	foreach(name in internal.held_objects) {
		local object = sector[name]
		object.set_pos(object.get_width() + 32, offset)
		offset -= object.get_height() + 64
	}
})
