class ORand {
	seed = 0
	rseed = 0

	constructor(start_seed = rand()) {
		srand(start_seed)
	}

	function rand() return rseed = (rseed * 1103515245 + 12345) & RAND_MAX
	function srand(_seed) {
		seed = _seed
		rseed = _seed
	}

	function get_seed() return seed
	function get_current_seed() return rseed
}

api_table().Rand <- ORand

// when the compatibility is retro
local compatrand = ORand()
api_table().srand <- function(seed) return compatrand.srand(seed)
api_table().rand_seed <- function() return compatrand.rand()
api_table().get_seed <- function() return compatrand.get_seed()
