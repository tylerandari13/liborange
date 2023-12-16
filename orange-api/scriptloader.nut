import("orange-api/orange_api_util.nut")

local nan = sqrt(-1)

enum keys {
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
}

function hide_player(player) {
	player.set_visible(false)
	player.set_ghost_mode(true)
	player.deactivate()
	player.set_pos(0, 0)
}

// functions to make menu things
::action <- {}

function action::text(text)  return {
	orange_API_key = keys.TEXT
	text = "- " + text + " -"
}

function action::swap(text, menu) return {
	orange_API_key = keys.SWAP
	menu = menu
	text = text
}

function action::run(text, func) return {
	orange_API_key = keys.FUNC
	func = func
	text = text
}

function action::back(text = "Back") return {
	orange_API_key = keys.BACK
	text = text
}

function action::exit(text = "Exit Script Loader") return {
	orange_API_key = keys.EXIT
	text = text
}

// data types
::data <- {}

function data::integer(text, num = 0, min = -2147483647, max = 2147483647, inc = 1) return {
	orange_API_key = keys.CUSTOM
	orange_API_value = values.INT
	text = text

	num = num
	min = min
	max = max
	inc = inc
}

function data::float(text, num = 0.0, min = -2147483647.0, max = 2147483647.0, inc = 0.5) return {
	orange_API_key = keys.CUSTOM
	orange_API_value = values.FLOAT
	text = text

	num = num
	min = min
	max = max
	inc = inc
}

function data::string(text, string = "", prefix = "\"", suffix = "\"") return {
	orange_API_key = keys.CUSTOM
	orange_API_value = values.STRING
	text = text

	string = string
	prefix = prefix
	suffix = suffix
}

function data::bool(text, bool = false, true_text = "ON", false_text = "OFF") return {
	orange_API_key = keys.CUSTOM
	orange_API_value = values.BOOL
	text = text

	bool = bool
	true_text = true_text
	false_text = false_text
}

function data::nil(text) return {
	orange_API_key = keys.CUSTOM
	orange_API_value = values.NULL
	text = text
}

// menu stuff

function load_previous_scripts() {
	local newtab = []

	newtab.push(action.back())
	swap_menu(newtab)
}

local menus = {
	main = [
		action.run("Load a Previously Loaded Script", load_previous_scripts)
		action.swap("Load a New Script", "new_script")
		action.swap("Test Data Types", "test")
		action.exit()
	]
	new_script = [
		data.string("Script Name")
		action.run("Load Script", function(){})
		action.back()
	]
	test = [
		data.integer("Integer", 0, -10, 10)
		data.float("Float")
		data.string("String")
		data.bool("Boolean")
		data.nil("Null")
		action.back()
	]
}

// other stuff

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

function exit() {
	sector.Effect.fade_out(1)
	sector.Text.fade_out(0.5)
	wait(1)
	Level.finish(false)
}

class OMenuText extends OObject {
	current_item = 0

	current_menu = {}
	last_menu = {}

	thread = null
	constructor(name) {
		base.constructor(name)
		set_font("big")
		set_back_fill_color(0, 0, 0, 0)
		set_front_fill_color(0, 0, 0, 0)
		set_visible(true)
		set_text("Guh")
		start_cutscene()
		thread = OThread(thread_func.bindenv(this))
		thread.call()
		swap_menu("main")
	}

	function thread_func() {
		while(wait(0.01) == null && !get_pressed("escape", "menu-back")) {
			foreach(i, player in get_players()) hide_player(player)

			if(get_pressed("up", "peek-up")) current_item--
			if(get_pressed("down", "peek-down")) current_item++

			if(get_pressed("action", "menu-select", "menu-select-space", "jump")) menu_select()
			if(get_pressed("left", "peek-left")) menu_select(-1)
			if(get_pressed("right", "peek-right")) menu_select(1)

			if(current_item < 0) current_item = current_menu.len() - 1
			if(current_item >= current_menu.len()) current_item = 0

			draw_menu()
		}
		exit()
	}

	function draw_menu() {
		local drawtext = ""
		local drawnum = 0

		foreach(i, v in current_menu) {
			switch(v.orange_API_key) {
				case keys.CUSTOM:
					drawtext += v.text + " : "
					switch(v.orange_API_value) {
						case values.NULL:
							drawtext += "<null>"
							break
						case values.INT:
							drawtext += v.num
							break
						case values.FLOAT:
							drawtext += v.num + (v.num == v.num.tointeger() ? ".0" : "")
							break
						case values.STRING:
							drawtext += v.prefix + v.string + v.suffix
							break
						case values.BOOL:
							drawtext += v.bool ? v.true_text : v.false_text
							break
						default:
							drawtext += "<unknown>"
							break
					}
					break
				default:
					drawtext += v.text
			}
			drawtext += (drawnum == current_item ? " <" : "") + "\n\n"
			drawnum++
		}

		set_text(drawtext)
	}

	/*enum values {
		NULL
		INT
		FLOAT
		STRING
		BOOL
	}*/

	function menu_select(dir = 0) {
		local drawnum = 0
		foreach(i, v in current_menu) {
			if(drawnum == current_item) {
				switch(v.orange_API_key) {
					case keys.SWAP:
						swap_menu(v.menu)
						break
					case keys.FUNC:
						run_function(v.func)
						break
					case keys.BACK:
						go_back()
						break
					case keys.EXIT:
						exit()
						break
					case keys.CUSTOM:
						switch(v.orange_API_value) {
							case values.INT:
							case values.FLOAT:
								if(get_held("left", "peek-left")) {
									if(v.num > v.min) {
										v.num -= v.inc
									} else v.num = v.min
								}
								if(get_held("right", "peek-right")) {
									if(v.num < v.max) {
										v.num += v.inc
									} else v.num = v.max
								}
								break
							case values.STRING:
								// to be implemented
								break
							case values.BOOL:
								v.bool = !v.bool
								break
						}
				}
			}
			drawnum++
		}
	}

	function swap_menu(new_menu) {
		current_item = 0
		last_menu = current_menu
		if(type(new_menu) == "string") {
			current_menu = clone menus[new_menu]
		} else current_menu = clone new_menu
	}

	function run_function(func) (type(func) == "string" ? compilestring(func) : func).bindenv(this)()

	function go_back() swap_menu(last_menu)
}

api_table().init_script_loader <- function() {
	OMenuText("Text")
}
