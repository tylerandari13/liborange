/**
 * @file Houses functions to help tween properties.
 * @description See the [Supertux Source](https://github.com/SuperTux/supertux/blob/master/src/math/easing.cpp) for a list of all the avaliable easings
 * and the [Easing Functions Cheat Sheet](https://easings.net/) for what they look like.
 * @requires math
 * @requires time
 */
require("math")
require("time")

local tween = add_module("tween")

local get_easing = function(easing) {
	if(typeof easing == "string") {
		if(startswith(easing.tolower(), "ease"))
			easing = easing.slice(4)
		if(easing.tolower() == "none") return tween.easings.LinearInterpolation
		return tween.easings[easing]
	}
	return easing
}

// easings taken from https://github.com/SuperTux/supertux/blob/master/src/math/easing.cpp
tween.easings <- {
	// Modeled after the line y = x.
	LinearInterpolation = function(p) {
		return p
	}

	// Modeled after the parabola y = x^2.
	QuadraticIn = function(p) {
		return p * p
	}

	// Modeled after the parabola y = -x^2 + 2x.
	QuadraticOut = function(p) {
		return -(p * (p - 2))
	}

	// Modeled after the piecewise quadratic:
	// y = (1/2)((2x)^2)              [0, 0.5)
	// y = -(1/2)((2x-1)*(2x-3) - 1)  [0.5, 1]
	QuadraticInOut = function(p) {
		if(p < 0.5) {
			return 2 * p * p
		} else {
			return (-2 * p * p) + (4 * p) - 1
		}
	}

	// Modeled after the cubic y = x^3.
	CubicIn = function(p) {
		return p * p * p
	}

	// Modeled after the cubic y = (x - 1)^3 + 1.
	CubicOut = function(p) {
		local f = (p - 1)
		return f * f * f + 1
	}

	// Modeled after the piecewise cubic:
	// y = (1/2)((2x)^3)        [0, 0.5)
	// y = (1/2)((2x-2)^3 + 2)  [0.5, 1]
	CubicInOut = function(p) {
		if(p < 0.5) {
			return 4 * p * p * p
		} else {
			local f = ((2 * p) - 2)
			return 0.5 * f * f * f + 1
		}
	}

	// Modeled after the quartic x^4.
	QuarticIn = function(p) {
		return p * p * p * p
	}

	// Modeled after the quartic y = 1 - (x - 1)^4.
	QuarticOut = function(p) {
		local f = (p - 1)
		return f * f * f * (1 - p) + 1
	}

	// Modeled after the piecewise quartic.
	// y = (1/2)((2x)^4)         [0, 0.5)
	// y = -(1/2)((2x-2)^4 - 2)  [0.5, 1]
	QuarticInOut = function(p)  {
		if(p < 0.5) {
			return 8 * p * p * p * p
		} else {
			local f = (p - 1)
			return -8 * f * f * f * f + 1
		}
	}

	// Modeled after the quintic y = x^5.
	QuinticIn = function(p)  {
		return p * p * p * p * p
	}

	// Modeled after the quintic y = (x - 1)^5 + 1.
	QuinticOut = function(p)  {
		local f = (p - 1)
		return f * f * f * f * f + 1
	}

	// Modeled after the piecewise quintic:
	// y = (1/2)((2x)^5)        [0, 0.5)
	// y = (1/2)((2x-2)^5 + 2)  [0.5, 1]
	QuinticInOut = function(p)  {
		if(p < 0.5) {
			return 16 * p * p * p * p * p
		} else {
			local f = ((2 * p) - 2)
			return  0.5 * f * f * f * f * f + 1
		}
	}

	// Modeled after quarter-cycle of sine wave.
	SineIn = function(p) {
		return sin((p - 1) * (PI / 2)) + 1
	}

	// Modeled after quarter-cycle of sine wave (different phase).
	SineOut = function(p) {
		return sin(p * (PI / 2))
	}

	// Modeled after half sine wave.
	SineInOut = function(p) {
		return 0.5 * (1 - cos(p * PI))
	}

	// Modeled after shifted quadrant IV of unit circle.
	CircularIn = function(p) {
		return 1 - sqrt(1 - (p * p))
	}

	// Modeled after shifted quadrant II of unit circle.
	CircularOut = function(p) {
		return sqrt((2 - p) * p)
	}

	// Modeled after the piecewise circular function:
	// y = (1/2)(1 - sqrt(1 - 4x^2))            [0, 0.5)
	// y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1)  [0.5, 1]
	CircularInOut = function(p) {
		if(p < 0.5) {
			return 0.5 * (1 - sqrt(1 - 4 * (p * p)))
		} else {
			return 0.5 * (sqrt(-((2 * p) - 3) * ((2 * p) - 1)) + 1)
		}
	}

	// Modeled after the exponential function y = 2^(10(x - 1)).
	ExponentialIn = function(p) {
		return (p == 0.0) ? p : pow(2, 10 * (p - 1))
	}

	// Modeled after the exponential function y = -2^(-10x) + 1.
	ExponentialOut = function(p) {
		return (p == 1.0) ? p : 1 - pow(2, -10 * p)
	}

	// Modeled after the piecewise exponential:
	// y = (1/2)2^(10(2x - 1))          [0,0.5)
	// y = -(1/2)*2^(-10(2x - 1))) + 1  [0.5,1]
	ExponentialInOut = function(p) {
		if(p == 0.0 || p == 1.0) return p

		if(p < 0.5) {
			return 0.5 * pow(2, (20 * p) - 10)
		} else {
			return -0.5 * pow(2, (-20 * p) + 10) + 1
		}
	}

	// Modeled after the damped sine wave y = sin(13pi/2*x)*pow(2, 10 * (x - 1)).
	ElasticIn = function(p) {
		return sin(13 * (PI / 2) * p) * pow(2, 10 * (p - 1))
	}

	// Modeled after the damped sine wave y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1.
	ElasticOut = function(p) {
		return sin(-13 * (PI / 2) * (p + 1)) * pow(2, -10 * p) + 1
	}

	// Modeled after the piecewise exponentially-damped sine wave:
	// y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))       [0,0.5)
	// y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2)  [0.5, 1]
	ElasticInOut = function(p) {
		if(p < 0.5) {
			return 0.5 * sin(13 * (PI / 2) * (2 * p)) * pow(2, 10 * ((2 * p) - 1))
		} else {
			return 0.5 * (sin(-13 * (PI / 2) * ((2 * p - 1) + 1)) * pow(2, -10 * (2 * p - 1)) + 2)
		}
	}

	// Modeled after the overshooting cubic y = x^3-x*sin(x*pi).
	BackIn = function(p) {
		return p * p * p - p * sin(p * PI)
	}

	// Modeled after overshooting cubic y = 1-((1-x)^3-(1-x)*sin((1-x)*pi)).
	BackOut = function(p) {
		local f = (1 - p)
		return 1 - (f * f * f - f * sin(f * PI))
	}

	// Modeled after the piecewise overshooting cubic function:
	// y = (1/2)*((2x)^3-(2x)*sin(2*x*pi))            [0, 0.5)
	// y = (1/2)*(1-((1-x)^3-(1-x)*sin((1-x)*pi))+1)  [0.5, 1]
	BackInOut = function(p) {
		if(p < 0.5) {
			local f = 2 * p
			return 0.5 * (f * f * f - f * sin(f * PI))
		} else {
			local f = (1 - (2*p - 1))
			return 0.5 * (1 - (f * f * f - f * sin(f * PI))) + 0.5
		}
	}

	BounceIn = function(p) {
		return 1 - BounceOut(1 - p)
	}

	BounceOut = function(p) {
		if(p < 4/11.0) {
			return (121 * p * p)/16.0
		} else if(p < 8/11.0) {
			return (363/40.0 * p * p) - (99/10.0 * p) + 17/5.0
		} else if(p < 9/10.0) {
			return (4356/361.0 * p * p) - (35442/1805.0 * p) + 16061/1805.0
		} else {
			return (54/5.0 * p * p) - (513/25.0 * p) + 268/25.0
		}
	}

	BounceInOut = function(p) {
		if(p < 0.5) {
			return 0.5 * BounceIn(p*2)
		} else {
			return 0.5 * BounceOut(p * 2 - 1) + 0.5
		}
	}
}

