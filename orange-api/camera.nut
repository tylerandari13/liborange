import("orange-api/orange_api_util.nut")

enum camera_mode {
	MANUAL
	NORMAL
}

class OCamera extends OObject {
	mode = camera_mode.NORMAL

	default_drag = 0.01

	x_bounds = 150 // How far the camera goes in front of Tux. Where can i find this value in the source?
	x_speed = 1

	y_bounds = 4

	drag = null

	target = sector.Tux

	thread = null

	constructor(name) {
		base.constructor(name)
		reset_drag()
		object.set_mode("manual")
		thread = newthread(thread_func)
		thread.call(this)
	}

	function thread_func(camera) {
		local cur_x = 0
		local cur_y = camera.target.get_y() - (camera.get_height() * 0.5) + 16
		local y_bounds = camera.get_height() / camera.y_bounds
		while(true) {
			switch(camera.mode) {
				case camera_mode.NORMAL:
					camera.object.scroll_to(camera.target.get_x() - (camera.get_width() * 0.5) + 16 + cur_x, cur_y, camera.drag)

					if(camera.target.get_velocity_x() != 0) {
						cur_x += camera.x_speed * camera.target.get_velocity_x() / 125
						if(cur_x > camera.x_bounds) cur_x = camera.x_bounds
						if(cur_x < camera.x_bounds * -1) cur_x = camera.x_bounds * -1
					}

					if(camera.get_y() + y_bounds > camera.target.get_y()) cur_y = camera.target.get_y() - y_bounds
					if(camera.get_y() + camera.get_height() - y_bounds < camera.target.get_y()) cur_y = camera.target.get_y() + y_bounds - camera.get_height()
				break
			}
			wait(0.01)
		}
	}

	// overridden functions

	function set_mode(_mode) {
		if(_mode.tolower() == "normal") mode = camera_mode.NORMAL
		if(_mode.tolower() == "manual") mode = camera_mode.MANUAL
	}

	function set_pos(x, y) {
		mode = camera_mode.MANUAL
		object.set_pos(x, y)
	}

	function move(x, y) set_pos(get_x() + x, get_y() + y)

	function scroll_to(x, y, scrolltime) {
		mode = camera_mode.MANUAL
		object.scroll_to(x, y, scrolltime)
	}

	// OCamera specific functions

	function get_mode() switch (mode) {
		case camera_mode.NORMAL:
			return "normal"
		case camera_mode.MANUAL:
			return "manual"
		default:
			return "unknown"
	}

	function set_target(_target) {
		if(("is_OObject" in _target)) {
			target = _target
		} else {
			target = OObject(_target)
		}
	}

	function scale_to_objects(object_a, object_b, time) {
		if(!("is_OObject" in object_a)) object_a = OObject(object_a)
		if(!("is_OObject" in object_b)) object_b = OObject(object_b)
		// temp, come back to this
	}

	function set_drag(_drag) drag = _drag * 0.01
	function get_drag() return drag * 100
	function reset_drag() drag = default_drag

	function get_width() return get_screen_width()
	function get_height() return get_screen_height()
}

api_table().Camera <- OCamera

api_table().init_camera <- function() OCamera("Camera")
