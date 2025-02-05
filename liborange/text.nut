/**
 * @file Houses the OText, and functions related to text maniplulation.
 * @requires rect
 * @requires object
 * @requires signal
 */

require("rect")
require("color")
require("object")
require("signal")

local text = add_module("text")

class OTextObject extends OAnonObject {

	constructor(obj = null) {
		if(obj == null) {
			base.constructor(::TextObject())
		} else {
			base.constructor(obj)
		}
	}

	/**
	 * @function get_pos
	 * @returns {OVector}
	 * @description Returns the object's position as an OVector.
	 */
	function get_pos() {
		return OVector(get_x(), get_y())
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
	 * @function set_anchor_offset
	 * @param {OVector} pos
	 * @description Sets the anchor offset to the specified OVector.
	 */
	function set_anchor_offset(...) {
		object.set_anchor_offset.acall([object].extend(OVector._wrapper(vargv)))
	}

	function set_front_fill_color(...) {
		object.set_front_fill_color.acall([object].extend(OColor._wrapper(vargv)))
	}

	function set_back_fill_color(...) {
		object.set_back_fill_color.acall([object].extend(OColor._wrapper(vargv)))
	}

	function set_text_color(...) {
		object.set_text_color.acall([object].extend(OColor._wrapper(vargv)))
	}
}
