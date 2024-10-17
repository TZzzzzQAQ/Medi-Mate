package com.friedchicken.config;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Getter
@Configuration
public class JwtConfig {

    @Value("${fc.jwt.admin-token-name}")
    private String adminTokenName;

    @Value("${fc.jwt.user-token-name}")
    private String userTokenName;

}
