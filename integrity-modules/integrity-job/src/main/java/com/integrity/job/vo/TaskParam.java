package com.integrity.job.vo;

import com.alibaba.fastjson2.JSONObject;
import com.integrity.job.util.ScheduleUtils;
import lombok.Data;
import lombok.ToString;

/**
 * @author liangli_lmj@126.com
 * @date 2024-11-29
 */
@Data
@ToString
public class TaskParam {
    /**
     * 路径或者组件名称
     */
    private String name;
    /**
     * {@link #name} 为路径时，该值为空。实现方式可以查看 {@link ScheduleUtils#getQuartzJobClass}
     */
    private String value;
    /**
     * 跑批日期相减的天数，举例：当需要重跑指定日期的数据时，可以通过该值来指定，也可以直接使用{@link #commandParam}的batchDate字段传入
     */
    private int dateSubtractDay;
    /**
     * 跑批日期
     */
    private String batchDate;
    /**
     * 组件预留字段，供Python、Procedure、Shell、Bean传指定值使用
     * 默认会校验参数中是否有batchDate字段，
     * 跑批日期，当为空时，该值的取值为当前日期减1天
     * <br>
     * 举例：
     * 当一个python跑批全量数据时，可以通过该值传入一个字符串，然后在python中通过该值来判断是否应该跑批全量数据
     * </br>
     */
    private JSONObject commandParam;
}
