// add_module("color")

class OColor {
	r = null
	g = null
	b = null
	a = null

	constructor(...) {
		switch(vargv.len()) {
			case 0: // OColor()
				r = 0
				g = 0
				b = 0
				a = 1
			break
			case 3: // OColor(r, g, b)
				r = vargv[0]
				g = vargv[1]
				b = vargv[2]
				a = 1
			break
			case 4: // OColor(r, g, b ,a)
				r = vargv[0]
				g = vargv[1]
				b = vargv[2]
				a = vargv[3]
			break
			default:
				throw "wrong number of parameters"
			break
		}
	}

	function _add(other) {
		if((typeof other) == "OColor") {
			return OColor(r + other.r, g + other.g, b + other.b, a + other.a)
		} else {
			throw "Cannot add \"" + typeof other + "\" to an OColor. Please only add OColors to OColors."
		}
	}

	function _sub(other) {
		if((typeof other) == "OColor") {
			return OColor(r - other.r, g - other.g, b - other.b, a - other.a)
		} else {
			throw "Cannot subtract \"" + typeof other + "\" from an OColor. Please only subtract OColors from OColors."
		}
	}

	function _mul(other) {
		if((typeof other) == "OColor") {
			return OColor(r * other.r, g * other.g, b * other.b, a * other.a)
		} else if(type(other) == "integer" || type(other) == "float") {
			return OColor(r * other, g * other, b * other, a * other)
		} else {
			throw "Cannot multiply \"" + typeof other + "\" with an OColor. Please only multiply OColors with OColors and numbers."
		}
	}

	function _div(other) {
		if((typeof other) == "OColor") {
			return OColor(r / other.r, g / other.g, b / other.b, a / other.a)
		} else if(type(other) == "integer" || type(other) == "float") {
			return OColor(r / other, g / other, b / other, a / other)
		} else {
			throw "Cannot divide \"" + typeof other + "\" by an OColor. Please only divide OColors by OColors and numbers."
		}
	}

	function modulo(other) {
		if((typeof other) == "OColor") {
			return OColor(r % other.r, g % other.g, b % other.b, a % other.a)
		} else if(type(other) == "integer" || type(other) == "float") {
			return OColor(r % other, g % other, b % other, a % other)
		} else {
			throw "Cannot perform modulo on \"" + typeof other + "\" and an OColor. Please only perform modulo on OColors using OColors and numbers."
		}
	}

	function _unm() {
		return OColor(-x, -y)
	}

	function _typeof() {
		return "OColor"
	}

	function _cloned(original) {
		x = original.x
		y = original.y
	}

	function _tostring() {
		return "OColor(" + x + ", " + y + ")"
	}
}

local hex_letter_to_number = function(hex) {
	switch(hex) {
		case "a":
			return 10
		break
		case "b":
			return 11
		break
		case "c":
			return 12
		break
		case "d":
			return 13
		break
		case "e":
			return 14
		break
		case "f":
			return 15
		break
		default:
			return hex.tointeger()
		break
	}
}

local hex_bit_to_number = function(hex) {
	return (hex_letter_to_number(hex.slice(0)) * 16) + hex_letter_to_number(hex.slice(1))
}

local from_255 = function(r, g, b, a = 255) return OColor(r / 255, g / 255, b / 255, a / 255)

local from_hex = function(hex) {
	if(type(hex) == "string") {
		hex = hex.tolower()
		if(startswith(hex, "#")) {
			hex = hex.slice(1)
		} else if(startswith(hex, "0x")) hex = hex.slice(2)
		return from_255(
			hex_bit_to_number(hex.slice(0, 2)),
			hex_bit_to_number(hex.slice(2, 4)),
			hex_bit_to_number(hex.slice(4, 6)),
			hex_bit_to_number(hex.len() >= 8 ? hex.slice(6, 8) : "ff")
		)
	} else {
		return from_255(
			(hex & 0xFF000000) >> 24,
			(hex & 0x00FF0000) >> 16,
			(hex & 0x0000FF00) >> 8,
			(hex & 0x000000FF)
		)
	}
}

