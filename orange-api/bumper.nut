import("orange-api/orange_api_util.nut")

class OBumper extends OObject {
	direction = null
	speed_x = 0
	speed_y = 0

	constructor(obj, dir = "right", x = 700, y = -450) {
		base.constructor(obj)
		direction = dir.tolower()
		speed_x = x
        speed_y = y

		object.set_action("normal-" + direction)
	}

	function press() {
		sector.Tux.deactivate()
		wait(0.01)
		local y_speed = (
			sector.Tux.get_action().find("slide-")
			|| sector.Tux.get_action().find("swim-")
			|| sector.Tux.get_action().find("boost-")
			|| sector.Tux.get_action().find("float-")
		) ? sector.Tux.get_velocity_x() : speed_y
		sector.Tux.set_velocity((direction == "right" ? speed_x : speed_x * -1), y_speed)
		play_sound("sounds/trampoline.wav")
		object.set_action("swinging-" + direction)
		while(sector.Tux.get_velocity_y() < 0) {
			if(sector.Tux.get_input_held("left")) sector.Tux.set_dir(false)
			if(sector.Tux.get_input_held("right")) sector.Tux.set_dir(true)
			wait(0.01)
		}
		object.set_action("normal-" + direction)
		sector.Tux.activate()
	}

	function force_press() press() //dummy function

	//push = press
	//unpush = unpress
	//force_push = force_press
}

api_table().Bumper <- OBumper