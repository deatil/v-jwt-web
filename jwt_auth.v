module main

import tuntii.viltrum

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