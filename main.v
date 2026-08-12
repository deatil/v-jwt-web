module main

import x.json2

import khalyomede.mantis.http { create_app, App, Response, RouteMiddlewares }
import khalyomede.mantis.http.route

fn main() {
	app := create_app(
		cpus: 8
		port: 9000
		routes: [
			route.get(path: "/", callback: fn (app App) !Response {
				return app.response.html(content: "hello world")
			}),
			// > curl -X POST -d "name=jwt&pass=123" 127.0.0.1:9000/login
			route.post(path: "/login", callback: fn (app App) !Response {
				name := app.request.form("name") or { 
					return app.response.html(content: "name is required")
				}
				pass := app.request.form("pass") or { 
					return app.response.html(content: "name is required")
				}

				token := create_token(name)!

				mut data := map[string]string{}
				data["name"] = name
				data["pass"] = pass
				data["token"] = token

				json_data := json2.encode(data)

				return app.response.html(content: json_data)
			}),
			// > curl -X POST -H "Authorization: Bearer token" 127.0.0.1:9000/user/profile
			// > curl -X POST -d "token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJleGFtcGxlLmNvbSIsImV4cCI6MTc4OTEwNjgzNCwiaWF0IjoxNzg2NTE0ODM0LCJ1aWQiOiJqd3QifQ.bFIT_vp0RRwYW_wjRTlwBXymHF8KCebVWM1xaqGJomk" 127.0.0.1:9000/user/profile
			// > curl -X POST -H "Authorization: Bearer token" -d "token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJleGFtcGxlLmNvbSIsImV4cCI6MTc4OTEwNjgzNCwiaWF0IjoxNzg2NTE0ODM0LCJ1aWQiOiJqd3QifQ.bFIT_vp0RRwYW_wjRTlwBXymHF8KCebVWM1xaqGJomk" 127.0.0.1:9000/user/profile
			route.post(
				path: "/user/profile"
				middlewares: RouteMiddlewares{
					before_response_rendered: [
						fn (app App) !Response {
							headers := app.request.headers.clone()
							println("headers: ${headers}")

							return app.response.set_header("X-Powered-By", "v-jwt")
						}
					]
				}
				callback: fn (app App) !Response {
					token := app.request.form("token") or { 
						return app.response.html(content: "token is required")
					}

					user_id := parse_token(token) or {
						return app.response.html(content: err.msg())
					}

					return app.response.html(content: "user_id: ${user_id}")
				}
			),
		]
	)

	app.serve() or { panic(err) }
}

