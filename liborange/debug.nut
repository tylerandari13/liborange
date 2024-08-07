/**
 * @file Supposed to house debug related functions. Do not use as it is unfinished.
 * @requires sexp
 */
local debug = add_module("debug")

debug.error_test <- function(...) {
	::display(vargv)
}

debug.debugger <- function(event_type, sourcefile, line, funcname) {
	local fname = funcname ? funcname : "unknown"
	local srcfile = sourcefile ? sourcefile : "unknown"
	switch(event_type) {
		case 'l': //called every line(that contains some code)
			::print("Line:")
			::print("LINE line [" + line + "] func [" + fname + "]")
			::print("file [" + srcfile + "]\n")
		break
		case 'c': //called when a function has been called
			::print("Function called:")
			::print("LINE line [" + line + "] func [" + fname + "]")
			::print("file [" + srcfile + "]\n")
		break
		case 'r': //called when a function returns
			::print("Function returned:")
			::print("LINE line [" + line + "] func [" + fname + "]")
			::print("file [" + srcfile + "]\n")
		break
	}
	::print(" ")
}

debug.error_lines_only <- function() {

}
