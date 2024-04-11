// containers

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

	function distance_to(...) {
		switch(vargv.len()) {
			case 1: // distance_to(other)
				return api_table().distance_rom_point_to_point(this, vargv[0])
			break
			case 2: // distance_to(other_x, other_y)
				return api_table().distance_rom_point_to_point(x, y, vargv[0], vargv[1])
			break
		}
	}

	function _add(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return OVector(x + other, y + other)
		}
		return OVector(x + other.x, x + other.y)
	}

	function _sub(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return OVector(x - other, y - other)
		}
		return OVector(x - other.x, x - other.y)
	}

	function _mul(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return OVector(x * other, y * other)
		}
		return OVector(x * other.x, x * other.y)
	}

	function _div(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return OVector(x / other, y / other)
		}
		return OVector(x / other.x, x / other.y)
	}

	function _modulo(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return OVector(x % other, y % other)
		}
		return OVector(x % other.x, x % other.y)
	}

	function _unm() {
		return OVector(-x, -y)
	}

	function _typeof() {
		return "vector"
	}

	function _cmp(other) {
		return (x + y) * 0.5 <=> (other.x + other.y) * 0.5
	}

	function _cloned(original) {
		x = original.x
		y = original.y
	}

	function _tostring() {
		return "Vector(" + x + ", " + y + ")"
	}
}

class ORect {
	position = null
	size = null

	constructor(...) {
		switch(vargv.len()) {
			case 0: // ORect()
				position = OVector()
				size = OVector()
			break
			case 2: // ORect(position = OVector(), size = OVector())
				position = vargv[0]
				size = vargv[1]
			break
			case 4: // ORect(x = 0, y = 0, w = 0, h = 0)
				position = OVector(vargv[0], vargv[1])
				size = OVector(vargv[2], vargv[3])
			break
			default:
				throw "wrong number of parameters"
			break
		}
	}

	function grow(border) {
		if(size.x + border * 2 < 0 || size.y + border * 2 < 0) return

		position -= border
		size += border
	}

	function grown(border) {
		local retval = clone this
		retval.grow(border)
		return retval
	}

	function left() {
		return position.x
	}

	function down() {
		return position.y + size.y
	}

	function up() {
		return position.y
	}

	function right() {
		return position.x + size.x
	}

	function _add(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return ORect(position + other, size + other)
		}
		return ORect(position + other.position, size + other.size)
	}

	function _sub(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return ORect(position - other, size - other)
		}
		return ORect(position - other.position, size - other.size)
	}

	function _mul(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return ORect(position * other, size * other)
		}
		return ORect(position * other.position, size * other.size)
	}

	function _div(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return ORect(position / other, size / other)
		}
		return ORect(position / other.position, size / other.size)
	}

	function _modulo(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return ORect(position % other, size % other)
		}
		return ORect(position % other.position, size % other.size)
	}

	function _typeof() {
		return "rect"
	}

	function _unm() {
		return ORect(-position, -size)
	}

	function _cmp(other) {
		return (position + size) * 0.5 <=> (other.position + other.size) * 0.5
	}

	function _cloned(original) {
		position = original.position
		size = original.size
	}

	function _tostring() {
		return "Rect(" + position.x + ", " + position.y + ", " + size.x + ", " + size.y + ")"
	}
}

class OColor {
	r = null
	g = null
	b = null
	a = null

	constructor(...) {
		switch(vargv.len()) {
			case 0: // OColor()
				r = 0
				g = 0
				b = 0
				a = 1
			break
			case 3: // OColor(r, g, b)
				r = vargv[0]
				g = vargv[1]
				b = vargv[2]
				a = 1
			break
			case 4: // OColor(r, g, b, a)
				r = vargv[0]
				g = vargv[1]
				b = vargv[2]
				a = vargv[3]
			break
			default:
				throw "wrong number of parameters"
			break
		}
	}

	function is_valid() {
		return r > 0 && r < 1 &&
				g > 0 && g < 1 &&
				b > 0 && b < 1 &&
				a > 0 && a < 1
	}

	function validate() {
		if(r < 0) r = 0
		if(r > 1) r = 1
		if(g < 0) g = 0
		if(g > 1) g = 1
		if(b < 0) b = 0
		if(b > 1) b = 1
		if(a < 0) a = 0
		if(a > 1) a = 1
	}

	function validated() {
		local retval = clone this
		retval.validate()
		return retval
	}

	function greyscale() {
		local averaged = (r + g + b) / 3
		r = averaged
		g = averaged
		b = averaged
	}

	function greyscaled() {
		local retval = clone this
		retval.greyscale()
		return retval
	}

