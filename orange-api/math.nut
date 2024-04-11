api_table().min <- function(...) {
	local smallest
	foreach(v in vargv)
		if(smallest == null || v < smallest)
			smallest = v
	return smallest
}

api_table().max <- function(...) {
	local biggest
	foreach(v in vargv)
		if(biggest == null || v > biggest)
			biggest = v
	return biggest
}

api_table().round <- function(x) return x - floor(x) < 0.5 ? floor(x) : ceil(x)
