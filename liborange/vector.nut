class OVector {
	x = 0
	y = 0

	constructor(...) {
		switch(vargv.len()) {
			case 0: // OVector()
			break
			case 2: // OVector(x, y)
				x = vargv[0]
				y = vargv[1]
			break
		}
	}


}