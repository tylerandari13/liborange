import("orange-api/orange_api_util.nut")

class OTrampoline extends OObject {
	direction = null
	speed_y = 0
	speed_multiplier = 0

	constructor(obj, dir = "up", y = -450, mult = 2) {
		base.constructor(obj)
		direction = dir.tolower()
        speed_y = y
		speed_multiplier = mult

		object.set_action("normal")
		object.set_action("normal-" + direction)
	}

	function press() {
		if(objects_collided(sector.Tux.get_x(), sector.Tux.get_y(), 32, (sector.Tux.get_bonus() == "none" ? 32 : 64),
							object.get_pos_x(), object.get_pos_y(),
							((direction == "up" || direction == "down") ? 30 : 16),
							((direction == "up" || direction == "down") ? 16 : 30), direction))
			force_press()
	}

	function force_press() {
		local speed

		if(direction == "up") {
			if(sector.Tux.get_bonus() == "airflower") {
			speed = speed_y
			* (sector.Tux.get_input_held("jump") || sector.Tux.get_input_held("down") ? speed_multiplier : 1)
			- 80
			+ (sector.Tux.get_input_held("down") ? 10 : 0)
			} else {
			speed = speed_y
			* (sector.Tux.get_input_held("jump") || sector.Tux.get_input_held("down") ? speed_multiplier : 1)
			+ (sector.Tux.get_input_held("down") ? 100 : 0)
			}
		} else speed = speed_y * speed_multiplier * -1

		sector.Tux.set_velocity(sector.Tux.get_velocity_x(), speed)
		play_sound("sounds/trampoline.wav")
		object.set_action("swinging")
		object.set_action("swinging-" + direction)
		wait(0.21875)
		object.set_action("normal")
		object.set_action("normal-" + direction)
	}

	//push = press
	//unpush = unpress
	//force_push = force_press
}

api_table().Trampoline <- OTrampoline