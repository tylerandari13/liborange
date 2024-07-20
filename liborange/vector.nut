add_module("vector")

class OVector {
	x = null
	y = null

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

	function len() {
		return sqrt((x * x) + (y * y))
	}

	function normalize() {
		x = x / len()
		y = y / len()
	}

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
OVector.length <- OVector.len

add_module("vector", {
	ZERO = OVector(),
	UP = OVector(0, -1),
	DOWN = OVector(0, 1),
	LEFT = OVector(-1, 0),
	RIGHT = OVector(1, 0)
})
