package com.integrity.job.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-02
 */
@Configuration
public class ExecutorConfig {
    @Bean("asyncTaskExecutor")
    public Executor asyncExecutor() {
        ThreadPoolTaskExecutor threadPoolTaskExecutor = new ThreadPoolTaskExecutor();
        //核心线程数
        threadPoolTaskExecutor.setCorePoolSize(4);
        //最大线程数
        threadPoolTaskExecutor.setMaxPoolSize(10);
        //等待队列
        threadPoolTaskExecutor.setQueueCapacity(20);
        //线程前缀
        threadPoolTaskExecutor.setThreadNamePrefix("AsyncTaskExecutor-");
        //线程池维护线程所允许的空闲时间,单位为秒
        threadPoolTaskExecutor.setKeepAliveSeconds(60);
        // 线程池对拒绝任务(无线程可用)的处理策略
        threadPoolTaskExecutor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        threadPoolTaskExecutor.initialize();

        return threadPoolTaskExecutor;
    }
}
