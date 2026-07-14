package com.integrity.file;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

/**
 * 文件服务
 * 
 * @author Integrity-Supervision-Platform
 */
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class })
public class IntegrityFileApplication
{
    public static void main(String[] args)
    {
        SpringApplication.run(IntegrityFileApplication.class, args);
        System.out.println("=============== 文件服务模块启动成功 ================");
    }
}


