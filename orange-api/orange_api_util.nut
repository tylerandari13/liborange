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

function get_api_table() return get_sector().orange_api

function print(...) {
	local stronk = ""
	foreach(v in vargv) stronk += v.tostring()
	::print("[ORANGE API]" + stronk)
}