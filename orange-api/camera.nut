import("orange-api/orange_api_util.nut")

class OCamera extends OObject {
	mode = "normal"

	x_bounds = 150 // How far the camera goes in front of Tux. Where can i find this value in the source?
	x_speed = 2

	y_bounds = 0

	thread = null

	constructor(name) {
		base.constructor(name)
		object.set_mode("manual")
		thread = newthread(thread_func)
		thread.call(this)
	}

	function thread_func(camera) {
		local cur_x = 0
		local cur_y = sector.Tux.get_y() - (camera.get_height() * 0.5) + 16
		camera.y_bounds = camera.get_height() / 4
		while(true) {
			if(camera.get_mode() == "normal") {
				camera.set_pos(sector.Tux.get_x() - (camera.get_width() * 0.5) + 16 + cur_x, cur_y)
				if(sector.Tux.get_velocity_x() != 0) {
					cur_x += camera.x_speed * sector.Tux.get_velocity_x() / 250
				}
				if(cur_x > camera.x_bounds) cur_x = camera.x_bounds
				if(cur_x < camera.x_bounds * -1) cur_x = camera.x_bounds * -1

				if(camera.get_y() + camera.y_bounds > sector.Tux.get_y()) cur_y = sector.Tux.get_y() - camera.y_bounds
				if(camera.get_y() + camera.get_height() - camera.y_bounds < sector.Tux.get_y()) {
					//display(ii)
					//ii++
					cur_y = sector.Tux.get_y() + camera.y_bounds - camera.get_height()
				}
			}
			wait(0.01)
		}
	}

	function set_mode(_mode) if(_mode == "normal" || _mode == "manual") mode = _mode
	function get_mode() return mode

	function get_width() return get_screen_width()
	function get_height() return get_screen_height()
}

api_table().Camera <- OCamera

api_table().init_camera <- function() OCamera("Camera")
