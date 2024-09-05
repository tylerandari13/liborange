/**
 * @file Houses the ORand class for pseudorandom number generation.
 */
add_module("random")

/**
 * @class ORand
 * @description A class which allows for pseudorandom numbers to be generated based on a seed.
 */
class ORand {
	/**
	 * @member {integer} seed
	 * @description The seed of the generator. Does not change after you set it with `set_seed()`.
	 * Prefer using `set_seed()` instead of setting this value.
	 */
	seed = 0

	/**
	 * @member {integer} state
	 * @description The state of the generator. Changes every time you call a function that returns a random number.
	 * Prefer using `set_seed()` instead of setting this value.
	 */
	state = 0

	constructor() {
		randomize()
	}

	/**
	 * @function randi
	 * @description Returns a random integer between 0 and `RAND_MAX`. `RAND_MAX` is a global constant provided by Squirrel.
	 */
	function randi() {
		return state = (state * 1103515245 + 12345) & RAND_MAX
	}

	/**
	 * @function randf
	 * @description Returns a random float between 0 and 1.
	 */
	function randf() {
		return randi().tofloat() / RAND_MAX.tofloat()
	}

	/**
	 * @function randi_range
	 * @param {integer} from
	 * @param {integer} to
	 * @description Returns a random integer between `from` and `to`.
	 */
	function randi_range(from, to) {
		return (randi() % abs(from - (to + 1))) + from
	}

	/**
	 * @function randf_range
	 * @param {float} from
	 * @param {float} to
	 * @description Returns a random float between `from` and `to`.
	 */
	function randf_range(from, to) {
		from = from.tofloat()
		to = to.tofloat()
		local diff = abs(from - (to + 1.0))
		return ((randf() % diff) + from) * diff
	}

	/**
	 * @function set_seed
	 * @param {integer} _seed
	 * @description Sets the seed to `_seed`. Prefer this function over setting the `seed` property.
	 */
	function set_seed(_seed) {
		seed = _seed
		state = seed
	}

	/**
	 * @function randomize
	 * @description Sets the seed to a random value that comes from SuperTux's global `rand` function.
	 */
	function randomize() {
		set_seed(::rand())
	}
}

/**
 * @classend
 */
