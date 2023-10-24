import("orange-api/orange_api_util.nut")

api_table().OObject <- OObject

api_table().convert_to_OObject <- function(sector = get_sector())
    foreach(i, v in sector)
        if(type(v) == "instance" && !("is_OObject" in v))
            OObject(i)