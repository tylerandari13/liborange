import("orange-api/orange_api_util.nut")

api_table().min <- function(num, limit) return num < limit ? limit : num

api_table().max <- function(num, limit) return num > limit ? limit : num

api_table().char_at_index <- function(string, index) return string.slice(index, api_table().mod_max(index + 1, string.len()))