import("orange-api/orange_api_util.nut")

class NewButton extends ObjectOverride {
	direction = null
	press_function = null

	is_pressed = false

	button_x = 0
	button_y = 0

	constructor(obj, dir = "up", func = function(){}) {
		base.constructor(obj)
		direction = dir.tolower()
		press_function = func
		button_x = object.get_pos_x()
		button_y = object.get_pos_y()

		object.set_action("off-" + direction)
	}

	function press() {
		if(!is_pressed) {
			is_pressed = true
			press_function()
			object.set_action("on-" + direction)
			play_sound("sounds/switch.ogg")
			wait(0.01)
			if(direction == "up") object.set_pos(button_x, button_y + 6)
			if(direction == "left") object.set_pos(button_x + 6, button_y)
		}
	}

	function unpress() {
		if(is_pressed) {
			is_pressed = false
			object.set_action("off-" + direction)
			play_sound("sounds/switch.ogg")
			wait(0.01)
			if(direction == "up") object.set_pos(button_x, button_y)
			if(direction == "left") object.set_pos(button_x, button_y)
		}
	}

	function push() press()
	function unpush() unpress()
}

get_api_table().Button <- NewButton