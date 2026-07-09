package com.integrity.job.vo;

import com.integrity.job.domain.SysJob;
import com.integrity.job.domain.SysJobDependent;
import lombok.Data;
import lombok.ToString;

import java.util.List;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-02
 */
@Data
@ToString
public class SaveBatchSysJob {
    private SysJob sysJob;

    private List<SysJobDependent> sysJobDependents;
}
