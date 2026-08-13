module jwt

import time
import deatil.vjwt.jwt as vjwt

pub struct Conf {
pub:
	jwt_key      string
	jwt_aud      string
	jwt_can_days int
}

pub struct JwtClaims {
pub:
	audience string @[json: 'aud'; omitempty]
	expires_at i64 @[json: 'exp'; omitempty]
	issued_at i64 @[json: 'iat'; omitempty]
	user_id string @[json: 'uid'; omitempty]
}

pub const conf = Conf {
	jwt_key: "hujkgtyftgtdfrdft"
	jwt_aud: "example.com"
	jwt_can_days: 30
}

pub fn create_token(user_id string) !string {
	now := time.now()
	exp := now.add_days(conf.jwt_can_days).unix()

	claims := JwtClaims{
		audience: conf.jwt_aud
		expires_at: exp
		issued_at: now.unix()
		user_id: user_id
	}

	mut s := vjwt.signing_method_hs256.new()
	token_string := s.sign[JwtClaims](claims, conf.jwt_key.bytes())!

	return token_string
}

pub fn parse_token(token_string string) !string {
	mut p := vjwt.signing_method_hs256.new()
	parsed := p.parse(token_string, conf.jwt_key.bytes()) or { 
		return error("token parse fail")
	}

	validator := vjwt.Validator.new(parsed)

	if validator.is_permitted_for([conf.jwt_aud]) != true {
		return error("token aud fail")
	}

	now := time.now().unix()
	if validator.is_expired(now) == true {
		return error("token expired")
	}
    
	claims := parsed.get_claims_t[JwtClaims]() or {
		return error("token user_id fail")
	}
	return claims.user_id
}
