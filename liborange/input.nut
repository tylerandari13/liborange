/**
 * @file Houses the input related signals.
 * @requires signal
 */
require("signal")

local input = add_module("input")

/**
 * @member {array} inputs
 * @description An array of all the possible inputs one can use with `Tux.get_input_pressed()`.
 */
input.inputs <- [
	"left"
	"right"
	"up"
	"down"
	"jump"
	"action"
	"start"
	"escape"
	"menu-select"
	"menu-select-space"
	"menu-back"
	"remove"
	"cheat-menu"
	"debug-menu"
	"console"
	"peek-left"
	"peek-right"
	"peek-up"
	"peek-down"
]

/**
 * @signal input_pressed
 * @param {string} input The input that the player pressed.
 * @param {string} player The player that pressed the input.
 * @description Called whenever a player pressed an input.
 */
/*
 * @signal input_held
 * @param {string} input The input that the player has held.
 * @param {string} player The player thats holding the input.
 * @description Called every frame a player is holding an input.
 */
/**
 * @signal input_released
 * @param {string} input The input that the player released.
 * @param {string} player The player that released the input.
 * @description Called whenever a player released an input.
 */
liborange.signal.process.connect(function() {
	local players = liborange.multiplayer.get_players()
	foreach(input in input.inputs)
		foreach(player in players) {
			if(player.get_input_pressed(input)) liborange.signal.get_signal("input_pressed").call(input, player)
			//if(player.get_input_held(input)) liborange.signal.get_signal("input_held").call(input, player)
			if(player.get_input_released(input)) liborange.signal.get_signal("input_released").call(input, player)
		}
})
