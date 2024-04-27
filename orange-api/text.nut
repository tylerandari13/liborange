enum keys { // i hate how i have to define these so many times
	TEXT
	SWAP
	FUNC
	BACK
	CUSTOM
	EXIT
}

enum values {
	NULL
	INT
	FLOAT
	STRING
	BOOL
	ENUM
}

enum errors {
	OK
	INFO
	WARNING
	ERROR
}

// functions to make menu things
::action <- {}

function action::text(text)  return {
	key = keys.TEXT
	text = "- " + text + " -"
	skip = true
}

function action::swap(text, menu) return {
	key = keys.SWAP
	menu = menu
	text = text
}

function action::run(text, func, envobj = null) return {
	key = keys.FUNC
	func = func
	text = text
	envobj = envobj
}

function action::back(text = "Back") return {
	key = keys.BACK
	text = text
}

function action::exit(text = "Exit") return {
	key = keys.EXIT
	text = text
}

// data types
::data <- {}

function data::integer(text, num = 0, min = -2147483647, max = 2147483647, inc = 1) return {
	key = keys.CUSTOM
	value = values.INT
	text = text

	num = num
	min = min
	max = max
	inc = inc
}

function data::float(text, num = 0.0, min = -2147483647.0, max = 2147483647.0, inc = 0.5) return {
	key = keys.CUSTOM
	value = values.FLOAT
	text = text

	num = num
	min = min
	max = max
	inc = inc
}

function data::string(text, string = "", prefix = "\"", suffix = "\"") return {
	key = keys.CUSTOM
	value = values.STRING
	text = text

	string = string
	prefix = prefix
	suffix = suffix
}

function data::bool(text, bool = false, true_text = "ON", false_text = "OFF") return {
	key = keys.CUSTOM
	value = values.BOOL
	text = text

	bool = bool
	true_text = true_text
	false_text = false_text
}

function data::enums(text, index, ...) return {
	key = keys.CUSTOM
	value = values.ENUM
	text = text
	enums = vargv
	index = index
}

function data::nil(text) return {
	key = keys.CUSTOM
	value = values.NULL
	text = text
}

function get_pressed(...) {
	foreach(v in vargv) if(sector.Tux.get_input_pressed(v)) return true
	return false
}
function get_held(...) {
	foreach(v in vargv) if(sector.Tux.get_input_held(v)) return true
	return false
}
function get_released(...) {
	foreach(v in vargv) if(sector.Tux.get_input_released(v)) return true
	return false
}

class OText extends OObject {
	text = ""

	constructor(name = null) {
		if(name == null) {
			base.constructor(::TextObject())
		} else base.constructor(name)
	}

	// overridden functions

	function set_text(_text = "") {
		text = _text
		// _text = api_table().replace(_text, "\n", "\n\n")
		_text = api_table().replace(_text, "\t", "  ")
		object.set_text(_text)
	}

	function set_front_fill_color(...) {
		api_table().parse_color.bindenv(this)(vargv, "set_front_fill_color")
	}

	function set_back_fill_color(...) {
		api_table().parse_color.bindenv(this)(vargv, "set_back_fill_color")
	}

	function set_text_color(...) {
		api_table().parse_color.bindenv(this)(vargv, "set_text_color")
	}

	//OText specific functions

	function get_pos() {
		return api_table().Vector(get_x(), get_y())
	}

	function get_text() return text

	function add_text(_text) set_text(get_text() + _text)

	function typewrite(display_text, wait_time = 0.05, wait_on_end_chars = true) {
		for(local i = 0; i < display_text.len(); i++) {
			set_text(display_text.slice(0, i))
			//wait(wait_time)
		}
	}
}

class OMenuText extends OText {
	visible = false
	exited = null

	menu = []
	selected = 0

	//history = []
	last_menu = null

	constructor(name = null) {
		base.constructor(name)
		set_centered(true)
		process = process_func.bindenv(this)
		input_pressed = input_pressed_func.bindenv(this)
		api_table().init_signals()
		exited = OSignal()
	}

