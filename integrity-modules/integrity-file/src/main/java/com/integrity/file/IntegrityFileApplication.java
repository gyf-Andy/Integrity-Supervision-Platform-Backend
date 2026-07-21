package com.integrity.file;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.Import;
import com.integrity.system.api.RemoteFileRecordService;
import com.integrity.system.api.factory.RemoteFileRecordFallbackFactory;

/**
 * 文件服务
 * 
 * @author Integrity-Supervision-Platform
 */
// 文件服务只启用文件元数据登记客户端，避免扫描不需要的远程接口。
@EnableFeignClients(clients = RemoteFileRecordService.class)
@Import(RemoteFileRecordFallbackFactory.class)
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class })
public class IntegrityFileApplication
{
    public static void main(String[] args)
    {
        SpringApplication.run(IntegrityFileApplication.class, args);
        System.out.println("=============== 文件服务模块启动成功 ================");
    }
}


