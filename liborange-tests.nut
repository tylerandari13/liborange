import("liborange.nut")

import("liborange/sexp.nut")
import("liborange/game_object.nut")
import("liborange/thread.nut")
import("liborange/signal.nut")
import("liborange/vector.nut")
import("liborange/rect.nut")
import("liborange/color.nut")
import("liborange/object.nut")
import("liborange/moving_object.nut")
import("liborange/multiplayer.nut")
import("liborange/input.nut")

import("liborange/debug.nut")

function test() {
	liborange.signal.input_pressed.connect(function(input, player) {
		::print("input_pressed: " + input + " : " + player)
	})
	liborange.signal.input_released.connect(function(input, player) {
		::print("input_released: " + input + " : " + player)
	})
	liborange.signal.init_process()
}
