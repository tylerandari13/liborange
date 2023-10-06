import("orange-api/orange_api_util.nut")

api_table().help <- help

api_table().ping <- function() {
	display("pong!")
}