import("orange-api/orange_api_util.nut")

api_table().OObject <- OObject

api_table().convert_to_OObject <- function(sector = get_sector())
	foreach(i, v in sector)
		if(type(v) == "instance" && !("is_OObject" in v))
			OObject(i)

api_table().init_objects <- function(obj_name, obj_class, ...) {
	local params = (vargv.len() > 0 && type(vargv[0]) == "array") ? vargv[0] : vargv
	foreach(i, v in sector)
		if(startswith(i, obj_name) && !("is_OObject" in v))
			obj_class.instance().constructor.acall([obj_class.instance(), i].extend(params))
}
