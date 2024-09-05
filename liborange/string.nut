/**
 * @file Houses functions related to strings.
 */

local string = add_module("string")

/**
 * @function replace
 * @param {string} string The string to find stuff to replaced.
 * @param {string} find The string to find in `string`.
 * @param {string} replace The string to replace all instances of `find` with.
 * @description Replaces all instances of `find` in `string` with `replace`.
 */

// FIXME: how did i not notice this can only handle single characters
string.replace <- function(string, find, replace) {
    local new = ""
	for(local i = 0; i < string.len(); i++) {
		local a = string.slice(i,  i + 1)
		if(a == find) {
			new += replace
		} else {
			new += a
		}
	}
	return new
}

/**
 * @function char_at_index
 * @param {string} string The string to find the character in.
 * @param {string} index The index to find the character at.
 * @description Gets the character at the specified index as a string.
 */
string.char_at_index <- function(string, index) return format("%c", string[index])
