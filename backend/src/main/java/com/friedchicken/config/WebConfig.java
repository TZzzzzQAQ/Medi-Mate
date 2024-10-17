package com.friedchicken.config;


import com.friedchicken.interceptor.LoginInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Autowired
    private LoginInterceptor loginInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor).excludePathPatterns(
                "/api/user/login"
                , "/api/user/google-login"
                , "/api/user/register"
                , "/api/message/image"
                , "/api/products/**"
                , "/api/sse/**"
                , "/swagger-ui/index.html#"
                , "/swagger-ui.html"
                , "/v3/api-docs/**"
                , "/swagger-resources/**"
                , "/webjars/**"
                , "/swagger-ui/**");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "PATCH", "UPDATE")
                .allowedHeaders("*")
                .allowCredentials(false)
                .maxAge(3600);
    }
}
