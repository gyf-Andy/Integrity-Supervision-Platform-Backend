package com.integrity.job.util;

import org.quartz.CronExpression;

import java.text.ParseException;
import java.util.Arrays;
import java.util.Date;

/**
 * cron表达式工具类
 *
 * @author Integrity-Supervision-Platform
 */
public class CronUtils {
    /**
     * 返回一个布尔值代表一个给定的Cron表达式的有效性
     *
     * @param cronExpression Cron表达式
     * @return boolean 表达式是否有效
     */
    public static boolean isValid(String cronExpression) {
        return CronExpression.isValidExpression(cronExpression);
    }

    /**
     * 返回一个字符串值,表示该消息无效Cron表达式给出有效性
     *
     * @param cronExpression Cron表达式
     * @return String 无效时返回表达式错误描述,如果有效返回null
     */
    public static String getInvalidMessage(String cronExpression) {
        try {
            new CronExpression(cronExpression);
            return null;
        } catch (ParseException pe) {
            return pe.getMessage();
        }
    }

    /**
     * 返回下一个执行时间根据给定的Cron表达式
     *
     * @param cronExpression Cron表达式
     * @return Date 下次Cron表达式执行时间
     */
    public static Date getNextExecution(String cronExpression) {
        try {
            CronExpression cron = new CronExpression(cronExpression);
            return cron.getNextValidTimeAfter(new Date(System.currentTimeMillis()));
        } catch (ParseException e) {
            throw new IllegalArgumentException(e.getMessage());
        }
    }

    private static final long SECONDLY_THRESHOLD = 60_000L; // 60秒
    private static final long MINUTELY_THRESHOLD = 3_600_000L; // 1小时
    private static final long HOURLY_THRESHOLD = 86_400_000L; // 一天
    private static final long DAILY_THRESHOLD = 86_400_000L * 2; // 两天（用于确保日批）
    private static final long MONTHLY_THRESHOLD = 86_400_000L * 28; // 约一个月（最小月天数）
    private static final long YEARLY_THRESHOLD = 86_400_000L * 365; // 一年

    public static String getCronType(String cron) throws ParseException {
        if (!CronExpression.isValidExpression(cron)) {
            throw new IllegalArgumentException("Invalid cron expression: " + cron);
        }

        CronExpression ce = new CronExpression(cron);

//        // 设置一个固定的参考时间点，例如2024年1月1日0时
//        Calendar cal = Calendar.getInstance();
//        cal.set(2024, Calendar.JANUARY, 1, 0, 0, 0);
//        cal.set(Calendar.MILLISECOND, 0);
//        Date referenceTime = cal.getTime();

        // 获取第一次和第二次触发时间
        Date firstNextTime = ce.getNextValidTimeAfter(new Date());
        if (firstNextTime == null) {
            return "Other"; // 如果无法找到下一次触发时间，则返回其他
        }

        Date secondNextTime = ce.getNextValidTimeAfter(firstNextTime);
        if (secondNextTime == null) {
            return "Other"; // 如果无法找到第二次触发时间，则返回其他
        }

        // 计算两次触发时间之间的时间差
        long interval = secondNextTime.getTime() - firstNextTime.getTime();

        // 根据时间间隔判断任务类型
        if (interval <= SECONDLY_THRESHOLD) { // 60秒内再次触发，可能是秒级任务
            return "Secondly";
        } else if (interval <= MINUTELY_THRESHOLD) { // 1小时内再次触发，可能是分钟任务
            return "Minutely";
        } else if (interval <= HOURLY_THRESHOLD) { // 一天内再次触发，可能是小时任务
            return "Hourly";
        } else if (interval <= DAILY_THRESHOLD) { // 两天内再次触发，可能是日批任务
            return "Daily";
        } else if (interval <= MONTHLY_THRESHOLD) { // 约一个月内再次触发，可能是月批任务
            return "Monthly";
        } else if (interval <= YEARLY_THRESHOLD) { // 一年内再次触发，可能是年批任务
            return "Yearly";
        } else {
            return "Other"; // 超过一年，可能是其他类型的任务
        }
    }

    public static void main(String[] args) {
        // 测试用例
        String[] testCrons = {
                "0/5 * * * * ?",  // 每5秒一次
                "0 0 * * * ?",    // 每小时一次
                "0 0 12 * * ?",   // 每天中午12点
                "0 0 0 1 * ?",    // 每月1号凌晨
                "0 0 0 1 1 ?",    // 每年1月1日凌晨
                "0 0 12 1 1 ?",   // 每年1月1日中午12点
                "0 0 0 * * ?",    // 每天凌晨
                "0 0 0 1 * ?"     // 每月1号凌晨
        };

        Arrays.stream(testCrons).forEach(cron -> {
            try {
                System.out.println("Cron: " + cron + " -> Type: " + getCronType(cron));
            } catch (ParseException e) {
                throw new RuntimeException(e);
            }
        });
    }
}

