package com.integrity.common.security.config;

import java.math.BigInteger;
import java.util.TimeZone;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;

/**
 * 系统配置
 *
 * @author Integrity-Supervision-Platform
 */
@AutoConfiguration
public class ApplicationConfig
{
    /**
     * Jackson 配置
     */
    @Bean
    public Jackson2ObjectMapperBuilderCustomizer jacksonObjectMapperCustomization()
    {
        return jacksonObjectMapperBuilder -> jacksonObjectMapperBuilder
                .timeZone(TimeZone.getDefault())
                .serializerByType(Long.class, BigNumberSerializer.INSTANCE)
                .serializerByType(Long.TYPE, BigNumberSerializer.INSTANCE)
                .serializerByType(BigInteger.class, BigNumberSerializer.INSTANCE);
    }
}

