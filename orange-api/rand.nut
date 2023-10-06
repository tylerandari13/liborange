import("orange-api/orange_api_util.nut")

local seed = 0

local rseed = 0

api_table().srand <- function(_seed) {
	seed = _seed
	rseed = _seed
}

api_table().rand_seed <- function() return rseed = (rseed * 1103515245 + 12345) & RAND_MAX

api_table().get_seed <- function() return seed