package com.integrity.gen;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.integrity.common.security.annotation.EnableCustomConfig;
import com.integrity.common.security.annotation.EnableIntegrityFeignClients;

/**
 * 代码生成
 * 
 * @author Integrity-Supervision-Platform
 */
@EnableCustomConfig
@EnableIntegrityFeignClients
@SpringBootApplication
public class IntegrityGenApplication
{
    public static void main(String[] args)
    {
        SpringApplication.run(IntegrityGenApplication.class, args);
        System.out.println("=============== 代码生成模块启动成功  ===============");
    }
}


