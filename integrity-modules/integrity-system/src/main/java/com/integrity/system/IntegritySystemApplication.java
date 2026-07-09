package com.integrity.system;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.integrity.common.security.annotation.EnableCustomConfig;
import com.integrity.common.security.annotation.EnableIntegrityFeignClients;

/**
 * 系统模块
 * 
 * @author Integrity-Supervision-Platform
 */
@EnableCustomConfig
@EnableIntegrityFeignClients
@SpringBootApplication
public class IntegritySystemApplication
{
    public static void main(String[] args)
    {
        SpringApplication.run(IntegritySystemApplication.class, args);
        System.out.println("=============== 系统模块启动成功  ===============");
    }
}


