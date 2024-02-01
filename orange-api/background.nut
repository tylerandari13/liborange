class OBackground extends OObject {
	animation_frames = []
	thread = null
	playing = false
	speed = 1

	constructor(name) {
		base.constructor(name)
		thread = newthread(thread_func.bindenv(this))
		thread.call()
	}

	function thread_func() {
		local inc = 0
		while(wait(speed) == null) {
			if(playing && animation_frames.len() > 0) {
				//display(animation_frames[inc % animation_frames.len()])
				set_images("top" in animation_frames[inc % animation_frames.len()] ? animation_frames[inc % animation_frames.len()].top : "images/background/misc/transparent_up.png"
						   "middle" in animation_frames[inc % animation_frames.len()] ? animation_frames[inc % animation_frames.len()].middle : "images/background/misc/transparent_up.png"
						   "bottom" in animation_frames[inc % animation_frames.len()] ? animation_frames[inc % animation_frames.len()].bottom : "images/background/misc/transparent_up.png"
				)
				inc++
			}
		}
	}

	function set_animation_frames(...) animation_frames = vargv
	function add_animation_frame(top = null, middle = null, bottom = null) {
		animation_frames.push({
			top = top != null ? top : "images/background/misc/transparent_up.png"
			middle = middle != null ? middle : "images/background/misc/transparent_up.png"
			bottom = bottom != null ? bottom : "images/background/misc/transparent_up.png"
		})
	}
	function clear_animation_frames() animation_frames = [{}]

	function set_animation_speed(seconds) speed = seconds
	function set_animation_fps(fps) set_animation_speed(fps / 60)

	function play_animation() playing = true
	function pause_animation() playing = false
}

api_table().Background <- OBackground
