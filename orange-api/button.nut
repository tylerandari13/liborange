import("orange-api/orange_api_util.nut")

class OButton extends OObject {
	direction = null
	press_function = null

	is_pressed = false

	button_x = 0
	button_y = 0

	constructor(obj, dir = "up", func = function(){}) {
		base.constructor(obj)
		direction = dir.tolower()
		if(type(func) == "string") {
			press_function = compilestring(func)
		} else press_function = func
		button_x = object.get_pos_x()
		button_y = object.get_pos_y()

		object.set_action("off-" + direction)
	}

	function press(sound = true) {
		if(direction == "up" && sector.Tux.get_y() + (sector.Tux.get_bonus() == "none" ? 32 : 64) <= object.get_pos_y() + 1) {
			force_press(sound)
		} else if(direction == "down" && sector.Tux.get_y() >= object.get_pos_y() + 1) {
			force_press(sound)
		} else if(direction == "left" && sector.Tux.get_x() >= object.get_pos_x() + 5) {
			force_press(sound)
		} else if(direction == "right" && sector.Tux.get_x() + 32 <= object.get_pos_x() + 1) {
			force_press(sound)
		}
	}

	function force_press(sound = true) {
		if(!is_pressed) {
			is_pressed = true
			press_function()
			object.set_action("on-" + direction)
			if(sound) play_sound("sounds/switch.ogg")
			wait(0.01)
			if(direction == "up") object.set_pos(button_x, button_y + 6)
			if(direction == "right") object.set_pos(button_x + 6, button_y)
		}
	}

	function unpress(sound = false) {
		if(is_pressed) {
			is_pressed = false
			object.set_action("off-" + direction)
			if(sound) play_sound("sounds/switch.ogg")
			wait(0.01)
			if(direction == "up") object.set_pos(button_x, button_y)
			if(direction == "right") object.set_pos(button_x, button_y)
		}
	}

	//push = press
	//unpush = unpress
	//force_push = force_press
}

get_api_table().Button <- OButton