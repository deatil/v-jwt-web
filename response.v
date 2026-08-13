module main

import x.json2
import tuntii.viltrum {
	json
}

pub struct JsonData {
pub:
	code int @[json: 'code']
	message string @[json: 'message']
	data ?map[string]json2.Any @[json: 'data'; omitempty]
}

fn return_error(code int, message string) viltrum.Response {
	mut res := JsonData{
		code: code
		message: message
	}

	json_data := json2.encode(res)

	return json(200, json_data)
}

fn return_success(message string, data map[string]json2.Any) viltrum.Response {
	mut res := JsonData{
		code: 0
		message: message
		data: data
	}

	json_data := json2.encode(res)

	return json(200, json_data)
}

