local temp
function get_sector() {
	try {
		return sector
	} catch(e) {
		try {
			return worldmap
		} catch(e) {
			return temp
		}
	}
}
if(get_sector() == null) temp = {}

if(!("liborange" in get_sector())) get_sector().liborange <- {}

::liborange <- get_sector().liborange

function add_module(name, mod = {}) {
	if(!(name in liborange))
		liborange[name] <- {}
	foreach(i, v in mod) liborange[name][i] <- v
}

function get_module(name) {
	if(name in liborange) return liborange[name]
}

function require(name) {
	if(!(name in liborange)) {
		throw "The module \"" + name + "\" hasnt been imported yet. Please put `import(\"liborange/" + name + ".nut\") somewhere at the top of your script."
	}
}
