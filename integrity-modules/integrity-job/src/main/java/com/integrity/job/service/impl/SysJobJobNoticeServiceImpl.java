package com.integrity.job.service.impl;

import com.integrity.job.domain.SysJobNotice;
import com.integrity.job.mapper.SysJobNoticeMapper;
import com.integrity.job.service.ISysJobNoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-05
 */
@Service
@RequiredArgsConstructor
public class SysJobJobNoticeServiceImpl implements ISysJobNoticeService {
    private final SysJobNoticeMapper jobNoticeMapper;

    @Override
    public List<SysJobNotice> selectList(SysJobNotice sysJobNotice) {
        return jobNoticeMapper.selectList(sysJobNotice);
    }

    @Override
    public int update(SysJobNotice sysJobNotice) {
        sysJobNotice.setIfHandle("Y".equals(sysJobNotice.getIfHandle()) ? "N" : "Y");
        return jobNoticeMapper.update(sysJobNotice);
    }
}
