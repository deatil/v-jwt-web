module main

import x.json2
import tuntii.viltrum {
	json
}

pub type JsonAny = json2.Any

pub struct JsonData {
pub:
	code int @[json: 'code']
	message string @[json: 'message']
	data ?JsonAny @[json: 'data'; omitempty]
}

fn return_error(code int, message string) viltrum.Response {
	mut res := JsonData{
		code: code
		message: message
	}

	json_data := json2.encode(res)

	return json(200, json_data)
}

fn return_success(message string, data JsonAny) viltrum.Response {
	mut res := JsonData{
		code: 0
		message: message
		data: data
	}

	json_data := json2.encode(res)

	return json(200, json_data)
}

