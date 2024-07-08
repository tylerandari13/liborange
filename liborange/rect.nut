require("vector")
add_module("rect")

class ORect {
	position = null
	size = null

	constructor(...) {
		::print(vargv.len())
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
		if((typeof other) == "ORect") {
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
		if((typeof other) == "ORect") {
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
		if((typeof other) == "ORect") {
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
		if((typeof other) == "ORect") {
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
		if((typeof other) == "ORect") {
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
