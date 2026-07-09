package com.integrity.job.service;

import com.integrity.job.domain.SysJobQueue;

import java.util.List;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-09
 */
public interface ISysJobQueueService {
    List<SysJobQueue> selectList(SysJobQueue sysJobQueue);
}
