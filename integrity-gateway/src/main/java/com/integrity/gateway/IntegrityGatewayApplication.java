package com.integrity.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

/**
 * 网关启动程序
 * 
 * @author Integrity-Supervision-Platform
 */
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class })
public class IntegrityGatewayApplication
{
    public static void main(String[] args)
    {
        SpringApplication.run(IntegrityGatewayApplication.class, args);
        System.out.println("=============== 廉政监管平台网关启动成功 ================");
    }
}