	function update(_visible) {
		visible = _visible
		if(visible) {
			api_table().get_callback("process").connect(process)
			api_table().get_signal("input-pressed").connect(input_pressed)
		} else {
			api_table().get_callback("process").disconnect(process)
			api_table().get_signal("input-pressed").disconnect(input_pressed)
			exited.call()
		}
	}

	function swap_menu(new_menu) {
		//history.push(menu)
		last_menu = menu
		//menu = clone new_menu
		menu = new_menu
		selected = 0
	}

	function select() {
		local selected_item = menu[selected]
		switch(selected_item.key) {
			case keys.SWAP:
				swap_menu(selected_item.menu)
			break
			case keys.FUNC:
				if(selected_item.envobj == null) {
					selected_item.func()
				} else {
					selected_item.func.bindenv(selected_item.envobj)()
				}
			break
			case keys.BACK:
				swap_menu(last_menu)
			break
			case keys.EXIT:
				set_visible(false)
			break
		}
	}

	function change_value(amount) {
		local selected_item = menu[selected]
		switch(selected_item.value) {
			case values.INT:
			case values.FLOAT:
				if(api_table().anyone_held("action")) {
					amount = amount * (selected_item.value == values.INT ? 2 : 0.1)
				}
				if(api_table().anyone_held("menu-select")) {
					amount = amount * (selected_item.value == values.INT ? 10 : 0.5)
				}
				selected_item.num += amount
			break
			//case values.STRING:
				// nothing yet (how am i supposed to do this?)
			//break
			case values.BOOL:
				selected_item.bool = !selected_item.bool
			break
			case values.ENUM:
				selected_item.index += amount
				if(selected_item.index < 0)
					selected_item.index = selected_item.enums.len() - 1
				if(selected_item.index >= selected_item.enums.len())
					selected_item.index = 0
			break
		}
	}

	function move_selected(amount) {
		selected += amount
		if(selected < 0) selected = menu.len() - 1
		if(selected >= menu.len()) selected = 0
	}

	process = null
	function process_func() {
		local selected_item = menu[selected]
		if("skip" in selected_item) {
			local a = api_table().anyone_axis("up", "down") +
					api_table().anyone_axis("peek-up", "peek-down")
			move_selected(a == 0 ? 1 : a)
			return
		}
		set_text("")
		foreach(i, item in menu) {
			add_text(i == selected ? "> " : " ")
			add_text(item.text)
			if(item.key == keys.CUSTOM) {
				add_text(" = ")
				switch(item.value) {
					case values.INT:
						add_text(item.num)
					break
					case values.FLOAT:
						add_text(item.num)
						if(floor(item.num) == item.num) {
							add_text(".0")
						}
					break
					case values.STRING:
						add_text(item.prefix + item.string + item.suffix)
					break
					case values.BOOL:
						add_text((item.bool ? item.true_text : item.false_text))
					break
					case values.ENUM:
						add_text(item.enums[item.index])
					break
					case values.NULL:
						add_text("<null>")
					break
					default:
						add_text("???")
					break
				}
			}
			add_text(i == selected ? " <" : "")
			if(i < menu.len() - 1) add_text("\n")
		}
	}

	input_pressed = null
	function input_pressed_func(input, player) {
		local selected_item = menu[selected]
		move_selected(api_table().anyone_axis("up", "down") +
					api_table().anyone_axis("peek-up", "peek-down"))
		if(input == "menu-select") {
			if(selected_item.key == keys.CUSTOM) {
				change_value(1)
			} else {
				select()
			}
		}
		local horiz_axis = api_table().anyone_axis("left", "right") +
		api_table().anyone_axis("peek-left", "peek-right")
		if(horiz_axis != 0 && selected_item.key == keys.CUSTOM) {
			change_value(horiz_axis)
		}
	}

	function set_visible(_visible) {
		object.set_visible(_visible)
		update(_visible)
	}

	function fade_in(fadetime) {
		object.fade_in(fadetime)
		update(true)
	}

	function fade_out(fadetime) {
		object.fade_out(fadetime)
		update(false)
	}

	function grow_in(fadetime) {
		object.grow_in(fadetime)
		update(true)
	}

	function grow_out(fadetime) {
		object.grow_out(fadetime)
		update(false)
	}
}

api_table().Text <- OText
api_table().MenuText <- OMenuText
