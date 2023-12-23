import("orange-api/orange_api_util.nut")

enum forbidden_keys {
	NULL
	ARRAY
	CLASS
	INSTANCE
	WEAKREF
	THREAD
}

function object_to_state(object) {
	local retobj
	if(object == null) {
		retobj = {orange_API_key = forbidden_keys.NULL}
	} else if(type(object) == "array") {
		retobj = {orange_API_key = forbidden_keys.ARRAY}
		foreach(i, v in object) retobj[i.tostring()] <- object_to_state(v)
	} else if(type(object) == "class") {
		retobj = {orange_API_key = forbidden_keys.CLASS}
		foreach(i, v in object) retobj[i] <- object_to_state(v)
	} else if(type(object) == "weakref") {
		retobj = {orange_API_key = forbidden_keys.WEAKREF}
		retobj.reference <- object_to_state(object.ref())
	} else retobj = object
	::display(retobj)
	return retobj
}

function state_to_object(object) if("orange_API_key" in object) {
	local retobj
	switch(object.orange_API_key) {
		case forbidden_keys.NULL:
			break // do nothing because retobj is already null
		case forbidden_keys.ARRAY:
			retobj = []
			for(local i = 0; i.tostring() in object; i++) retobj.push(state_to_object(object[i.tostring()]))
			break
			case forbidden_keys.CLASS:
				retobj = class{}
				foreach(i, v in object) if(i != "orange_API_key") retobj[i] <- state_to_object(v)
				break
			case forbidden_keys.WEAKREF:
				if(!("weakref_references" in api_storage())) api_storage().weakref_references <- []
				api_storage().weakref_references.push(object.reference)
				retobj = state_to_object(object.reference).weakref()
		default:
			retobj = object
			break
	}
	::display(retobj)
	return retobj
} else return object

api_table().save_state <- function() {}

api_table().load_state <- function() {}

api_table().object_to_state <- object_to_state
api_table().state_to_object <- state_to_object
