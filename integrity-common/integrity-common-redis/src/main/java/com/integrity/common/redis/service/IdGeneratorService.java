package com.integrity.common.redis.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.TimeUnit;

/**
 * @author liangli_lmj@126.com
 * @date 2024-11-23
 */
@Component
public class IdGeneratorService {
    @Autowired
    private RedisService redisService;

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd");

    public String generateId(String modulePrefix) {
        String dateTimePart = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        String key = modulePrefix + "_" + LocalDateTime.now().toLocalDate().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        Long sequence = redisService.increment(key, 1);

        // 如果序列号为1，表示这是今天第一次生成ID，设置过期时间
        if (sequence == 1) {
            long expireTimeInSeconds = LocalDateTime.now().plusDays(1).withHour(0).withMinute(0).withSecond(0).toEpochSecond(java.time.ZoneOffset.UTC) - System.currentTimeMillis() / 1000;
            redisService.expire(key, expireTimeInSeconds, TimeUnit.SECONDS);
        }

        String sequencePart = String.format("%06d", sequence);
        return modulePrefix + dateTimePart + sequencePart;
    }
}
