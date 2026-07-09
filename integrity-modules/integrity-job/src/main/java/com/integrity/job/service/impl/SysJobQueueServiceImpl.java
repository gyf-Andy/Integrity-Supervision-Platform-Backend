package com.integrity.job.service.impl;

import com.integrity.job.domain.SysJobQueue;
import com.integrity.job.mapper.SysJobQueueMapper;
import com.integrity.job.service.ISysJobQueueService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-09
 */
@Service
@RequiredArgsConstructor
public class SysJobQueueServiceImpl implements ISysJobQueueService {
    private final SysJobQueueMapper jobQueueMapper;

    @Override
    public List<SysJobQueue> selectList(SysJobQueue sysJobQueue) {
        return jobQueueMapper.selectList(sysJobQueue);
    }
}
