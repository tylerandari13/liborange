/**
 * @file Houses the OPlayer.
 * @requires moving_obejct
 */
require("moving_obejct")

local moving_object = add_module("player")
// local internal = add_module("_player")

/**
 * @class OMovingObject
 * @extends OMovingObject
 * @description The parallel to SuperTux's Player. Allows for getting more information over what the player is doing.
 */
class OPlayer extends OMovingObject {
    /**
	 * @function get_velocity
	 * @returns {OVector}
	 * @description Returns Tux's velocity as an OVector.
	 */
    function get_velocity() {
        return Ovector(get_velocity_x(), get_velocity_y())
    }

    /**
	 * @function set_velocity
	 * @param {float} x
	 * @param {float} y
	 * @description Sets the velocity to the specified x and y. Works identical to the SuperTux implementation.
	 */
	/**
	 * @function set_velocity
	 * @param {OVector} velocity
	 * @description Sets the velocity to the specified OVector.
	 */
	function set_velocity(...) {
		switch(vargv.len()) {
			case 1: // set_velocity(pos)
				return object.set_velocity(vargv[0].x, vargv[0].y)
			case 2: // set_velocity(x, y)
				return object.set_velocity(vargv[0], vargv[1])
			default:
				throw liborange_texts.error_wrong_param
		}
	}

    /**
	 * @function set_coins
     * @param {int} count
	 * @description Sets Tux's coint count to the specified value.
	 */
    function set_coins(count) {
        add_coins(count - get_coins())
    }

    /**
	 * @function get_action_bonus
	 * @returns {string}
	 * @description Returns Tux's current bonus gotten from his current action.
     * Valid values are "small", "big", "fire", "ice", "air", and "earth".
     * If it fails to find the bonus in an action it will return the whole action.
     * This is especially common with the "gameover" action.
	 */
    function get_action_bonus() {
        local split_action = split(get_action(), "-")
        if(split_action.len() == 3) {
            return split_action[0]
        } else {
            return get_action()
        }
    }

    /**
	 * @function get_generic_action
	 * @returns {string}
	 * @description Returns Tux's current action, without the bonus or the direction.
     * Useful to find out what state Tux is currently in.
     * If it fails to find the state in an action (which is unlikely but not impossible) it will return the whole action.
	 */
    function get_generic_action() {
        local split_action = split(get_action(), "-")
        if(split_action.len() == 3) {
            return split_action[1]
        } else {
            return get_action()
        }
    }

    /**
	 * @function get_action_direction
	 * @returns {string}
	 * @description Returns Tux's current bonus gotten from his current action.
     * Valid values are "left" and "right".
     * If it fails to find the direction in an action it will return the whole action.
     * This is especially common with the "gameover" action.
	 */
    function get_action_direction() {
        local split_action = split(get_action(), "-")
        if(split_action.len() == 3) {
            return split_action[2]
        } else {
            return get_action()
        }
    }
}
