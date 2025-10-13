package com.ffl.playoffs.infrastructure.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configure(http))
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/games/**", "/api/players/**").permitAll()
                .requestMatchers("/api/admin/**").authenticated()
                .requestMatchers("/docs", "/swagger-ui/**", "/v3/api-docs/**").permitAll()
                .anyRequest().authenticated()
            );
        
        // TODO: Add JWT authentication when ready
        // .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> jwt.configure()));
        
        return http.build();
    }
}
