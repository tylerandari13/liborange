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

		set_action("normal-" + direction)
	}

	function press() {
		force_press(get_nearest_player(get_x(), get_y()))
	}

	function force_press(player = sector.Tux) {
		player.deactivate()
		wait(0.01)
		local y_speed = (
			(player.get_action().find("slide-") && get_y() - 31 <= player.get_y())
			|| player.get_action().find("swim-")
			|| player.get_action().find("boost-")
			|| player.get_action().find("float-")
		) ? player.get_velocity_x() : speed_y
		player.set_velocity((direction == "right" ? speed_x : speed_x * -1), y_speed)
		play_sound("sounds/trampoline.wav")
		set_action("swinging-" + direction)
		while(player.get_velocity_y() < 0) {
			if(player.get_input_held("left")) player.set_dir(false)
			if(player.get_input_held("right")) player.set_dir(true)
			wait(0.01)
		}
		set_action("normal-" + direction)
		player.activate()
	}

	//push = press
	//unpush = unpress
	//force_push = force_press
}

api_table().Bumper <- OBumper