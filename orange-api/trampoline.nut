if(WORLDMAP_GUARD) {

class OTrampoline extends OObject {
	direction = null
	speed_y = 0
	speed_multiplier = 0

	constructor(obj, dir = "up", y = -450, mult = 2) {
		base.constructor(obj)
		direction = dir.tolower()
        speed_y = y
		speed_multiplier = mult

		set_action("normal")
		set_action("normal-" + direction)
	}

	function press() {
		if(collided_with_any_player(get_x(), get_y(),
									((direction == "up" || direction == "down") ? 30 : 16),
									((direction == "up" || direction == "down") ? 16 : 30), direction).len() > 0)
			force_press(get_nearest_player(get_x(), get_y()))
	}

	function force_press(player = sector.Tux) {
		local speed

		if(direction == "up") {
			if(player.get_bonus() == "airflower") {
			speed = speed_y
			* (player.get_input_held("jump") || player.get_input_held("down") ? speed_multiplier : 1)
			- 80
			+ (player.get_input_held("down") ? 10 : 0)
			} else {
			speed = speed_y
			* (player.get_input_held("jump") || player.get_input_held("down") ? speed_multiplier : 1)
			+ (player.get_input_held("down") ? 100 : 0)
			}
		} else speed = speed_y * speed_multiplier * -1

		player.set_velocity(player.get_velocity_x(), speed)
		play_sound("sounds/trampoline.wav")
		set_action("swinging")
		set_action("swinging-" + direction)
		wait(0.21875)
		set_action("normal")
		set_action("normal-" + direction)
	}

	//push = press
	//unpush = unpress
	//force_push = force_press
}

api_table().Trampoline <- OTrampoline

}
