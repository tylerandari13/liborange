class OGameObject {
	RAW = 0

	_class_name = null
	name = ""
	x = 0
	y = 0
	direction = "auto"
	data = null

	data_string = ""

	constructor(classname, _name = "", _x = 0, _y = 0, _direction = "auto", _data = null) {
		RAW = ::rand().tostring()
		_class_name = classname
		name = _name
		x = _x
		y = _y
		direction = _direction
		data = (_data == null) ? {} : _data
	}

	function set_pos(_x, _y) {
		x = _x
		y = _y
	}

	function set_data(key, value) {
		data[key] <- value
	}

	function get_data(key) {
		return key in data ? data[key] : null
	}

	function has_data(key) {
		return key in data
	}

	function delete_data(key) {
		delete data[key]
	}

	function add_raw_data(string) {
		data[string] <- RAW
	}

	function parse_data() {
		data_string = ""
		foreach(i, v in data) {
			if(v == RAW) {
				data_string += i + "\n"
				continue
			}
			data_string += ::api_table().table_to_sexp({[i] = v}) + "\n"
		}
	}

	function initialize(overrides = {}, return_object = true) {
		parse_data()
		local unexposed = false
		local x_ = x
		local y_ = y
		local name_ = "name" in overrides ? overrides.name : name
		local class_name_ = "class_name" in overrides ? overrides.class_name : class_name
		if("pos_x" in overrides) x_ = overrides.pos_x
		if("pos_y" in overrides) y_ = overrides.pos_y
		if("x" in overrides) x_ = overrides.x
		if("y" in overrides) y_ = overrides.y
		if(return_object && name_ == "") {
			name_ = "unexposeme-" + ::rand()
			unexposed = true
		}
		if(class_name_ == "scriptedobject") {
			set_data("name", name_)
			parse_data()
		}
		::get_sector().settings.add_object(class_name_, name_, x_, y_, "direction" in overrides ? overrides.direction : direction, data_string)
		if(!return_object) return
		//local guh = 0
		while(!(name_ in ::get_sector())) {
		//	guh++
			wait(0)
		}
		//::print("[liborange] Took " + guh + " frames to spawn " + name_ + ".")
		local obj = ::get_sector()[name_]
		if(unexposed) ::get_sector()[name_] = null // the key cant be deleted or it will throw errors
		return obj
	}

	function print_sexp() {
		parse_data()
		::display("\n" + api_table().replace("(" + class_name +
				"\n(name \"" + name +
				"\")\n(x " + x +
				")\n(y " + y +
				")\n(direction \"" + direction +
				"\")\n" + data_string,
				"\n", "\n  ") + "\n)\n")
	}

	function _set(key, value) {
		if(key == "class_name") {
			value = value.tolower()
			if(value == "checkpoint") {
				return _class_name = "firefly"
			} else {
				return _class_name = value
			}
		}
		if(key == "pos_x") return x = value
		if(key == "pos_y") return y = value

		set_data(key, value)
	}

	function _get(key) {
		if(key == "class_name") {
			if(_class_name == "firefly") {
				return "checkpoint"
			} else {
				return _class_name
			}
		}
		if(key == "pos_x") return x
		if(key == "pos_y") return y

		if(has_data(key)) return get_data(key)

		throw null
	}

	function _newslot(key, value) {
		set_data(key, value)
	}

	function _delslot(key) {
		delete_data(key)
	}
}

api_table().GameObject <- OGameObject
