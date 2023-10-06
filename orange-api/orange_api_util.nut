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

if(!("orange_api" in get_sector())) get_sector().orange_api <- {}

function api_table() return get_sector().orange_api

function help() {
	display_text_file("orange-api/help.stxt")
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

	function _get(key) {
		if(key in object) {
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