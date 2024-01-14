enum directions {
	AUTO
	LEFT
	RIGHT
	UP
	DOWN
}

function dir_to_int(dir) switch(dir) {
	case directions.LEFT:
	case directions.UP:
		return -1
	case directions.RIGHT:
	case directions.DOWN:
		return 1
	default:
		return 0
}

class OBadguy extends OObject {
	health = null
	direction = null

	constructor(name, _direction = directions.AUTO, _health = 1) {
		health = _health
		if(_direction = directions.AUTO) {
			direction = get_nearest_player(get_x(), get_y()).get_x() > get_x() ? directions.RIGHT : directions.LEFT
		} else direction = _direction
		base.constructor(name)
	}

	function is_burnable() return true
	function is_freezable() return true
	function is_slideable() return true

	function touched() {}

	function kill() {}

	function ignite() if(is_burnable()) kill()
}

class OWalkingBadguy extends OBadguy {
	speed = null
	is_walking = false
	thread = null

	constructor(name, _direction = directions.AUTO, _speed = 80, _health = 1) {
		speed = _speed
		if(_direction = directions.AUTO) {
			direction = get_nearest_player(get_x(), get_y()).get_x() > get_x() ? directions.RIGHT : directions.LEFT
		} else direction = _direction
		base.constructor(name, _direction, _health)
		thread = OThread(thread_func.bindenv(this))
		thread.call()
	}

	function thread_func() {
		while(wait(0.01) == null) {
			if(get_x() == 0 && is_walking) turn_around()
		}
	}

	function walk() {
		is_walking = true
		set_velocity(speed * dir_to_int(direction), get_y())
	}

	function stop_walking() {
		is_walking = false
		set_velocity(0, get_y())
	}

	function turn_around() {
		switch(direction) {
			case directions.LEFT:
				direction = directions.RIGHT
				break
			case directions.RIGHT:
				direction = directions.LEFT
				break
		}
		if(is_walking) walk()
	}
}

api_table().Badguy <- OBadguy

api_table().WalkingBadguy <- OWalkingBadguy
