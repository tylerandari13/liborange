class OScriptedObject extends OObject {
	bound_objects = {}

	function bind_object(object, ...) {
		local offset
		switch(vargv.len()) {
			case 1:
				offset = vargv[0]
			break
			case 2:
				offset = OVector(vargv[0], vargv[1])
			break
			default:
				throw "wrong number of parameters"
			break
		}
		bound_objects[object] <- offset
	}

	function init_bound_objects() {
		api_table().get_callback("process").connect(function() {
			foreach(i, v in bound_objects) {
				i.set_pos(get_pos_x() + v.x, get_pos_y() + v.y)
				set_pos(i.get_pos_x() - v.x, i.get_pos_y() - v.y)
			}
		}.bindenv(this))
		api_table().init_signals()
	}

	function get_pos() {
		return OVector(get_x(), get_y())
	}

	function set_pos(...) {
		switch(vargv.len()) {
			case 1:
				object.set_pos(vargv[0].x, vargv[0].y)
			break
			case 2:
				object.set_pos(vargv[0], vargv[1])
			break
			default:
				throw "wrong number of parameters"
			break
		}
	}
}
