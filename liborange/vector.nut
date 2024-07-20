/**
 * @file Houses the OVector.
 */
add_module("vector")

/**
 * @class OVector
 * @classdesc Stores 2 values, an x and a y, and allows you to manipulate them using vector math.
 * On OMovingObjects you are able to pass in OVectors instead of the usual 2 x and y parameters, for convenience.
 */
class OVector {
	/**
	 * @member {number} x
	 * @description The x value of this OVector.
	 */
	x = null
	/**
	 * @member {number} y
	 * @description The y value of this OVector.
	 */
	y = null

	/**
	 * @constructor Constructs an empty OVector. The x and y are both 0.
	 */
	/**
	 * @constructor Constructs an OVector with the given x and y.
	 * @param {number} x The x value of this OVector.
	 * @param {number} y The y value of this OVector.
	 */
	constructor(...) {
		switch(vargv.len()) {
			case 0: // OVector()
				x = 0
				y = 0
			break
			case 2: // OVector(x, y)
				x = vargv[0]
				y = vargv[1]
			break
			default:
				throw "wrong number of parameters"
			break
		}
	}

	/**
	 * @function len
	 * @return {number}
	 * @description Returns the length of the OVector by squaring the x and y, adding the squared numbers together, and returning the square root.
	 */
	function len() {
		return sqrt((x * x) + (y * y))
	}

	/**
	 * @function normalize
	 * @description Normalizes the vector by taking the x and y and deviding them by the vectors length.
	 */
	function normalize() {
		x = x / len()
		y = y / len()
	}

	/**
	 * @function normalized
	 * @return {OVector}
	 */
	function normalized() {
		local retval = clone this
		retval.normalize()
		return retval
	}

	function _add(other) {
		if(typeof other == "OVector") {
			return OVector(x + other.x, y + other.y)
		} else {
			throw "Cannot add \"" + typeof other + "\" to an OVector. Please only add OVectors to OVectors."
		}
	}

	function _sub(other) {
		if(typeof other == "OVector") {
			return OVector(x - other.x, y - other.y)
		} else {
			throw "Cannot subtract \"" + typeof other + "\" from an OVector. Please only subtract OVectors from OVectors."
		}
	}

	function _mul(other) {
		if(typeof other == "OVector") {
			return OVector(x * other.x, y * other.y)
		} else if(type(other) == "integer" || type(other) == "float") {
			return OVector(x * other, y * other)
		} else {
			throw "Cannot multiply \"" + typeof other + "\" with an OVector. Please only multiply OVectors with OVectors and numbers."
		}
	}

	function _div(other) {
		if(typeof other == "OVector") {
			return OVector(x / other.x, y / other.y)
		} else if(type(other) == "integer" || type(other) == "float") {
			return OVector(x / other, y / other)
		} else {
			throw "Cannot divide \"" + typeof other + "\" by an OVector. Please only multiply OVectors by OVectors and numbers."
		}
	}

	function modulo(other) {
		if(typeof other == "OVector") {
			return OVector(x % other.x, y % other.y)
		} else if(type(other) == "integer" || type(other) == "float") {
			return OVector(x % other, y % other)
		} else {
			throw "Cannot perform modulo on \"" + typeof other + "\" and an OVector. Please only perform modulo on OVectors using OVectors and numbers."
		}
	}

	function _unm() {
		return OVector(-x, -y)
	}

	function _typeof() {
		return "OVector"
	}

	function _cloned(original) {
		x = original.x
		y = original.y
	}

	function _tostring() {
		return "OVector(" + x + ", " + y + ")"
	}
}
/**
 * @function length
 * @see len
 */
OVector.length <- OVector.len

/**
 * @classend
 */

add_module("vector", {
	/**
	 * @member {OVector} ZERO
	 * @description An empty OVector.
	 */
	ZERO = OVector(),
	/**
	 * @member {OVector} UP
	 * @description an Ovector facing up.
	 */
	UP = OVector(0, -1),
	/**
	 * @member {OVector} DOWN
	 * @description an Ovector facing down.
	 */
	DOWN = OVector(0, 1),
	/**
	 * @member {OVector} LEFT
	 * @description an Ovector facing left.
	 */
	LEFT = OVector(-1, 0),
	/**
	 * @member {OVector} RIGHT
	 * @description an Ovector facing right.
	 */
	RIGHT = OVector(1, 0)
})
