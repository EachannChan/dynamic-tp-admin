package com.izpan.infrastructure.config;

import com.izpan.infrastructure.server.AdminServer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AdminConfiguration {

    @Bean
    public AdminServer adminServer() {
        return new AdminServer();
    }
}
