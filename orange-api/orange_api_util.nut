function get_sector() {
	try {
		return sector
	} 	catch(e) {
		try {
			return worldmap
		} catch(e) {
			return {}
		}
	}
}

function api_table() return get_sector().liborange

if(!("liborange" in get_sector())) get_sector().liborange <- {}
if(!("orange_api" in get_sector())) get_sector().orange_api <- class {
	theref = null
	constructor(weak) {
		theref = weak
	}
	function _get(key) {
		::display(@"The function `""orange-api." + key + @"()""` is deprecated, please use `liborange." + key + "()` instead.")
		return theref[key]
	}
}(api_table().weakref())


function help() {
	display_text_file("orange-api/help.stxt")
}

function get_players() {
    local arroy = []
    foreach(i, v in get_sector()) if("use_scripting_controller" in v) arroy.push(v)
    return arroy
}

class OObject {
	static is_OObject = true

	object = null
	odata = null

	constructor(obj) {
		odata = {} // we dont want all odatas to point to the same table
		if("is_OObject" in get_sector()[obj]) {
			object = get_sector()[obj].object
		} else object = get_sector()[obj]
		delete get_sector()[obj]
		get_sector()[obj] <- this
	}

	function _get(key) { // returning just the function doesnt work for some reason 
		if(key == "get_x" && "get_pos_x" in object) {
			return function() {
				return object.get_pos_x()
			}
		} else if(key == "get_y" && "get_pos_y" in object) {
			return function() {
				return object.get_pos_y()
			}
		} else if(key in object) {
			if(type(object[key]) == "function") {
				return function(...) {
					switch(vargv.len()) { // worst workaround yet
						case 0:
							return object[key]()
						break
						case 1:
							return object[key](vargv[0])
						break
						case 2:
							return object[key](vargv[0], vargv[1])
						break
						case 3:
							return object[key](vargv[0], vargv[1], vargv[2])
						break
						case 4:
							return object[key](vargv[0], vargv[1], vargv[2], vargv[3])
						break
						case 5:
							return object[key](vargv[0], vargv[1], vargv[2], vargv[3], vargv[4])
						break
						case 6:
							return object[key](vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5])
						break
						case 7:
							return object[key](vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6])
						break
						case 8:
							return object[key](vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7])
						break
						case 9:
							return object[key](vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8])
						break
						case 10:
							return object[key](vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9])
						break
					}
				}
			} else {
				return object[key]
			}
		} else if(key in odata) {
			return odata[key]
		}
		throw null
	}

	function _set(key, value) {
		if(key in odata) return odata[key] = value
		throw null
	}

	function _newslot(key, value) {
		return odata[key] <- value
	}
	
	function _delslot(key) {
		return delete odata[key]
    }
}

// convert all instances to OObjects
//foreach(i, v in get_sector()) if(type(v) == "instance") OObject(i)