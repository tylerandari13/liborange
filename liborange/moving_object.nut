require("vector")
require("rect")
require("object")
add_module("moving_obejct")

class OMovingObject extends OObject {
	function get_pos() {
		return OVector(get_x(), get_y())
	}

	function get_size() {
		return OVector(get_width(), get_height())
	}

	function get_rect() {
		return ORect(get_pos(), get_size())
	}

	function set_pos(...) {
		switch(vargv.len()) {
			case 1: // set_pos(pos)
				return object.set_pos(vargv[0].x, vargv[0].y)
			case 2: // set_pos(x, y)
				return object.set_pos(vargv[0], vargv[1])
			default:
				throw "wrong number of parameters"
		}
	}

	function move(...) {
		switch(vargv.len()) {
			case 1: // move(pos)
				return object.set_pos(vargv[0].x, vargv[0].y)
			case 2: // move(x, y)
				return object.set_pos(vargv[0], vargv[1])
			default:
				throw "wrong number of parameters"
		}
	}
}
