/**
 * @file Houses math related functions, like distance.
 */

local math = add_module("math")


/**
 * @function distance
 * @param {OVector} pos1
 * @param {OVector} pos2
 * @return {float}
 * @description Returns the distance between the two given positions.
 */
/**
 * @function distance
 * @param {float} x1
 * @param {float} y1
 * @param {float} x2
 * @param {float} y2
 * @description Returns the distance between the four given numbers.
 */
math.distance <- function(...) {
	local x1 = 0
	local y1 = 0
	local x2 = 0
	local y2 = 0
	switch(vargv.len()) {
		case 2: // math.distance(pos1, pos2)
			x1 = vargv[0].x
			x2 = vargv[1].x
			y1 = vargv[0].y
			y2 = vargv[1].y
		break
		case 4: // math.distance(x1, y1, x2, y2)
			x1 = vargv[0]
			x2 = vargv[2]
			y1 = vargv[1]
			y2 = vargv[3]
		break
		default:
			throw liborange_texts.error_wrong_param
		break
	}
	return sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2))
}

/**
 * @function min
 * @param {...}
 * @return {float}
 * @description Returns the smallest number of the numbers given.
 */
math.min <- function(...) {
	local smallest
	foreach(v in vargv)
		if(smallest == null || v < smallest)
			smallest = v
	return smallest
}

/**
 * @function max
 * @param {...}
 * @return {float}
 * @description Returns the largest number of the numbers given.
 */
math.max <- function(...) {
	local biggest
	foreach(v in vargv)
		if(biggest == null || v > biggest)
			biggest = v
	return biggest
}

/**
 * @function lerp
 * @param {float} a
 * @param {float} b
 * @param {float} f
 * @return {float}
 * @description Returns a linear interpolation between a and b given f.
 */
math.lerp <- @(a, b, f) (a * (1.0 - f)) + (b * f)
