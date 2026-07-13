package com.integrity.common.core.config;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.autoconfigure.MybatisPlusAutoConfiguration;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import com.github.pagehelper.PageInterceptor;

/**
 * MyBatis-Plus shared configuration.
 */
@AutoConfiguration(after = MybatisPlusAutoConfiguration.class)
@ConditionalOnClass(MybatisPlusInterceptor.class)
public class MybatisPlusConfig
{
    @Bean
    @ConditionalOnMissingBean
    @ConditionalOnProperty(prefix = "integrity.mybatis-plus.pagination", name = "enabled", havingValue = "true")
    public MybatisPlusInterceptor mybatisPlusInterceptor()
    {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.OTHER));
        return interceptor;
    }

    @Bean
    @ConditionalOnMissingBean
    public PageInterceptor pageInterceptor()
    {
        return new PageInterceptor();
    }
}
