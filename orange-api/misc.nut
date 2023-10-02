import("orange-api/orange_api_util.nut")

get_api_table().mod_min <- function(num, limit) return num < limit ? limit : num

get_api_table().mod_max <- function(num, limit) return num > limit ? limit : num

get_api_table().char_at_index <- function(string, index) return string.slice(index, get_api_table().mod_max(index + 1, string.len()))