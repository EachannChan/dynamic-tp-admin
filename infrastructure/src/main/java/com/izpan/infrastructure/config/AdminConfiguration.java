package com.izpan.infrastructure.config;

import com.izpan.infrastructure.server.AdminServer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;

@Configuration
public class AdminConfiguration {

    @Bean
    @Lazy(false)
    public AdminServer adminServer() {
        return new AdminServer();
    }
}
