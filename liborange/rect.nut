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
	 * @param {number} x The x position of this ORect.
	 * @param {number} y The y position of this ORect.
	 * @param {number} w The width of this ORect.
	 * @param {number} h The height of this ORect.
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
				throw "wrong number of parameters"
			break
		}
	}

	/**
	 * @function grow
	 * @param {number} amount The amount to grow the ORect.
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
	 * @param {number} amount The amount to grow the new ORect.
	 * @return {ORect}
	 * @description Returns a new ORect grown by extending each side outward by the amount specified. Pass a negative value to shrink the new ORect.
	 */
	function grown(amount) {
		local retval = clone this
		retval.grow(amount)
		return retval
	}

	function _get(key) {
		switch(key) {
			case "x":
			case "left":
				return position.x
			case "y":
			case "top":
				return position.y
			case "w":
				return size.x
			case "h":
				return size.y
			case "right":
				return position.x + size.x
			case "bottom":
				return position.y + size.y
			default:
				throw null
		}
	}

	// TODO: Implement setters for left, right, top, and bottom.
	function _set(key, value) {
		switch(key) {
			case "x":
				return position.x = value
			case "y":
				return position.y = value
			case "w":
				return size.x = value
			case "h":
				return size.y = value
			default:
				throw null
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
