// This packages all of the orange library into one file for on the go... stuff

dofile(getstackinfos(1).src.slice(0, "pocketlib.nut".len() * -1) + "util.nut")

local new_file = "// auto generated by pocketlib.nut\n// This is the entire orange library condensed into one script."

foreach(script in get_scripts())
	new_file += "\n\n// " + script + ".nut\n\n" + read_file("orange-api/" + script + ".nut")

write_file("liborange.nut", new_file)
