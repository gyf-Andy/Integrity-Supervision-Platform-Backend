package com.integrity.auth;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import com.integrity.common.security.annotation.EnableIntegrityFeignClients;

/**
 * 认证授权中心
 * 
 * @author Integrity-Supervision-Platform
 */
@EnableIntegrityFeignClients
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class })
public class IntegrityAuthApplication
{
    public static void main(String[] args)
    {
        SpringApplication.run(IntegrityAuthApplication.class, args);
        System.out.println("=============== 认证授权中心启动成功 ===============");
    }
}


