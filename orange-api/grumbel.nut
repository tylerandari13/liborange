function get_version() {
	if("do_the_funny" in Level) return 1
	if("grumbel_thread" in Level || "grumbel_v2" in Level) return 2
	return 0
}

function get_data(key) try {
	if(key == "version") return get_version()
	switch(get_version()) {
		case 1:
			local newkey = "grumbel_" + key.slice(0, -2)
			if(newkey in get_sector() && type(get_sector()[newkey]) == "array") {
				if(endswith(key, "_x")) return get_sector()[newkey][0]
				if(endswith(key, "_y")) return get_sector()[newkey][1]
			}
			return get_sector()["grumbel_" + key]
		break
		case 2:
			return get_sector().grumbel[key]
		break
	}
} catch(e) {}

function set_data(key, value) try {
	switch(get_version()) {
		case 1:
			local newkey = "grumbel_" + key.slice(0, -2)
			if(newkey in get_sector() && type(get_sector()[newkey]) == "array") {
				if(endswith(key, "_x")) return get_sector()[newkey][0] = value
				if(endswith(key, "_y")) return get_sector()[newkey][1] = value
			}
			return get_sector()["grumbel_" + key] = value
		break
		case 2:
			return get_sector().grumbel[key] = value
		break
	}
} catch(e) {}

api_table().grumbel_exists <- function() return get_version() != 0

api_table().freeze_grumbel <- function(f = true) return set_data("idle", f)
api_table().unfreeze_grumbel <- function(f = true) return set_data("idle", !f)

api_table().set_grumbel_pos <- function(x, y) {
	set_data("pos_x", x)
	set_data("pos_y", y)
}

api_table().get_grumbel_pos_x <- function() return get_data("pos_x")
api_table().get_grumbel_pos_y <- function() return get_data("pos_y")

api_table().set_grumbel_sprite <- function(path, use_cape = true) try {
	if(get_version() == 1) {
		sector.grumbel.set_visible(false)
		delete sector.grumbel
		sector.grumbel <- FloatingImage(path)
		sector.grumbel.set_anchor_point(ANCHOR_TOP_LEFT)
		sector.grumbel.set_layer(600)
		sector.grumbel.set_visible(true)
		sector.grumbel.set_action("invisible")
	} else {
		sector.grumbel_image.set_visible(false)
		delete sector.grumbel_image
		sector.grumbel_image <- FloatingImage(path)
		sector.grumbel_image.set_anchor_point(ANCHOR_TOP_LEFT)
		sector.grumbel_image.set_layer(600)
		sector.grumbel_image.set_visible(true)
		sector.grumbel_image.set_action("invisible")
	}

	sector.grumbel_cape.set_visible(false)
	delete sector.grumbel_cape
	sector.grumbel_cape <- FloatingImage(use_cape ? path : "../../images/objects/invisible/invisible.png")
	sector.grumbel_cape.set_anchor_point(ANCHOR_TOP_LEFT)
	sector.grumbel_cape.set_layer(599)
	sector.grumbel_cape.set_visible(true)
	sector.grumbel_cape.set_action("invisible")
} catch(e) {}

//api_table().set_checkpoints <- function(amount) 
//api_table().get_checkpoints <- function() 

api_table().set_grumbel_data <- function(key, value) return set_data(key, value)
api_table().get_grumbel_data <- function(key) return get_data(key)

//api_table().display_grumbel_info <- 