import("liborange.nut")

import("liborange/math.nut")
import("liborange/string.nut")
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
import("liborange/time.nut")
import("liborange/random.nut")
import("liborange/camera.nut")
import("liborange/tween.nut")

import("liborange/debug.nut")

local pos

function test() {
    OMovingObject("rock")
    OMovingObject("indicator")
    OMovingObject("Tux")
    local p = indicator.get_y()
    liborange.signal.process.connect(function() {
        local v = o.rock.get_rect().overlaps(o.Tux.get_rect())
        indicator.set_pos(indicator.get_x(), v ? p : -128)
    })
    liborange.signal.init_process()
}

function test_switch() {
}
