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

function add_module(name) {
	if(!(name in liborange)) {
		liborange[name] <- {}
	}
}

function require(name) {
	if(!(name in liborange)) {
		throw "[liborange] The module \"" + name + "\" doesnt exist. Please put `import(\"liborange/" + name + "\".nut) somewhere at the top of your script."
	}
}
