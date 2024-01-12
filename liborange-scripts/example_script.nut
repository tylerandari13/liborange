import("liborange.nut")
class TemplateScript extends OGlobalScript {
	settings = [ // see below `::data <- {}` in `text.nut` for how to use these
		data.integer("speed or something")
		data.float("jump height or whatever")
		data.string("name i guess")
		data.bool("is alive maybe")
		data.enums("type", "guh?", "guh!", "guh.")
		data.nil("nothing here")
	]

	function _sector() {
		print("I run in every sector!")
	}

	function _worldmap() {
		print("I run on the worldmap!")
	}
}

liborange_add_global_script(TemplateScript)
