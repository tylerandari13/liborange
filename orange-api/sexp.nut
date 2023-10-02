import("orange-api/orange_api_util.nut")

class sexp {
	m_str = null

	m_modes = enum {
		DEFAULT
		COMMENT
		STRING
	}
	m_mode = m_modes.DEFAULT

	m_char_index = -1
	m_char = " "

	m_tokens = enum {
		INIT
		OPEN_PARENTHESES
		KEY
		BOOL
		//NUMBER //handled elsewhere
		CLOSE_PARENTHESES
	}
	m_token = tokens.INIT
	m_token_string = ""

	m_line = 1
	m_column = 0

	constructor(str) {
		m_str = str
	}

	function error(e) {
		throw("[ORANGE API S-EXPRESSION ERROR] Line " + getstackinfos(2).line.tostring() + ": " + e)
	}

	function is_whitespace() return m_char == " " || m_char == "\t" || m_char == "\n"

	function is_number() return type(m_char.tointeger()) == "integer" || m_char == "." // periods are counted for decimals

	function next_char() {
		m_char_index++
		m_char = m_str.slice(m_char_index, m_char_index + 1)
		if(m_char == "\n") {
			m_line++
			m_column = 0
		} else m_column++
		return m_char
	}

	function read() {
		local result = {}
		
		while(m_char_index < m_str.len()) {
			next_char()

			if(m_token == tokens.INIT && m_token != "(") error("s-expression file must start with '('")
			while(is_whitespace()) next_char()

			switch(m_char) {
				case "(":
					m_token = m_tokens.OPEN_PARENTHESES
				break

				case ";":
					while(next_char() != "\n") {} // do nothing, its a comment
				break

				case ")":
					m_token = m_tokens.CLOSE_PARENTHESES
				break

				default:
					switch(m_token) {
						case m_tokens.OPEN_PARENTHESES:
							m_token = m_tokens.KEY
							while(!is_whitespace()) {
								m_token_string += m_char
								next_char()
							}
						break

						case m_token.KEY:
							local key = m_token_string
							m_token_string = ""

							switch(m_char) {
								case @"""": // "
									while(next_char() != @"""") m_token_string += m_char
									result[key] = m_token_string
								break

								case "#":
									result[key] = next_char() == "t"
								break

								default:
									if(is_number()) {
										while(is_number()) {
											m_token_string += m_char
											next_char()
										}
										if(m_token_string.tofloat() == m_token_string.tointeger()) {
											result[key] = m_token_string.tointeger()
										} else {
											result[key] = m_token_string.tofloat()
										}
										break
									}
								break
							}
						break
					}
				break
			}
		}
	}
}

get_api_table().sexp_from_string <- function(sexp_string) {
	
}