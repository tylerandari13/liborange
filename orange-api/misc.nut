api_table().char_at_index <- function(string, index) return string.slice(index, api_table().mod_max(index + 1, string.len()))

api_table().distance_from_point_to_point <- distance_from_point_to_point

api_table().table_to_sexp <- function(table) {
	local retstring = ""
	foreach(i, v in table) {
		local retstring2 = ""
		if(type(v) == "string") {
			retstring2 += "(" + i.tostring() + " \"" + v + "\")"
		} else if(type(v) == "bool") {
			retstring2 += "(" + i.tostring() + " " + (v ? "#t" : "#f") + ")"
		} else retstring2 += "(" + i.tostring() + " " + v.tostring() + ")"
		if(i.find("_")) retstring2 += api_table().table_to_sexp({[api_table().replace(i, "_", "-")] = v})
		retstring += retstring2
	}
	return retstring
}

api_table().add_object <- function(class_name, name = "", x = 0, y = 0, direction = "auto", data = "", return_object = true) {
	print(getstackinfos(2).src + " on line " + getstackinfos(2).line)
	print("[liborange] `liborange.add_object()` is deprecated. Please use `liborange.GameObject()` instead.")

	if(name == "") return_object = false
	if(type(data) == "table") data = api_table().table_to_sexp(data)
	local unexposed = name.tolower() == "unexposeme"
	if(unexposed) name += "-" + class_name + "-" + rand().tostring()
	if(class_name == "checkpoint") class_name = "firefly" //somebody change this please
	if(class_name == "scriptedobject" && !data.find("(name") && name != "") data += @"(name """ + name + @""")"
	get_sector().settings.add_object(class_name, name, x, y, direction, data)
	if(return_object) {
		while(!(name in get_sector())) wait(0)
		local retvalue = get_sector()[name]
		if(unexposed) get_sector()[name] = null // the key cant be deleted because it will throw errors
		return retvalue
	}
}

/*api_table().add_object <- function(class_name, name = "", x = 0, y = 0, direction = "auto", data = "", return_object = true) {
	print(getstackinfos(2).src + " on line " + getstackinfos(2).line)
	print("[liborange] `liborange.add_object()` is deprecated. Please use `liborange.GameObject()` instead.")
	local object = api_table().GameObject(class_name)
	object.set_pos(x, y)
	object.direction = direction
	if(type(data) == "string") {
		object.add_raw_data(data)
	} else object.data = data
	return object.initialize({}, return_object)
}*/

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
