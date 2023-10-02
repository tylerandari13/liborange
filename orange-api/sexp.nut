import("orange-api/orange_api_util.nut")

function min(x, limit) {
    return x < limit ? limit : x
}

function max(x, limit) {
    return x > limit ? limit : x
}

function schar(str, idx) {
	return str.slice(idx, max(idx+1, str.len()))
}

function ttostring(tab) {
    local resp = "{\n"
    foreach (k, v in tab) {
        resp += "\t" + k + ": " + v.tostring() + "\n"
    }
    resp += "}"
    return resp
}

enum Token {
    INIT,
    OPEN_PARENTHESES,
    KEY,
    STRING,
    NUMBER,
    BOOL,
    CLOSE_PARENTHESES
}

class Lexer {
    m_str = ""

    // lexer char index
    // -1 means it hasnt started
    m_lci = -1
    // lexer char
    m_lc = " "

    m_token = Token.INIT
    m_token_string = ""

    constructor(str) { m_str = str }

    function log(msg) {
        print("SEXP INFO: " + msg + "\n")
    }

    function next_char() {
        m_lci++
        m_lc = schar(m_str, m_lci)
		wait(0.01)
        //log("Next char: " + m_lc)
        return m_lc
    }

    function read() {
        local resp = {}
        while (m_lci < m_str.len()) {
            next_char()

            if (m_token == Token.INIT && m_lc != "(") throw "SEXP ERROR: sexp must start with \"(\""
            while (m_lc == " ") next_char()

            switch (m_lc) {

                case "(":
                    log("Found open parentheses.")
                    m_token = Token.OPEN_PARENTHESES
                    break
            
                default:
                    switch (m_token) {
                        case Token.OPEN_PARENTHESES:
                            m_token = Token.KEY
                            log("Parsing key...")
                            while (m_lc != " ") {
                                m_token_string += m_lc
                                //log("Added to token string")
                                next_char()
                            }
                            log("Parsed key: " + m_token_string)

                            break
                            
                        case Token.KEY:
                            local key = m_token_string
                            m_token_string = ""

                            switch (m_lc) {
                                case @"""": // "
                                    m_token = Token.STRING
                                    
                                    log("Parsing string...")
                                    while (next_char() != @"""" || schar(m_str, m_lci-1) == "\\") {
                                        m_token_string += m_lc
                                    }
                                    log("Parsed string: " + m_token_string)
                                    resp[key] <- m_token_string

                                    break;

                                case "#":
                                    resp[key] <- (next_char() == "t")
                                    log("Parsed bool: #" + m_lc)
                                    break;
                                
                                default:
                                    
                                    break;
                            }
                            break
                    }
                    break
            }
        }
        return resp
    }
}

get_api_table().sexp_from_string <- function(sexp_string) {
	
}