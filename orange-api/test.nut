import("orange-api/orange_api_util.nut")

local is_milling = false
local milli = 0

api_table().help <- help

api_table().ping <- function() {
	is_milling = true
	milli = 0
	OThread(function() {
		while(is_milling) {
			wait(0.01)
			milli++
		}
	}).call()
	is_milling = false
	::display("pong! (" + milli.tostring() + " milliseconds)")
}