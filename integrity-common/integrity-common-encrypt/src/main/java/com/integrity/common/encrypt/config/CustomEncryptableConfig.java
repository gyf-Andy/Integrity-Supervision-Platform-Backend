package com.integrity.common.encrypt.config;

import com.ulisesbocchio.jasyptspringboot.EncryptablePropertyDetector;
import com.ulisesbocchio.jasyptspringboot.EncryptablePropertyResolver;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

@Component
public class CustomEncryptableConfig {
    @Bean("encryptablePropertyDetector")
    public EncryptablePropertyDetector encryptablePropertyDetector() {
        return new CustomEncryptablePropertyDetector();
    }

    @Bean("encryptablePropertyResolver")
    public EncryptablePropertyResolver encryptablePropertyResolver(EncryptablePropertyDetector encryptablePropertyDetector, Environment environment) {
        return new CustomEncryptablePropertyResolver(encryptablePropertyDetector, environment);
    }
}
