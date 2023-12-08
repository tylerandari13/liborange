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
		button_x = get_x()
		button_y = get_y()

		set_action("off-" + direction)
	}

	function press(...) {
		local sound = true
		foreach(v in vargv)
			if(type(v) == "string") {
				press_function = compilestring(v)
			} else if(type(v) == "function") {
				press_function = v
			} else if(type(v) == "bool") sound = v
		if(collided_with_any_player(get_x(), get_y(),
									((direction == "up" || direction == "down") ? 30 : 16),
									((direction == "up" || direction == "down") ? 16 : 30), direction).len() > 0)
			force_press(sound)
	}

	function force_press(sound = true) {
		if(!is_pressed) {
			is_pressed = true
			press_function()
			set_action("on-" + direction)
			if(sound) play_sound("sounds/switch.ogg")
			wait(0.01)
			if(direction == "up") set_pos(button_x, button_y + 6)
			if(direction == "right") set_pos(button_x + 6, button_y)
		}
	}

	function unpress(sound = false) {
		if(is_pressed) {
			is_pressed = false
			set_action("off-" + direction)
			if(sound) play_sound("sounds/switch.ogg")
			wait(0.01)
			if(direction == "up") set_pos(button_x, button_y)
			if(direction == "right") set_pos(button_x, button_y)
		}
	}

	//push = press
	//unpush = unpress
	//force_push = force_press
}

api_table().Button <- OButton