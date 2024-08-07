/**
 * @file Houses s-expression related functions.
 */
add_module("sexp")

/**
 * @enum SexpMode
 * @member WANDER
 * @member TOKEN
 * @member NUMBER
 * @member STRING
 * @member BOOL
 * @description The mode for the sexp functions state machine. Used internally, so don't worry about it.
 */
enum SexpMode {
	WANDER,
	TOKEN,
	NUMBER,
	STRING,
	BOOL
}

local sexp = get_module("sexp")

local is_whitespace = function(str) {
	switch(str) {
		case " ":
		case "\t":
		case "\n":
		case "\r":
		case "\f":
		case "\v":
		case "\u00A0":
		case ")": // ")" is not whitespace but it should act as such
			return true
	}
	return false
}

/**
 * @function from_array
 * @param {array} arr
 * @return {string}
 * @description Returns a string of s-expression containing the data given.
 */
sexp.from_array <- function(arr) {
	local final = "("
	foreach(v in arr) {
		if(arr.find(v) == 0) {
			final += v + " "
		} else {
			switch(typeof v) {
				case "bool":
					final += v ? "#t" : "#f"
				break
				case "array":
					final += callee()(v)
				break
				case "integer":
				case "float":
					final += v
				break
				case "string":
				default:
					final += "\"" + escape(v.tostring()) + "\""
				break
			}
			final += " "
		}
	}
	return final.slice(0, -1) + ")"
}

/**
 * @function to_array
 * @param {string} atr
 * @return {array}
 * @description Returns the data passed in as an s-expression string.
 */
// FIXME: This could be implemented better. It cannot handle strings with a ")".
sexp.to_array <- function(str) {
	local final = []
	local mode = SexpMode.WANDER

	local cache = ""

	local i = 0
	while(i < str.len()) {
		local letter = str.slice(i, i + 1)

		switch(mode) {
			case SexpMode.TOKEN:
				if(is_whitespace(letter)) {
					final.push(cache)
					mode = SexpMode.WANDER
				} else {
					cache += letter.tostring()
				}
			break
			case SexpMode.NUMBER:
				if(is_whitespace(letter)) {
					final.push(cache.tofloat())
					mode = SexpMode.WANDER
				} else {
					cache += letter.tostring()
				}
			break
			case SexpMode.STRING:
				if(letter == "\"") {
					final.push(cache)
					mode = SexpMode.WANDER
				} else {
					cache += letter.tostring()
				}
			break
			case SexpMode.BOOL:
				switch(letter) {
					case "t":
						final.push(true)
					break
					case "f":
						final.push(false)
					break
				}
			break

			case SexpMode.WANDER:
				switch(letter) {
					case "(":
						if(final.len() == 0) {
							mode = SexpMode.TOKEN
						} else {
							local temp_str = str.slice(i)
							local until_end = temp_str.find(")")
							local temp_str = temp_str.slice(0, until_end + 1)
							final.push(callee()(temp_str))
							i += until_end
						}
					break
					case ")":
						mode = -1
					break
					case "#":
						mode = SexpMode.BOOL
					break
					default:
						try {
							if(typeof letter.tofloat() == "float") {
								i--
								mode = SexpMode.NUMBER
								cache = ""
							}
						} catch(e) {}
					break
				}
			break
		}
		i++
	}
	return final
}
