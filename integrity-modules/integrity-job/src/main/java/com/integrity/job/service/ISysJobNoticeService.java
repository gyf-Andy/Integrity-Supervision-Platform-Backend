package com.integrity.job.service;

import com.integrity.job.domain.SysJobNotice;

import java.util.List;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-05
 */
public interface ISysJobNoticeService {

    List<SysJobNotice> selectList(SysJobNotice sysJobNotice);

    int update(SysJobNotice sysJobNotice);
}
