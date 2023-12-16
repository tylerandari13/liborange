import("liborange.nut")
class TemplateScript extends OGlobalScript {
	function sector() {
		print("I run in every sector!")
	}

	function worldmap() {
		print("I run on the worldmap!")
	}

	function titlescreen() { // temporarily out of order
		print("I run on the titlescreen!")
	}
}

liborange_add_global_script(TemplateScript)
