package com.integrity.job;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.integrity.common.security.annotation.EnableCustomConfig;
import com.integrity.common.security.annotation.EnableIntegrityFeignClients;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * 定时任务
 *
 * @author Integrity-Supervision-Platform
 */
@EnableCustomConfig
@EnableIntegrityFeignClients
@SpringBootApplication
@ComponentScan(basePackages = {"com.integrity"})
@EnableScheduling
public class IntegrityJobApplication {
    public static void main(String[] args) {
        SpringApplication.run(IntegrityJobApplication.class, args);
        System.out.println("=============== 定时任务模块启动成功  ===============");
    }
}