// List taken from Godot's documentation. https://docs.godotengine.org/en/4.1/classes/class_color.html#constants
local colors = {
	ALICE_BLUE = OColor(0.941176, 0.972549, 1)
	ALLIE_PINK = from_hex(0xe41a3e)
	ANTIQUE_WHITE = OColor(0.980392, 0.921569, 0.843137)
	AQUA = OColor(0, 1, 1)
	AQUAMARINE = OColor(0.498039, 1, 0.831373)
	AZURE = OColor(0.941176, 1, 1)
	BAMBI_GREEN = from_hex(0x0db402)
	BEIGE = OColor(0.960784, 0.960784, 0.862745)
	BISQUE = OColor(1, 0.894118, 0.768627)
	BLACK = OColor(0, 0, 0)
	BLANCHED_ALMOND = OColor(1, 0.921569, 0.803922)
	BLUE = OColor(0, 0, 1)
	BLUE_VIOLET = OColor(0.541176, 0.168627, 0.886275)
	BROWN = OColor(0.647059, 0.164706, 0.164706)
	BURLYWOOD = OColor(0.870588, 0.721569, 0.529412)
	CADET_BLUE = OColor(0.372549, 0.619608, 0.627451)
	CHARTREUSE = OColor(0.498039, 1, 0)
	CHOCOLATE = OColor(0.823529, 0.411765, 0.117647)
	CORAL = OColor(1, 0.498039, 0.313726)
	CORNFLOWER_BLUE = OColor(0.392157, 0.584314, 0.929412)
	CORNSILK = OColor(1, 0.972549, 0.862745)
	CRIMSON = OColor(0.862745, 0.0784314, 0.235294)
	CRYSTAL_MINT = from_hex(0x01ff7f)
	CYAN = OColor(0, 1, 1)
	DARK_BLUE = OColor(0, 0, 0.545098)
	DARK_CYAN = OColor(0, 0.545098, 0.545098)
	DARK_GOLDENROD = OColor(0.721569, 0.52549, 0.0431373)
	DARK_GRAY = OColor(0.662745, 0.662745, 0.662745)
	DARK_GREEN = OColor(0, 0.392157, 0)
	DARK_KHAKI = OColor(0.741176, 0.717647, 0.419608)
	DARK_MAGENTA = OColor(0.545098, 0, 0.545098)
	DARK_OLIVE_GREEN = OColor(0.333333, 0.419608, 0.184314)
	DARK_ORANGE = OColor(1, 0.54902, 0)
	DARK_ORCHID = OColor(0.6, 0.196078, 0.8)
	DARK_RED = OColor(0.545098, 0, 0)
	DARK_SALMON = OColor(0.913725, 0.588235, 0.478431)
	DARK_SEA_GREEN = OColor(0.560784, 0.737255, 0.560784)
	DARK_SLATE_BLUE = OColor(0.282353, 0.239216, 0.545098)
	DARK_SLATE_GRAY = OColor(0.184314, 0.309804, 0.309804)
	DARK_TURQUOISE = OColor(0, 0.807843, 0.819608)
	DARK_VIOLET = OColor(0.580392, 0, 0.827451)
	DAVE_BLUE = from_hex(0x2169fe)
	DEEP_PINK = OColor(1, 0.0784314, 0.576471)
	DEEP_SKY_BLUE = OColor(0, 0.74902, 1)
	DEERBUDDY_BROWN = from_hex(0x6f591a)
	DIM_GRAY = OColor(0.411765, 0.411765, 0.411765)
	DODGER_BLUE = OColor(0.117647, 0.564706, 1)
	FIREBRICK = OColor(0.698039, 0.133333, 0.133333)
	FLORAL_WHITE = OColor(1, 0.980392, 0.941176)
	FOREST_GREEN = OColor(0.133333, 0.545098, 0.133333)
	FUCHSIA = OColor(1, 0, 1)
	GAINSBORO = OColor(0.862745, 0.862745, 0.862745)
	GHOST_WHITE = OColor(0.972549, 0.972549, 1)
	GLORBY_GREEN = from_hex(0x77db7d)
	GOLD = OColor(1, 0.843137, 0)
	GOLDENROD = OColor(0.854902, 0.647059, 0.12549)
	GRAY = OColor(0.745098, 0.745098, 0.745098)
	GREEN = OColor(0, 1, 0)
	GREEN_YELLOW = OColor(0.678431, 1, 0.184314)
	HAYWIRE_PURPLE = from_hex(0x890491)
	HONEYDEW = OColor(0.941176, 1, 0.941176)
	HOT_PINK = OColor(1, 0.411765, 0.705882)
	INDIAN_RED = OColor(0.803922, 0.360784, 0.360784)
	INDIGO = OColor(0.294118, 0, 0.509804)
	IVORY = OColor(1, 1, 0.941176)
	KHAKI = OColor(0.941176, 0.901961, 0.54902)
	LAVENDER = OColor(0.901961, 0.901961, 0.980392)
	LAVENDER_BLUSH = OColor(1, 0.941176, 0.960784)
	LAWN_GREEN = OColor(0.486275, 0.988235, 0)
	LEMON_CHIFFON = OColor(1, 0.980392, 0.803922)
	LIGHT_BLUE = OColor(0.678431, 0.847059, 0.901961)
	LIGHT_CORAL = OColor(0.941176, 0.501961, 0.501961)
	LIGHT_CYAN = OColor(0.878431, 1, 1)
	LIGHT_GOLDENROD = OColor(0.980392, 0.980392, 0.823529)
	LIGHT_GRAY = OColor(0.827451, 0.827451, 0.827451)
	LIGHT_GREEN = OColor(0.564706, 0.933333, 0.564706)
	LIGHT_PINK = OColor(1, 0.713726, 0.756863)
	LIGHT_SALMON = OColor(1, 0.627451, 0.478431)
	LIGHT_SEA_GREEN = OColor(0.12549, 0.698039, 0.666667)
	LIGHT_SKY_BLUE = OColor(0.529412, 0.807843, 0.980392)
	LIGHT_SLATE_GRAY = OColor(0.466667, 0.533333, 0.6)
	LIGHT_STEEL_BLUE = OColor(0.690196, 0.768627, 0.870588)
	LIGHT_YELLOW = OColor(1, 1, 0.878431)
	LIME = OColor(0, 1, 0)
	LIME_GREEN = OColor(0.196078, 0.803922, 0.196078)
	LINEN = OColor(0.980392, 0.941176, 0.901961)
	MAGENTA = OColor(1, 0, 1)
	MAROON = OColor(0.690196, 0.188235, 0.376471)
	MARTY_RED = from_hex(0xfb0010)
	MEDIUM_AQUAMARINE = OColor(0.4, 0.803922, 0.666667)
	MEDIUM_BLUE = OColor(0, 0, 0.803922)
	MEDIUM_ORCHID = OColor(0.729412, 0.333333, 0.827451)
	MEDIUM_PURPLE = OColor(0.576471, 0.439216, 0.858824)
	MEDIUM_SEA_GREEN = OColor(0.235294, 0.701961, 0.443137)
	MEDIUM_SLATE_BLUE = OColor(0.482353, 0.407843, 0.933333)
	MEDIUM_SPRING_GREEN = OColor(0, 0.980392, 0.603922)
	MEDIUM_TURQUOISE = OColor(0.282353, 0.819608, 0.8)
	MEDIUM_VIOLET_RED = OColor(0.780392, 0.0823529, 0.521569)
	MIDNIGHT_BLUE = OColor(0.0980392, 0.0980392, 0.439216)
	MINT_CREAM = OColor(0.960784, 1, 0.980392)
	MISTY_ROSE = OColor(1, 0.894118, 0.882353)
	MOCCASIN = OColor(1, 0.894118, 0.709804)
	NAVAJO_WHITE = OColor(1, 0.870588, 0.678431)
	NAVY_BLUE = OColor(0, 0, 0.501961)
	OLD_LACE = OColor(0.992157, 0.960784, 0.901961)
	OLIVE = OColor(0.501961, 0.501961, 0)
	OLIVE_DRAB = OColor(0.419608, 0.556863, 0.137255)
	ORANGE = OColor(1, 0.647059, 0)
	ORANGE_RED = OColor(1, 0.270588, 0)
	ORANGE_JUICE = from_hex(0xff9100)
	ORCHID = OColor(0.854902, 0.439216, 0.839216)
	PALE_GOLDENROD = OColor(0.933333, 0.909804, 0.666667)
	PALE_GREEN = OColor(0.596078, 0.984314, 0.596078)
	PALE_TURQUOISE = OColor(0.686275, 0.933333, 0.933333)
	PALE_VIOLET_RED = OColor(0.858824, 0.439216, 0.576471)
	PAPAYA_WHIP = OColor(1, 0.937255, 0.835294)
	PEACH_PUFF = OColor(1, 0.854902, 0.72549)
	PERU = OColor(0.803922, 0.521569, 0.247059)
	PINK = OColor(1, 0.752941, 0.796078)
	PLUM = OColor(0.866667, 0.627451, 0.866667)
	POWDER_BLUE = OColor(0.690196, 0.878431, 0.901961)
	PURPLE = OColor(0.627451, 0.12549, 0.941176)
	REBECCA_PURPLE = OColor(0.4, 0.2, 0.6)
	RED = OColor(1, 0, 0)
	RODI_RED = from_hex(0xe60000)
	ROSY_BROWN = OColor(0.737255, 0.560784, 0.560784)
	ROYAL_BLUE = OColor(0.254902, 0.411765, 0.882353)
	RUSTY_PURPLE = from_hex(0x540174)
	SADDLE_BROWN = OColor(0.545098, 0.270588, 0.0745098)
	SALMON = OColor(0.980392, 0.501961, 0.447059)
	SANDY_BROWN = OColor(0.956863, 0.643137, 0.376471)
	SEA_GREEN = OColor(0.180392, 0.545098, 0.341176)
	SEASHELL = OColor(1, 0.960784, 0.933333)
	SERVAL_PURPLE = from_hex(0x6f32aa)
	SIENNA = OColor(0.627451, 0.321569, 0.176471)
	SILVER = OColor(0.752941, 0.752941, 0.752941)
	SKY_BLUE = OColor(0.529412, 0.807843, 0.921569)
	SLATE_BLUE = OColor(0.415686, 0.352941, 0.803922)
	SLATE_GRAY = OColor(0.439216, 0.501961, 0.564706)
	SODZ = from_hex(0xff8a7c)
	SNOW = OColor(1, 0.980392, 0.980392)
	SPRING_GREEN = OColor(0, 1, 0.498039)
	STEEL_BLUE = OColor(0.27451, 0.509804, 0.705882)
	TAN = OColor(0.823529, 0.705882, 0.54902)
	TEAL = OColor(0, 0.501961, 0.501961)
	THISTLE = OColor(0.847059, 0.74902, 0.847059)
	TOMATO = OColor(1, 0.388235, 0.278431)
	TRANSPARENT = OColor(1, 1, 1, 0)
	TRISTAN_RED = from_hex(0xf85455)
	TURQUOISE = OColor(0.25098, 0.878431, 0.815686)
	TWANG_BLUE = from_hex(0x1a3aed)
	VIOLET = OColor(0.933333, 0.509804, 0.933333)
	WEB_GRAY = OColor(0.501961, 0.501961, 0.501961)
	WEB_GREEN = OColor(0, 0.501961, 0)
	WEB_MAROON = OColor(0.501961, 0, 0)
	WEB_PURPLE = OColor(0.501961, 0, 0.501961)
	WHEAT = OColor(0.960784, 0.870588, 0.701961)
	WHITE = OColor(1, 1, 1)
	WHITE_SMOKE = OColor(0.960784, 0.960784, 0.960784)
	YELLOW = OColor(1, 1, 0)
	YELLOW_GREEN = OColor(0.603922, 0.803922, 0.196078)
}

local colors_delegate = {
	_get = function(key) {
		if(key == "RANDOM" || key == "RANDOM_NOAPLHA") return colors.random()
		if(key == "RANDOM_APLHA") return colors.random(true)

		throw null
	}
}

colors.from_255 <- from_255
colors.from_888 <- from_255

colors.from_hex <- from_hex

colors.random <- function(random_alpha = false) {
	return from_255(
		rand().tofloat() % 255.0,
		rand().tofloat() % 255.0,
		rand().tofloat() % 255.0,
		(random_alpha ? (rand().tofloat() % 255.0) : 255)
	)
}

colors.print <- function(a = null) {
	if(a != null) {
		::print(a)
	} else {
		local str = "\n"
		foreach(i, v in this) //{
			::print(i)
		//	::print(v)
		//	str += i + " = " + v + "\n"
		//}
		//::display(str + "\n")
	}
}

add_module("color", colors.setdelegate(colors_delegate))
