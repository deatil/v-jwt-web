module main

import x.json2

import tuntii.viltrum {
	new
	recover
	cors
	text
	json
	Request
	Response
}

fn main() {
	mut app := new()
	app.use(recover)
	app.use(cors('*'))

	app.get('/', fn (req Request) Response {
		return text(200, 'v-jwt\n')
	})

	app.get('/hi/:name', fn (req Request) Response {
		name := req.param('name') or { 'world' }
		return json(200, '{"hi":"${name}"}')
	})

	// > curl -X POST -H "Content-Type: application/json" -d '{"name":"jwt","pass":"123"}' 127.0.0.1:9000/login
	app.post('/login', fn (req Request) Response {
		name := req.json_string('name') or { 
			return return_error(1, "name is required")
		}
		pass := req.json_string('pass') or { 
			return return_error(1, "pass is required")
		}

		if name != "jwt" {
			return return_error(1, "name is error")
		}
		if pass != "123" {
			return return_error(1, "pass is error")
		}

		token := create_token(name) or {
			return return_error(1, "create_token is error")
		}

		mut data := map[string]json2.Any{}
		data["token"] = json2.Any(token)

		return return_success("ok", data)
	})

	// > curl -X POST -H "X-JWT: token" 127.0.0.1:9000/user/profile
	// > curl -X POST -H "Authorization: token" 127.0.0.1:9000/user/profile
	// > curl -X POST -H "Authorization: Bearer token" 127.0.0.1:9000/user/profile
	// > curl -X POST -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJleGFtcGxlLmNvbSIsImV4cCI6MTc4OTEzNzI5NiwiaWF0IjoxNzg2NTQ1Mjk2LCJ1aWQiOiJqd3QifQ.0aRoPqvqacmsabjHnkuKQdKjcAfXhvHu3DRa8ypz8Jo" 127.0.0.1:9000/user/profile
    app.mount('/user', fn (mut m viltrum.Mount) {
		m.use(jwt_auth)

        m.post('/profile', fn (req viltrum.Request) viltrum.Response {
			user_id := req.headers.get_or('user_id', '')

			mut data := map[string]json2.Any{}
			data["uid"] = json2.Any(user_id)

			return return_success("ok", data)
        })
    })

	app.listen('127.0.0.1:9000') or { panic(err) }
}

fn jwt_auth(next viltrum.Handler) viltrum.Handler {
	return fn [next] (req viltrum.Request) viltrum.Response {
		header_value := req.headers.get_or('Authorization', '')
		if header_value.len == 0 {
			return return_error(1, "authorizationh is required")
		}

		if header_value.starts_with('Bearer ') == false {
			return return_error(1, "token is required")
		}

		token := header_value[7..].trim_space()
		if token.len == 0 {
			return return_error(1, "Invalid token format")
		}

		user_id := parse_token(token) or {
			return return_error(1, err.msg())
		}

		req.headers.set("user_id", user_id)

		resp := next(req)

		return resp
	}
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

