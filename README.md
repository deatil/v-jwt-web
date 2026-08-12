## v-jwt-web

V-jwt web test


### Env

 - vlang >= 0.5.2


### Dependency

 - khalyomede.mantis
 - deatil.vjwt


### Run 

```bash
v run .
```

### Request

create token:

```bash
curl -X POST -d "name=jwt&pass=123" 127.0.0.1:9000/login
```

get token user id:

```bash
curl -X POST -d "token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJleGFtcGxlLmNvbSIsImV4cCI6MTc4OTEwNjgzNCwiaWF0IjoxNzg2NTE0ODM0LCJ1aWQiOiJqd3QifQ.bFIT_vp0RRwYW_wjRTlwBXymHF8KCebVWM1xaqGJomk" 127.0.0.1:9000/user/profile
```


### LICENSE

*  The library LICENSE is `Apache2`, using the library need keep the LICENSE.


### Copyright

*  Copyright deatil(https://github.com/deatil).
