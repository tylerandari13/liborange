class OTether {
	tethered_objects = null

	constructor(name, ...) {
		tethered_objects = []
		foreach(v in vargv) {
			switch(::type(v)) {
				case "string":
					tethered_objects.push(::get_sector()[v])
				break
				default:
					tethered_objects.push(v)
				break
			}
		}
		if(name != "" && name != null) ::get_sector()[name] <- this
	}

	function _set(key, value) {
		foreach(v in tethered_objects)
			if(key in v)
				v[key] = value
	}

	function _get(key) {
		local retval = []
		local functions = true
		foreach(i, v in tethered_objects)
			if(key in v) {
				retval.insert(i, v[key])
				if(::type(v[key]) != "function") functions = false
			}
		if(functions) {
			return function[this](...) {
				local retval2 = []
				foreach(i, v in retval)
					retval2.push(v.acall([tethered_objects[i]].extend(vargv)))
				return retval2
			}
		} else {
			return retval
		}
	}
}
