package com.integrity.modules.monitor;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import de.codecentric.boot.admin.server.config.EnableAdminServer;

/**
 * 监控中心
 * 
 * @author Integrity-Supervision-Platform
 */
@EnableAdminServer
@SpringBootApplication
public class IntegrityMonitorApplication
{
    public static void main(String[] args)
    {
        SpringApplication.run(IntegrityMonitorApplication.class, args);
        System.out.println("=============== 监控中心启动成功 ===============");
    }
}


