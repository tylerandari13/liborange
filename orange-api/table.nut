import("orange-api/orange_api_util.nut")

local actual_indent = "   "

get_api_table().table_to_string <- function(list, indent = actual_indent, index = null) {
	local liststring = indent.slice(0, indent.len() - 3) + ((index == null) ? list.tostring() : index.tostring()) + " = " + ((type(list) == "table") ? "{" : "[") + " (" + type(list) + ")\n"
	foreach(i, v in list) {
		if(type(v) == "array" || type(v) == "table") {
			if(v.len() > 0) {
				get_api_table().table_to_string(v, indent + actual_indent, i)
			} else liststring += indent + actual_indent + "<empty " + type(v) + ">\n"
		} else {
			liststring += indent + i.tostring() + " = " + v.tostring() + " (" + type(v) + ")\n"
		}
	}
	liststring += indent.slice(0, indent.len() - 3) + ((type(list) == "table") ? "}" : "]") + " (end of " + ((index == null) ? list.tostring() : index.tostring()) + ")"
	return liststring
}

get_api_table().display_table <- function(table) {
	display("\n" + get_api_table().table_to_string(table) + "\n")
}