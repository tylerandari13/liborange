add_module("signal")

local signal = get_module("signal")

class OSignal {
    connections = []

    function connect(func) {
        if((typeof func) != "function") throw "Cannot connect type \"" + typeof func + "\" to an OSignal. Please only connect functions to OSignals."
        connections.push(func)
    }

    function disconnect(func) {
        local idx = connections.find(func)
        if(idx == null) throw "Attempted to remove function that has not yet been connected."
        connections.remove(idx)
    }
}
