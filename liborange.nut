/**
 * @file The core of all liborange modules.
 * @description This file must be imported before any modules can be added. The functions listed here are used internally and only meant for modules.
 */

local temp

/**
 * @function get_sector
 * @return {table}
 * @description Tries to return the current sector or worldmap sector and returns an empty table if neither are found.
 */
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

/**
 * @function add_module
 * @param {string} name The name of the new module.
 * @param {table} mod The contents of this table will be added to the new module.
 * @default mod {}
 * @return {table} Returns the new module table, *not* the table you gave it.
 * @description Adds a module to liborange.
 */
function add_module(name, mod = {}) {
	if(!(name in liborange))
		liborange[name] <- {}
	foreach(i, v in mod) liborange[name][i] <- v
	return liborange[name]
}

/**
 * @function get_module
 * @param {string} name The name of the module you want to get.
 * @return {table|null} If no module with the given name exists then null is returned instead.
 * @description Returns the module with the given name.
 */
function get_module(name) {
	if(name in liborange) return liborange[name]
}

/**
 * @function require
 * @param {string} name The name of the required module.
 * @description If a module requires another module to operate, use this at the top of the file to specify that module is needed.
 * If no module with the given name exists then an error will be thrown.
 */
function require(name) {
	if(!(name in liborange)) {
		throw "The module \"" + name + "\" hasnt been imported yet. Please put `import(\"liborange/" + name + ".nut\") somewhere at the top of your script."
	}
}
