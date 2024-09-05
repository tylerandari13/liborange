/**
 * @file Houses the ORect.
 * @requires vector
 */
require("vector")

add_module("rect")

/**
 * @class ORect
 * @description Stores 2 values. A position and a size, and allows you to manipulate them with ease. Useful for collision detection where the game allows for it.
 */
class ORect {
	/**
	 * @member {OVector} position
	 * @description The top-left corner of the ORect.
	 */
	position = null
	/**
	 * @member {OVector} size
	 * @description The size of the ORect.
	 */
	size = null

	/**
	 * @constructor Constructs an empty ORect. The x, y, width, and height are all equal to 0.
	 */
	/**
	 * @constructor Constructs an ORect with the given position and size.
	 * @param {OVector} position The position of the ORect.
	 * @param {OVector} size The size of the ORect.
	 */
	/**
	 * @constructor Constructs the ORect with the given x, y, width, and height.
	 * @param {float} x The x position of this ORect.
	 * @param {float} y The y position of this ORect.
	 * @param {float} w The width of this ORect.
	 * @param {float} h The height of this ORect.
	 */
	constructor(...) {
		switch(vargv.len()) {
			case 0: // ORect()
				position = OVector()
				size = OVector()
			break
			case 2: // ORect(position, size)
				position = vargv[0]
				size = vargv[1]
			break
			case 4: // ORect(x, y, w, h)
				position = OVector(vargv[0], vargv[1])
				size = OVector(vargv[2], vargv[3])
			break
			default:
				throw liborange_texts.error_wrong_param
			break
		}
	}

	/**
	 * @function grow
	 * @param {float} amount The amount to grow the ORect.
	 * @description Grows the ORect by extending each side outward by the amount specified. Pass a negative value to shrink the ORect.
	 */
	function grow(amount) {
		position.x -= amount
		position.y -= amount
		size.x += amount * 2
		size.y += amount * 2
	}

	/**
	 * @function grown
	 * @param {float} amount The amount to grow the new ORect.
	 * @return {ORect}
	 * @description Returns a new ORect grown by extending each side outward by the amount specified. Pass a negative value to shrink the new ORect.
	 */
	function grown(amount) {
		local retval = clone this
		retval.grow(amount)
		return retval
	}

	/**
	 * @function get_left
	 * @return {float}
	 * @description Returns the x position of the left side of this ORect.
	 */
	function get_left() {
		return position.x
	}

	/**
	 * @function get_top
	 * @return {float}
	 * @description Returns the y position of the top side of this ORect.
	 */
	function get_top() {
		return position.y
	}

	/**
	 * @function get_right
	 * @return {float}
	 * @description Returns the x position of the right side of this ORect.
	 */
	function get_right() {
		return get_left() + size.x
	}

	/**
	 * @function get_bottom
	 * @return {float}
	 * @description Returns the y position of the bottom side of this ORect.
	 */
	function get_bottom() {
		return get_top() + size.y
	}

	/**
	 * @function get_center
	 * @return {OVector}
	 * @description Returns the position at the center of this ORect.
	 */
	function get_center() {
		return OVector(position.x + (size.x * 0.5), position.y + (size.y * 0.5))
	}

	function point_is_inside(...) {
		switch(vargv.len()) {
			case 1:
				return vargv[0].x > get_left() &&
					vargv[0].x < get_right() &&
					vargv[0].y > get_top() &&
					vargv[0].y < get_bottom()
			case 2:
				return callee()(OVector(vargv[0], vargv[1]))
			default:
				throw liborange_texts.error_wrong_param
			break
		}
	}

	/**
	 * @function get_center
	 * @return {OVector}
	 * @description Returns whether the given ORect.
	 */
	//TODO: make it so rects bigger than other rects are still detected
	function overlaps(...) {
		switch(vargv.len()) {
			case 1: // overlaps(rect)
				return point_is_inside(vargv[0].position) ||
					point_is_inside(vargv[0].position + vargv[0].size) ||
					point_is_inside(vargv[0].position + OVector(0, vargv[0].size.y)) ||
					point_is_inside(vargv[0].position + OVector(vargv[0].size.x, 0)) ||
					point_is_inside(vargv[0].get_center())
			case 2: // overlaps(position, size)
				return callee()(ORect(vargv[0], vargv[1]))
			case 4: // overlaps(x, y, w, h)
				return callee()(ORect(vargv[0], vargv[1], vargv[2], vargv[3]))
			default:
				throw liborange_texts.error_wrong_param
			break
		}
	}

	function _add(other) {
		if(typeof other == "ORect") {
			return ORect(
				position.x + other.position.x,
				position.y + other.position.y,
				size.x + other.size.x,
				size.y + other.size.y
			)
		} else {
			throw "Cannot add \"" + typeof other + "\" to an ORect. Please only add ORects to ORects."
		}
	}

	function _sub(other) {
		if(typeof other == "ORect") {
			return ORect(
				position.x - other.position.x,
				position.y - other.position.y,
				size.x - other.size.x,
				size.y - other.size.y
			)
		} else {
			throw "Cannot subtract \"" + typeof other + "\" from an ORect. Please only subtract ORects from ORects."
		}
	}

	function _mul(other) {
		if(typeof other == "ORect") {
			return ORect(
				position.x * other.position.x,
				position.y * other.position.y,
				size.x * other.size.x,
				size.y * other.size.y
			)
		} else {
			throw "Cannot multiply \"" + typeof other + "\" with an ORect. Please only multiply ORects with ORects."
		}
	}

	function _div(other) {
		if(typeof other == "ORect") {
			return ORect(
				position.x / other.position.x,
				position.y / other.position.y,
				size.x / other.size.x,
				size.y / other.size.y
			)
		} else {
			throw "Cannot divide \"" + typeof other + "\" by an ORect. Please only divide ORects by ORects."
		}
	}

	function modulo(other) {
		if(typeof other == "ORect") {
			return ORect(
				position.x % other.position.x,
				position.y % other.position.y,
				size.x % other.size.x,
				size.y % other.size.y
			)
		} else {
			throw "Cannot perform modulo on \"" + typeof other + "\" and an ORect. Please only perform modulo on ORects and ORects."
		}
	}

	function _unm() {
		return ORect(-position.x, -position.y, -size.x, -size.y)
	}

	function _typeof() {
		return "ORect"
	}

	function _cloned(original) {
		position = OVector(original.position.x, original.position.y)
		size = OVector(original.size.x, original.size.y)
	}

	function _tostring() {
		return "ORect(" + position.x + ", " + position.y + ", " + size.x + ", " + size.y + ")"
	}
}

/**
 * @classend
 */
