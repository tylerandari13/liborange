//import("orange-api/text.nut") // required

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

// menu stuff

function load_previous_scripts() {
	local newtab = [action.text("Load Previous Scripts")]
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
	if(name == "") {
		display_info("Could not find the desired script because you entered no text.", errors.ERROR)
		return
	}
	/*
	try {
		import(name + (endswith(name, ".nut") ? "" : ".nut"))
	} catch(e) try {
		import("liborange-scripts/" + name + (endswith(name, ".nut") ? "" : ".nut"))
	} catch(e) {
		display_info("Could not find the desired script \"" + name + "\". You spelling everything correctly?", errors.ERROR)
		return
	}
	*/
	try {
		//::print(name)
		import(name)
	} catch(e) try {
		//::print("liborange-scripts/" + name)
		import("liborange-scripts/" + name)
	} /*catch(e) try {
		//::print(name + ".nut")
		import(name + ".nut")
	} catch(e) try {
		//::print("liborange-scripts/" + name + ".nut")
		import("liborange-scripts/" + name + ".nut")
	} */catch(e) {
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
	local newtab = [action.text("Manage Scripts")]
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
	if(newtab.len() > 0 && newtab[0].orange_API_key != keys.TEXT) newtab = [action.text("Manage Script")].extend(newtab)
	local found = false
	foreach(v in newtab) if(v.text.tolower() == "back") found = true
	if(!found) newtab.push(action.run("Back", manage_scripts))
	swap_menu(newtab)
}

local menus = {
	main = [
		action.text("liborange Menu")
		action.swap("Script Loader", "script_loader")
		action.swap("Addon Settings", "addon_settings")
		action.swap("liborange Settings", "liborange_settings")
		//action.swap("Test Data Types", "test")
		action.exit()
	]
	script_loader = [
		action.text("Script Loader")
		action.run("Load a Previously Loaded Script", load_previous_scripts)
		action.swap("Load a New Script", "new_script")
		action.run("Manage Scripts", manage_scripts)
		action.swap("Back", "main")
	]
	new_script = [
		action.text("Load a New Script")
		data.string("Script Name")
		action.run("Load Script", load_script)
		action.back()
	]
	addon_settings = [
		action.text("Addon Settings")
		action.back()
		action.text("Coming Soon")
	]
	liborange_settings = [
		action.text("liborange Settings")
		data.enums("Text Resizing", 0, "On", "Off", "Adaptive")
		action.back()
	]
	test = [
		action.text("Test Data Types")
		data.integer("Integer", 0, -10, 10)
		data.float("Float")
		data.string("String")
		data.bool("Boolean")
		data.nil("Null")
		action.back()
	]
}

// other stuff

function load_script_thread() {
	while(true) {
		foreach(v in Level.liborange_loaded_scripts) {
			try {
				if(sector && !("custom_script_disable" in sector)) OThread(v._sector()).call()
			} catch(e) {
				try {
					if(worldmap && !("custom_script_disable" in worldmap)) OThread(v._worldmap()).call()
				} catch(e){

				}
			}
		}
		wait_for_screenswitch()
	}
}

function get_value_from_type(value) {
	if(type(value) == "table" && "orange_API_value" in value) {
		return value.orange_API_value
	} else if(type(value) == "integer") {
		return values.INT
	} else if(type(value) == "float") {
		return values.FLOAT
	} else if(type(value) == "string") {
		return values.STRING
	} else if(type(value) == "bool") {
		return values.BOOL
	}
	return values.NULL
}

function set_settings(name, value, item = menus.liborange_settings) // NOTE: send data types (AKA data.<something>()), not raw values
	item.apply(function[this](v, i, arr) {
		if(v.text == name) {
			return value
		} else return v
	})

function get_settings(name, item = menus.liborange_settings, enum_name = false)
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
						return v.enums[v.index][enum_name.tointeger()]
				}

class OliborangeMenuText extends OMenuText {
	titlescreen_mode = null

	constructor(name, titlescreen = false) {
		titlescreen_mode = titlescreen
		//if(titlescreen_mode) {
		//	set_text("Inputs cannot be inputted on the titlescreen. Please make an input to confirm youre not on the titlescreen. A good place to")
		//}
		base.constructor(name)
		set_wrap_width(sector.Camera.get_screen_width())
		swap_menu("main")
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
					if(drawline.len() >= 38 && v.orange_API_key != keys.TEXT) {
						set_font("small")
					} else if(drawline.len() >= 30 && v.orange_API_key != keys.TEXT) set_font("normal")
				case 2:
					if(drawnum == current_item && drawline.len() > 38 && v.orange_API_key != keys.TEXT) {
						set_font("small")
					} else if(drawnum == current_item && drawline.len() > 30 && v.orange_API_key != keys.TEXT) set_font("normal")
					break
			}
			drawnum++
		}
		set_text(start_info + "\n\n" + drawtext)
	}

	function swap_menu(new_menu) {
		current_item = 0
		last_menu = current_menu
		if(type(new_menu) == "string") {
			current_menu = clone menus[new_menu]
		} else current_menu = clone new_menu
	}

	function exit() {
		if(titlescreen_mode) {
			grow_out(0.3)
		} else {
			sector.Effect.fade_out(1)
			fade_out(0.5)
			wait(1)
			Level.finish(false)
		}
	}
}

// global class thing for the custom script loader to ensure all functions are there for global scripts
class OGlobalScript {
	settings = []

	function _sector() {}

	function _worldmap() {}

	function _titlescreen() _sector() // temporarily out of order


	function set_setting(name, value, setting) return set_settings(name, value, setting)
	function get_setting(name, setting, enum_name = false) return get_settings(name, setting, enum_name)
}

function hide_player(player) {
	player.set_visible(false)
	player.set_ghost_mode(true)
	player.deactivate()
	player.set_pos(0, 0)
}

api_table().init_script_loader <- function() {
	sector.custom_script_disable <- true
	sector.Text.set_font("big")
	sector.Text.set_back_fill_color(0, 0, 0, 0)
	sector.Text.set_front_fill_color(0, 0, 0, 0)
	sector.Text.set_visible(true)
	/*sector.Thing <- OThread(function() {while(wait(0.01) == null) {*/foreach(i, player in get_players()) hide_player(player)//}})
	//sector.Thing.call()
	OliborangeMenuText("Text")
}

api_table().init_script_loader_titlescreen <- function() {
	sector.Text.set_font("big")
	sector.Text.set_pos(50, 0)
	sector.Text.grow_in(0.3)
	sector.Text.set_anchor_point(ANCHOR_LEFT)
	OliborangeMenuText(TextObject(), true)
}

api_table().global_script <- OGlobalScript
