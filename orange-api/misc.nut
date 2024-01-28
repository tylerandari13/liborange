function table_to_sexp(table) {
	local retstring = ""
	foreach(i, v in table) {
		if(type(v) == "string") {
			retstring += "(" + i.tostring() + " \"" + v + "\")"
		} else if(type(v) == "bool") {
			retstring += "(" + i.tostring() + " " + (v ? "#t" : "#f") + ")"
		} else retstring += "(" + i.tostring() + " " + v.tostring() + ")"
	}
	return retstring
}

api_table().min <- function(num, limit) return num < limit ? limit : num

api_table().max <- function(num, limit) return num > limit ? limit : num

api_table().char_at_index <- function(string, index) return string.slice(index, api_table().mod_max(index + 1, string.len()))

api_table().distance_from_point_to_point <- distance_from_point_to_point

api_table().table_to_sexp <- table_to_sexp

api_table().add_object <- function(class_name, name = "", x = 0, y = 0, direction = "auto", data = "", return_object = true) {
	if(name == "") return_object = false
	if(type(data) == "table") data = table_to_sexp(data)
	local unexposed = name.tolower() == "unexposeme"
	if(unexposed) name += "-" + class_name + "-" + rand().tostring()
	if(class_name == "checkpoint") class_name = "firefly" //somebody change this please
	if(class_name == "scriptedobject" && !data.find("(name") && name != "") data += @"(name """ + name + @""")"
	get_sector().settings.add_object(class_name, name, x, y, direction, data)
	if(return_object) {
		while(!(name in get_sector())) wait(0.01)
		local retvalue = get_sector()[name]
		if(unexposed) get_sector()[name] = null // the key cant be deleted because it will throw errors
		return retvalue
	}
}

api_table().replace <- function(string, findstring, replacestring) {
	local newstring = ""
	for(local i = 0; i < string.len(); i++) {
		local a = string.slice(i,  i + 1)
		if(a == findstring) {
			newstring += replacestring
		} else newstring += a
	}
	return newstring
}
