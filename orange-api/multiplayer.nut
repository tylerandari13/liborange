api_table().get_players <- get_players

api_table().for_all_players <- function(func = function(){}) {
	if(type(func) == "string") func = compilestring(func)
	local retarray = {}
	foreach(i, v in get_players()) {
		local that = this
		that.Tux <- v
		retarray[i] <- rawcall(func, that)
	}
	return retarray
}

api_table().nearest_player <- get_nearest_player
