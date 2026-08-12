## v-jwt-web

A v-jwt middleware web.


### Env

 - vlang >= 0.5.2


### Dependency

 - tuntii.viltrum
 - deatil.vjwt


### Run 

```bash
v run .
```

### Request

request login:

```sh
curl -X POST -H "Content-Type: application/json" -d '{"name":"jwt","pass":"123"}' 127.0.0.1:9000/login
```

get user id from:

```sh
curl -X POST -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJleGFtcGxlLmNvbSIsImV4cCI6MTc4OTEzNzI5NiwiaWF0IjoxNzg2NTQ1Mjk2LCJ1aWQiOiJqd3QifQ.0aRoPqvqacmsabjHnkuKQdKjcAfXhvHu3DRa8ypz8Jo" 127.0.0.1:9000/user/profile
```


### LICENSE

*  The library LICENSE is `Apache2`, using the library need keep the LICENSE.


### Copyright

*  Copyright deatil(https://github.com/deatil).
