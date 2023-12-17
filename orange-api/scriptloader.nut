import("orange-api/orange_api_util.nut")
import("orange-api/text.nut") // required

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
	if(newtab[0].orange_API_key != keys.TEXT) newtab = [action.text("Manage Script")].extend(newtab)
	local found = false
	foreach(v in newtab) if(v.text.tolower() == "back") found = true
	if(!found) newtab.push(action.back())
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
		data.enums("Text Resizing", 0, ["On", 0], ["Off", 1], ["Adaptive", 2])
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

class OliborangeMenuText extends OMenuText {
	constructor(name) {
		base.constructor(name)
		set_font("big")
		set_back_fill_color(0, 0, 0, 0)
		set_front_fill_color(0, 0, 0, 0)
		set_visible(true)
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
	OliborangeMenuText("Text")
}

api_table().global_script <- OGlobalScript
