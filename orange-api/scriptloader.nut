import("orange-api/orange_api_util.nut")

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

function action::exit(text = "Exit") return {
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

function data::enums(text, index, ...) return {
	orange_API_key = keys.CUSTOM
	orange_API_value = values.ENUM
	text = text
	enums = vargv
	index = index
}

function data::nil(text) return {
	orange_API_key = keys.CUSTOM
	orange_API_value = values.NULL
	text = text
}

// menu stuff

function load_previous_scripts() {
	local newtab = []
	if("liborange_previously_loaded_scripts" in Level && Level.liborange_previously_loaded_scripts.len() > 0) {
		foreach(i, v in Level.liborange_previously_loaded_scripts) {
			newtab.push(action.run((i in Level.liborange_loaded_scripts ? "Reload": "Load") + " Script \"" + i + "\"", function(){load_script(i)}))
		}
	} else {
		newtab.push(action.text("No scripts previously loaded. Check \"Load a New Script\" to load one."))
	}
	newtab.push(action.back())
	swap_menu(newtab)
}

function load_script(name = null) {
	if(name == null) name = get_item_from_name("Script Name").string
	try{
		import(name)
	} catch(e) try{
		import("liborange-scripts/" + name)
	} catch(e) {
		display_info("Could not find the desired script \"" + name + "\". You spelling everything correctly?", errors.ERROR)
		return
	}
	if(!("liborange_loaded_scripts" in Level)) Level.liborange_loaded_scripts <- {}
	Level.loaded_script_thread <- OThread(load_script_thread)
	Level.loaded_script_thread.call()
	if(name in Level.liborange_loaded_scripts) delete Level.liborange_loaded_scripts[name]
	Level.liborange_loaded_scripts[name] <- (type(Level.liborange_loaded_script_class) == "class" ?
																				Level.liborange_loaded_script_class() :
																				Level.liborange_loaded_script_class)
	Level.liborange_loaded_script_class = null
	display_info("Script successfully loaded!", errors.OK)
	if(!("liborange_previously_loaded_scripts" in Level)) Level.liborange_previously_loaded_scripts <- {}
	Level.liborange_previously_loaded_scripts[name] <- name
}

function manage_scripts() {
	local newtab = []
	if("liborange_loaded_scripts" in Level && Level.liborange_loaded_scripts.len() > 0) {
		foreach(i, v in Level.liborange_loaded_scripts) {
			newtab.push(action.run("Manage Script \"" + i + "\"", function(){manage_script(Level.liborange_loaded_scripts[i])}))
		}
	} else {
		newtab.push(action.text("No scripts currently loaded. Check \"Load a New Script\" to load one."))
	}
	newtab.push(action.swap("Back", "script_loader"))
	swap_menu(newtab)
}

function manage_script(script) {
	local newtab = script.settings
	local found = false
	foreach(v in newtab) if(v.orange_API_key == keys.BACK) found = true
	if(!found) newtab.push(action.back())
	swap_menu(newtab)
}

local menus = {
	main = [
		action.swap("Script Loader", "script_loader")
		action.swap("Addon Settings", "addon_settings")
		action.swap("liborange Settings", "liborange_settings")
		//action.swap("Test Data Types", "test")
		action.exit()
	]
	script_loader = [
		action.run("Load a Previously Loaded Script", load_previous_scripts)
		action.swap("Load a New Script", "new_script")
		action.run("Manage Scripts", manage_scripts)
		action.swap("Back", "main")
	]
	new_script = [
		data.string("Script Name")
		action.run("Load Script", load_script)
		action.back()
	]
	addon_settings = [
		action.text("Coming Soon")
		action.back()
	]
	liborange_settings = [
		data.enums("Text Resizing", 0, ["On", 0], ["Off", 1], ["Adaptive", 2])
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

function load_script_thread() {
	while(true) {
		foreach(v in Level.liborange_loaded_scripts) {
			try {
				if(sector) OThread(v._sector()).call()
			} catch(e){
				try {
					if(worldmap) OThread(v._worldmap()).call()
				} catch(e){

				}
			}
		}
		wait_for_screenswitch()
	}
}

function get_settings(name, item = menus.liborange_settings)
		foreach(v in item)
			if(v.text == name)
				switch(v.orange_API_value) {
					case values.NULL:
						return null
					case values.INT:
					case values.FLOAT:
						return v.num
					case values.STRING:
						return v.string
					case values.BOOL:
						return v.bool
					case values.ENUM:
						return v.enums[v.index][1]
				}

function exit() {
	sector.Effect.fade_out(1)
	sector.Text.fade_out(0.5)
	wait(1)
	Level.finish(false)
}

function hide_player(player) {
	player.set_visible(false)
	player.set_ghost_mode(true)
	player.deactivate()
	player.set_pos(0, 0)
}

class OMenuText extends OObject {
	current_item = 0

	current_menu = {}
	last_menu = {}

	start_info = ""

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
		sector.liborange.get_signal("console_response").connect(temp_string.bindenv(this))
		swap_menu("main")
	}

	function temp_string(text) if(current_menu[current_item].orange_API_key == keys.CUSTOM && current_menu[current_item].orange_API_value == values.STRING) current_menu[current_item].string = text

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

		if(drawnum != current_item) set_font("big")

		foreach(i, v in current_menu) {
			local drawline = (drawnum == current_item ? "> " : "  ")
			switch(v.orange_API_key) {
				case keys.CUSTOM:
					drawline += v.text + " : "
					switch(v.orange_API_value) {
						case values.NULL:
							drawline += "<null>"
							break
						case values.INT:
							drawline += v.num
							break
						case values.FLOAT:
							drawline += v.num + (v.num == v.num.tointeger() ? ".0" : "")
							break
						case values.STRING:
							drawline += v.prefix + v.string + v.suffix
							break
						case values.BOOL:
							drawline += v.bool ? v.true_text : v.false_text
							break
						case values.ENUM:
							drawline += "<- " + v.enums[v.index][0] + "->"
							break
						default:
							drawline += "<unknown>"
							break
					}
					break
				default:
					drawline += v.text
			}
			drawtext += drawline + (drawnum == current_item ? " <" : "") + "\n\n"

			switch(get_settings("Text Resizing")) {
				case 1:
					set_font("big")
					break
				case 0:
					if(drawline.len() > 38) {
						set_font("small")
					} else if(drawline.len() > 30) set_font("normal")
				case 2:
					if(drawnum == current_item && drawline.len() > 38) {
						set_font("small")
					} else if(drawnum == current_item && drawline.len() > 30) set_font("normal")
					break
			}
			if(drawnum == current_item && drawline.len() > 38) {
				set_font("small")
			} else if(drawnum == current_item && drawline.len() > 30) set_font("normal")
			drawnum++
		}
		set_text(start_info + "\n\n" + drawtext)
	}

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
									// handled at temp_string()
								break
							case values.BOOL:
								v.bool = !v.bool
								break
							case values.ENUM:
								v.index += (dir == 0 ? 1 : dir)
								if(v.index > v.enums.len() - 1) v.index = 0
								if(v.index < 0) v.index = v.enums.len() - 1
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

	function get_item_from_name(name) foreach(v in current_menu) if(v.text == name) return v

	function run_function(func) (type(func) == "string" ? compilestring(func) : func).bindenv(this)()

	function go_back() swap_menu(last_menu)

	function display_info(message, type) OThread(function[this](message, type) {
		local start_thing = ""
		switch(type) {
			case errors.OK:
				start_thing = "Success: "
			break
			case errors.WARNING:
				start_thing = "Warning: "
			break
			case errors.ERROR:
				start_thing = "Error: "
			break
		}
		start_info = start_thing + message
		wait(5)
		start_info = ""
	}).call(message, type)
}

// global class thing for the custom script loader to ensure all functions are there for global scripts
class OGlobalScript extends OObject {
	settings = []

	constructor(a = null) base.constructor(a == null ? class{}() : a)

	function _sector() {}

	function _worldmap() {}

	function _titlescreen() {} // temporarily out of order

	function get_setting(name) return get_settings(name, settings)

}

api_table().init_script_loader <- function() {
	OMenuText("Text")
}

api_table().global_script <- OGlobalScript
