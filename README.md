## v-jwt-web

A v-jwt middleware web.


### Env

 - vlang >= 0.5.2


### Dependency

 - Tuntii.Viltrum >= 0.9.0
 - deatil.vjwt >= 0.1.0


### Run 

install dependencies:
```bash
v install Tuntii.Viltrum
v install deatil.vjwt
```

```bash
v run .
```

### Request

request login:

```bash
curl -X POST \
    -H "Content-Type: application/json" \
    -d '{"name":"jwt","pass":"123"}' \
    127.0.0.1:9000/login
```

request login from form:

```bash
curl -X POST \
    -H "Content-Type: application/x-wwww-form-urlencoded" \
    -d "name=jwt&pass=123" \
    127.0.0.1:9000/login2
```

get user info from:

```bash
curl -X POST \
    -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJleGFtcGxlLmNvbSIsImV4cCI6MTc4OTEzNzI5NiwiaWF0IjoxNzg2NTQ1Mjk2LCJ1aWQiOiJqd3QifQ.0aRoPqvqacmsabjHnkuKQdKjcAfXhvHu3DRa8ypz8Jo" \
    127.0.0.1:9000/user/profile
```


### LICENSE

*  The library LICENSE is `Apache2`, using the library need keep the LICENSE.


### Copyright

*  Copyright deatil(https://github.com/deatil).
