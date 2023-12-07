import("orange-api/orange_api_util.nut")


/*
use like:

class newclass extends liborange.combined_class(class1, class2) {
    constructor() {
        base1.constructor()
        base2.constructor()
    }
}
*/
api_table().combined_class <- function(classa, classb) {
	class newclass {
		base1 = classa.instance()
		base2 = classb.instance()
	}
	foreach(i, v in classa) newclass[i] <- v
	foreach(i, v in classb) newclass[i] <- v
	return newclass
}