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

	// > curl -X GET 127.0.0.1:9000/
	app.get('/', fn (req Request) Response {
		return text(200, 'v-jwt\n')
	})

	// > curl -X GET 127.0.0.1:9000/hi/x-jwt
	app.get('/hi/:name', fn (req Request) Response {
		name := req.param('name') or { 'world' }

		mut data := map[string]json2.Any{}
		data["hi"] = json2.Any(name)

		return return_success("ok", json2.Any(data))
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

		mut more := map[string]json2.Any{}
		more["uid"] = json2.Any(name)

		mut data := map[string]json2.Any{}
		data["token"] = json2.Any(token)
		data["more"] = json2.Any(more)

		return return_success("ok", json2.Any(data))
	})

	// > curl -X POST -H "Content-Type: application/x-wwww-form-urlencoded" -d "name=jwt&pass=123" 127.0.0.1:9000/login2
	app.post('/login2', fn (req Request) Response {
		name := req.form_value('name') or { 
			return return_error(1, "name is required")
		}
		pass := req.form_value('pass') or { 
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

		return return_success("ok", json2.Any(data))
	})

    app.mount('/user', fn (mut m viltrum.Mount) {
		m.use(jwt_auth)

		// > curl -X POST -H "X-JWT: token" 127.0.0.1:9000/user/profile
		// > curl -X POST -H "Authorization: token" 127.0.0.1:9000/user/profile
		// > curl -X POST -H "Authorization: Bearer token" 127.0.0.1:9000/user/profile
		// > curl -X POST -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJleGFtcGxlLmNvbSIsImV4cCI6MTc4OTEzNzI5NiwiaWF0IjoxNzg2NTQ1Mjk2LCJ1aWQiOiJqd3QifQ.0aRoPqvqacmsabjHnkuKQdKjcAfXhvHu3DRa8ypz8Jo" 127.0.0.1:9000/user/profile
        m.post('/profile', fn (req viltrum.Request) viltrum.Response {
			user_id := req.headers.get_or('user_id', '')

			mut data := map[string]json2.Any{}
			data["uid"] = json2.Any(user_id)

			return return_success("ok", json2.Any(data))
        })
    })

	app.listen('127.0.0.1:9000') or { panic(err) }
}



