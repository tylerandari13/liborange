function init_liborange() foreach(file in [
	"bumper"
	"button"
	"camera"
	"class"
	"console"
	"control"
	"grumbel"
	"location"
	"misc"
	"multiplayer"
	"oobject"
	"rand"
	"scriptloader"
	//"sexp"
	"signal"
	"table"
	"test"
	"text"
	"thread"
	"tilemap"
	"trampoline"
]) import("orange-api/" + file + ".nut")

if(!("liborange" in getroottable())) init_liborange()

get_sector().liborange <- getroottable().liborange.weakref()