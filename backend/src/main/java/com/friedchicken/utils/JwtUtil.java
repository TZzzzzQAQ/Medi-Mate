package com.friedchicken.utils;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;

import java.util.Date;
import java.util.Map;

public class JwtUtil {
    public static String genToken(Map<String, Object> claims,long userTtl,String userSecretKey) {
        return JWT.create()
                .withClaim("claims", claims)
                .withExpiresAt(new Date((System.currentTimeMillis() + userTtl)))
                .sign(Algorithm.HMAC256(userSecretKey));
    }

    public static Map<String, Object> parseToken(String token,String userSecretKey) {
        return JWT.require(Algorithm.HMAC256(userSecretKey))
                .build()
                .verify(token)
                .getClaim("claims")
                .asMap();
    }
}
