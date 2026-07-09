package com.integrity.common.core.constant;

import java.util.Arrays;
import java.util.List;

/**
 * 任务调度通用常量
 * 
 * @author Integrity-Supervision-Platform
 */
public class ScheduleConstants
{
    public static final String TASK_CLASS_NAME = "TASK_CLASS_NAME";

    /** 执行目标key */
    public static final String TASK_PROPERTIES = "TASK_PROPERTIES";

    /** 解析后的执行参数key */
    public static final String TASK_PARAMS = "TASK_PARAMS";

    /** 任务依赖key */
    public static final String TASK_DEPENDENT = "TASK_DEPENDENT";

    /** 任务运行模式key */
    public static final String TASK_RUN_MODE = "TASK_RUN_MODE";

    /** 任务依赖ID key */
    public static final String TASK_DEPENDENT_ID = "TASK_DEPENDENT_ID";

    /** 默认 */
    public static final String MISFIRE_DEFAULT = "0";

    /** 立即触发执行 */
    public static final String MISFIRE_IGNORE_MISFIRES = "1";

    /** 触发一次执行 */
    public static final String MISFIRE_FIRE_AND_PROCEED = "2";

    /** 不触发立即执行 */
    public static final String MISFIRE_DO_NOTHING = "3";

    /** Bean执行器 */
    public static final String BEAN = "bean";

    /** 存储过程执行器 */
    public static final String PROCEDURE = "procedure";

    /** Python执行器 */
    public static final String PYTHON = "python";

    /** Shell执行器 */
    public static final String SHELL = "shell";

    /** 日期相减天数参数 */
    public static final String DATE_SUBTRACT_DAY = "dateSubtractDay";

    /** 立即执行 */
    public static final String EXECUTE_IMMEDIATELY = "EXECUTE_IMMEDIATELY";

    /** 定时执行 */
    public static final String TIMED_EXECUTION = "TIMED_EXECUTION";

    /** 异常执行 */
    public static final String EXCEPTION_EXECUTION = "EXCEPTION_EXECUTION";

    /** 秒、分、小时批次不做日期回退 */
    public static final List<String> BATCH_TYPE_DEFAULTS = Arrays.asList("SECOND", "MINUTE", "HOUR");

    public enum Status
    {
        /**
         * 正常
         */
        NORMAL("0"),
        /**
         * 暂停
         */
        PAUSE("1");

        private String value;

        private Status(String value)
        {
            this.value = value;
        }

        public String getValue()
        {
            return value;
        }
    }

    public enum BatchType
    {
        /**
         * 秒任务
         */
        SECOND("SECOND", "yyyyMMddHHmmss"),
        /**
         * 分钟任务
         */
        MINUTE("MINUTE", "yyyyMMddHHmm"),
        /**
         * 小时
         */
        HOUR("HOUR", "yyyyMMddHH"),
        /**
         * 天
         */
        DAY("DAY", "yyyyMMdd"),
        /**
         * 月
         */
        MONTH("MONTH", "yyyyMM"),
        /**
         * 年
         */
        YEAR("YEAR", "yyyy");

        private final String key;

        private final String value;

        BatchType(String key, String value)
        {
            this.key = key;
            this.value = value;
        }

        public String getKey()
        {
            return key;
        }

        public String getValue()
        {
            return value;
        }

        public static String getBatchTypeValue(String key)
        {
            for (BatchType batchType : BatchType.values())
            {
                if (batchType.getKey().equals(key))
                {
                    return batchType.getValue();
                }
            }
            return null;
        }

        public static String getBatchTypeKey(String key)
        {
            for (BatchType batchType : BatchType.values())
            {
                if (batchType.getKey().equals(key))
                {
                    return batchType.getKey();
                }
            }
            return null;
        }
    }
}

