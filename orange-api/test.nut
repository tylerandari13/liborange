import("orange-api/orange_api_util.nut")

get_api_table().help <- help

get_api_table().ping <- function() {
	display("pong!")
}