::dir <- getstackinfos(1).src.slice(0, "workflow-util/util.nut".len() * -1)

function read_file(path) {
	local the_file = file(dir + path, "r")
	local the_blob = the_file.readblob(the_file.len())

	local thing = ""
	foreach(v in the_blob)
		thing += format("%c", v)

	the_file.close()

	return thing
}

function write_file(path, thing) {
	local the_file = file(dir + path, "w")

	for(local i = 0; i < thing.len(); i++)
		the_file.writen(thing[i], 'b')

	the_file.close()
}

function new_folder(path) {
	system("mkdir " + dir + path)
}

function get_scripts() {
	local retval = []
	foreach(v in split(read_file("liborange.nut"), "\n"))
		if(startswith(v, "\t"))
			retval.push(v.slice(2, -1))
	return retval
}
