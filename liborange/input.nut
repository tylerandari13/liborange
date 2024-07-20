require("signal")

local input = add_module("input")

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

liborange.signal.process.connect(function() {
	local players = liborange.multiplayer.get_players()
	foreach(input in input.inputs)
		foreach(player in players) {
			if(player.get_input_pressed(input)) liborange.signal.get_signal("input_pressed").call(input, player)
			//if(player.get_input_held(input)) liborange.signal.get_signal("input_held").call(input, player)
			if(player.get_input_released(input)) liborange.signal.get_signal("input_released").call(input, player)
		}
})
