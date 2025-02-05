/**
 * @file Houses the OCamera.
 * @requires rect
 * @requires object
 */
require("rect")
require("object")

add_module("camera")

class OCamera extends OObject {
	/**
	 * @member {string} mode
	 * @description The mode the camera is currently in. Can be "normal", "manual", or "target".
	 */
	mode = "normal"

	/**
	 * @member {instance} target
	 * @description The cameras current target. If target is null then the camera is targetting Tux.
	 */
	target = null

	/**
	 * @member {float} drag
	 * @description The cameras current drag. Only used if the camera is in target mode.
	 */
	drag = 0.1

	/**
	 * @constructor Constructs the OCamera. Because there can only be one camera it will always initialize on that one.
	 */
	constructor() {
		base.constructor("Camera")
		liborange.signal.process.connect(process.bindenv(this))
	}

	/**
	 * @function process
	 * @description The process function. Used internally.
	 */
	function process() {
		if(mode == "manual" || target == null) return
		scroll_to(
			target.get_x() - (get_width() * 0.5) + (target.get_width() * 0.5),
			target.get_y() - (get_height() * 0.5) + (target.get_width() * 0.5),
			drag
		)
	}

	/**
	 * @function set_target
	 * @param {instance} tar The target you want the camera to focus on.
	 * @description Makes the camera focus on the given target. Best used with low drag values.
	 * To reset the mode pass in `null` as the target.
	 */
	function set_target(tar) {
		target = tar
	}

	function set_mode(_mode) {
		mode = _mode.tolower()
		sector[name].set_mode(mode)
	}

	/**
	 * @function get_mode
	 * @returns {string} Can be "normal" or "manual".
	 * @description Returns the mode the camera's currently in.
	 */
	function get_mode() {
		return mode
	}

	/**
	 * @function get_pos
	 * @returns {OVector}
	 * @description Returns the camera's position as an OVector.
	 */
	function get_pos() {
		return OVector(get_x(), get_y())
	}

	/**
	 * @function get_size
	 * @returns {OVector}
	 * @description Returns the camera's size as an OVector.
	 */
	function get_size() {
		return OVector(get_width(), get_height())
	}

	/**
	 * @function get_rect
	 * @returns {ORect}
	 * @description Returns the camera's position and size as an ORect.
	 */
	function get_rect() {
		return ORect(get_pos(), get_size())
	}

	/**
	 * @function set_pos
	 * @param {OVector} pos
	 * @description Sets the camera's position to the specified OVector.
	 */
	function set_pos(...) {
		object.set_pos.acall([object].extend(OVector._wrapper(vargv)))
	}

	/**
	 * @function move
	 * @param {OVector} amount
	 * @description Sets the position to the camera's current position plus the specified OVector.
	 */
	function move(...) {
		object.move.acall([object].extend(OVector._wrapper(vargv)))
	}

	function get_width() { return get_screen_width() }
	function get_height() { return get_screen_height() }
}
