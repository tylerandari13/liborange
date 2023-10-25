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
		if(objects_collided(sector.Tux.get_x(), sector.Tux.get_y(), 32, (sector.Tux.get_bonus() == "none" ? 32 : 64),
							object.get_pos_x(), object.get_pos_y(), 18, 27, "auto"))
			force_press()
	}

	function force_press() {
		local speed
		sector.Tux.deactivate()
		wait(0.01)
		sector.Tux.set_velocity((direction == "right" ? speed_x : speed_x * -1), speed_y)
		play_sound("sounds/trampoline.wav")
		object.set_action("swinging-" + direction)
		while(sector.Tux.get_velocity_y() < 0) wait(0.01)
		object.set_action("normal-" + direction)
		sector.Tux.activate()
	}

	//push = press
	//unpush = unpress
	//force_push = force_press
}

api_table().Bumper <- OBumper