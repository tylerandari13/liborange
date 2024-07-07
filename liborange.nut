function get_sector() {
	try {
		return sector
	} catch(e) {
		try {
			return worldmap
		} catch(e) {
			return {}
		}
	}
}

if(!("liborange" in get_sector())) get_sector().liborange <- {}

::liborange <- get_sector().liborange

function add_module(name, mod = {}) {
	if(!(name in liborange))
		liborange[name] <- {}
	foreach(i, v in mod) liborange[name][i] <- v
}

function require(name) {
	if(!(name in liborange)) {
		throw "The module \"" + name + "\" hasnt been imported yet. Please put `import(\"liborange/" + name + ".nut\") somewhere at the top of your script."
	}
}

function add_consts(_class, consts) {
	foreach(i, v in consts)
		_class[i] <- v
}