/**
 * @function property
 * @param {float} original The original value so the tween knows where to start.
 * @param {float} target The target value where the tweened property will end up.
 * @param {function} setter The function that sets the property. Usually looks something like `@(i) property = i` if you use a
 * [lambda](http://squirrel-lang.org/squirreldoc/reference/language/functions.html#lambda-expressions).
 * @param {float} time_seconds The time it takes for the property to reach its target.
 * Please call `liborange.timer.init_fps_counter` for a more accurate time measurement.
 * @param {string|function} easing If it is a string it will get one of the easings defined in the
 * [Supertux Source](https://github.com/SuperTux/supertux/blob/master/src/math/easing.cpp),
 * and if its a function it will use the passed function as the easing.
 * @default easing "None"
 * @description Tweens a property over the given time. Do note this function suspends the script when it runs.
 * If you would not like this please run the script in a thread.
 */
//TODO: allow for tweening OVectors and OColors
tween.property <- function(original, target, setter, time_seconds, easing = "None") {
	easing = get_easing(easing)
	local frames = (liborange.time.get_fps() * time_seconds).tofloat()
	for(local i = 0; i < 1; i += (1.0 / frames)) {
		setter(
			liborange.math.lerp(
				original,
				target,
				easing(i)
			)
		)
		::wait(0)
	}
}

/**
 * @function property
 * @param {string|function} _in The easing the new function starts with.
 * @param {string|function} out The easing the new function ends with.
 * @description Makes a new function that seamlessly combines the given easings.
 * For example if you wanted an easing that started as Sine but ended as Bounce you would type
 * `liborange.tween.combined("EaseSineIn", "EaseBounceOut")`. This cn be passed into the `easing` property of
 * `liborange.tween.property`.
 */
tween.combined <- function(_in, out) {
	_in = get_easing(_in)
	out = get_easing(out)
	return function(p) {
		if(p < 0.5) {
			return 0.5 * _in(p*2)
		} else {
			return 0.5 * out(p * 2 - 1) + 0.5
		}
	}
}
