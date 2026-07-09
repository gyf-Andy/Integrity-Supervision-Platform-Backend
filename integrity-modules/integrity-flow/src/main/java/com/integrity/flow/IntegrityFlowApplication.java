package com.integrity.flow;

import com.integrity.common.security.annotation.EnableCustomConfig;
import com.integrity.common.security.annotation.EnableIntegrityFeignClients;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

/**
 * 审批流程
 *
 * @author Integrity-Supervision-Platform
 */
@EnableCustomConfig
@EnableIntegrityFeignClients
@SpringBootApplication
@ComponentScan(basePackages = {"com.integrity"})
public class IntegrityFlowApplication {
    public static void main(String[] args) {
        SpringApplication.run(IntegrityFlowApplication.class, args);
        System.out.println("=============== 廉政监管平台工作流成功 ================");
    }
}


