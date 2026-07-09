package com.integrity.job.mapper;

import com.integrity.job.domain.SysJobNotice;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 调度任务日志信息 数据层
 *
 * @author Integrity-Supervision-Platform
 */
public interface SysJobNoticeMapper {

    /**
     * 新增任务日志
     *
     * @param jobNotices 任务队列
     * @return 结果
     */
    public int insert(@Param("jobNotices") List<SysJobNotice> jobNotices);

    public int update(SysJobNotice sysJobNotice);

    public List<SysJobNotice> selectList(SysJobNotice sysJobNotice);
}