	/*
	Basically:
		- convert the current RGB values to HSV
		- shift the H in the new values
		- convert back to RGB
	*/
	/*function hue_shift(degrees) {
		// convert the current RGB values to HSV
		local h
		local s
		local v

		local max = api_table().max(r, g, b)
		local delta = max - api_table().min(r, g, b)

		if(delta > 0) {
			if(max == r) {
				h = 60 * ((g - b) / delta) % 6
			} else if(max == g) {
				h = 60 * (((b - r) / delta) + 2)
			} else if(max == b) {
				h = 60 * (((r - g) / delta) + 4)
			}

			if(max > 0) {
				s = delta / max
			} else {
				s = 0
			}

		} else {
			h = 0
			s = 0
		}

		v = max

		if(h < 0) {
			h = 360 + h
		}

		// shift the H in the new values
		h += degrees

		// convert back to RGB
		local c = v * s // Chroma
		local h_prime = h / (60.0 % 6)
		local x = c * (1 - fabs((h_prime % 2) - 1))
		local m = v - c

		if(0 <= h_prime && h_prime < 1) {
			r = c
			g = x
			b = 0
		} else if(1 <= h_prime && h_prime < 2) {
			r = x
			g = c
			b = 0
		} else if(2 <= h_prime && h_prime < 3) {
			r = 0
			g = c
			b = x
		} else if(3 <= h_prime && h_prime < 4) {
			r = 0
			g = x
			b = c
		} else if(4 <= h_prime && h_prime < 5) {
			r = x
			g = 0
			b = c
		} else if(5 <= h_prime && h_prime < 6) {
			r = c
			g = 0
			b = x
		} else {
			r = 0
			g = 0
			b = 0
		}

		r += m
		g += m
		b += m
	}*/

	function _add(other) {
		return OColor(r + other.r, g + other.g, b + other.b, a + other.a)
	}

	function _sub(other) {
		return OColor(r - other.r, g - other.g, b - other.b, a - other.a)
	}

	function _mul(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return OColor(r * other, g * other, b * other, a * other)
		}
		return OColor(r * other.r, g * other.g, b * other.b, a * other.a)
	}

	function _div(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return OColor(r / other, g / other, b / other, a / other)
		}
		return OColor(r / other.r, g / other.g, b / other.b, a / other.a)
	}

	function _modulo(other) {
		if(type(other) == "integer" || type(other) == "float") {
			return OColor(r % other, g % other, b % other, a % other)
		}
		return OColor(r % other.r, g % other.g, b % other.b, a % other.a)
	}

	function _typeof() {
		return "color"
	}

	function _unm() {
		return OColor(-r, -g, -b, -a)
	}

	function _cmp(other) {
		return (r + g + b + a) * 0.25 <=> (other.r + other.g + other.b + other.a) * 0.25
	}

	function _cloned(original) {
		r = original.r
		g = original.g
		b = original.b
		a = original.a
	}

	function _tostring() {
		return "Color(" + r + ", " + g + ", " + b + ", " + a + ")"
	}
}

api_table().Vector <- OVector
api_table().Rect <- ORect
api_table().Color <- OColor

// helper functions

api_table().parse_color <- function(args, func_name) {
	switch(args.len()) {
		case 1:
			if(type(args[0]) == "string") { // func_name("COLOR_NAME")
				object[func_name](api_table().colors[args[0]].r,
									api_table().colors[args[0]].g,
									api_table().colors[args[0]].b,
									api_table().colors[args[0]].a)
			} else { // func_name(OColor(...))
				args[0].validate()
				object[func_name](args[0].r, args[0].g, args[0].b, args[0].a)
			}
		break
		case 3: // func_name(r, g, b)
			object[func_name](args[0], args[1], args[2], 1)
		break
		case 4: // func_name(r, g, b, a)
			object[func_name](args[0], args[1], args[2], args[3])
		break
		default:
			throw "wrong number of parameters"
		break
	}
}

api_table().parse_color_no_alpha <- function(args, func_name) {
	switch(args.len()) {
		case 1:
			if(type(args[0]) == "string") { // func_name("COLOR_NAME")
				object[func_name](api_table().colors[args[0]].r,
									api_table().colors[args[0]].g,
									api_table().colors[args[0]].b)
			} else { // func_name(OColor(...))
				args[0].validate()
				object[func_name](args[0].r, args[0].g, args[0].b)
			}
		break
		case 3: // func_name(r, g, b)
			object[func_name](args[0], args[1], args[2])
		break
		default:
			throw "wrong number of parameters"
		break
	}
}
