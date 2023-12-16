import("orange-api/orange_api_util.nut")
// This file adds new stuff to the console so it can function.

::console <- getconsttable()

/*
local help_text = "Heres some commands to try:\n"
+ "`liborange_respond(\"github\")` - links you to the Orange Library Github repo. Check the wiki there for tips on how to use the Orange Library.\n"
+ "`liborange_respond(\"github\")`\n"
+ "Note: You can scroll through the console with the PageUp and PageDown keys."

function console::liborange_init_script_loader() {
	Level.liborange_console_response <- ""
	local wait_for_response = function(message = null) {
		if(message != null) display(message)
		while(Level.liborange_console_response == "") wait(0.01)
		local resp = Level.liborange_console_response
		Level.liborange_console_response = ""
		return resp
	}
	Level.liborange_script_loader_thread <- OThread(function() {
		display(@"Welcome to the Orange Library script loader. Type `liborange_respond(""help"")` for help.")
		while(wait(0.01) == null) {
			local response = wait_for_response().tolower()
			if(response == "help") display(help_text)
		}
	})
	Level.liborange_script_loader_thread.call()
}

function console::liborange_respond(message) Level.liborange_console_response = message
*/

function console::liborange_init_script_loader() load_level("levels/test2/script_loader.stl")

setconsttable(console)