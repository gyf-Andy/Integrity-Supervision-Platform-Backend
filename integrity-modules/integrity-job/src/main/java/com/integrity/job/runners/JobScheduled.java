package com.integrity.job.runners;

import com.integrity.common.core.constant.CacheConstants;
import com.integrity.common.core.exception.job.TaskException;
import com.integrity.common.core.utils.DateUtils;
import com.integrity.common.redis.service.RedisService;
import com.integrity.job.domain.SysJobDependent;
import com.integrity.job.domain.SysJobMonitor;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.mapper.SysJobDependentMapper;
import com.integrity.job.publishlistener.runjobgroup.TimedJobGroupEvent;
import com.integrity.job.service.ISysJobMonitorService;
import com.integrity.job.util.ScheduleUtils;
import com.integrity.job.vo.TaskParam;
import com.integrity.system.api.domain.SysDictData;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executor;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-09
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class JobScheduled {
    private final RedisService redisService;

    private final SysJobDependentMapper jobDependentMapper;

    private final Scheduler scheduler;

    private final ISysJobMonitorService jobMonitorService;

    private final ApplicationEventPublisher applicationEventPublisher;

    @Qualifier("asyncTaskExecutor")
    private final Executor asyncTaskExecutor;

    /**
     * 每天0点更新
     */
    @Scheduled(cron = "0 0 0 1 * ?")
    public void dayTaskScheduled() {
        long startTime = System.currentTimeMillis();
        log.info("日批开始加载....");
        Boolean switchFlag = getSwitchFlag("job_day_switch");

        if (switchFlag) {
            addScheduleJob("DAY");
        }
        log.info("日批加载完成, 共耗时[{}]毫秒....", (System.currentTimeMillis() - startTime));
    }

    /**
     * 每月1号0点更新
     */
    @Scheduled(cron = "0 0 0 1 * ?", zone = "Asia/Shanghai")
    public void monthTaskScheduled() {
        long startTime = System.currentTimeMillis();
        log.info("月批开始加载....");
        Boolean switchFlag = getSwitchFlag("job_month_switch");

        if (switchFlag) {
            addScheduleJob("MONTH");
        }
        log.info("月批加载完成, 共耗时[{}]毫秒....", (System.currentTimeMillis() - startTime));
    }

    /**
     * 每年一月一号0点更新
     */
    @Scheduled(cron = "0 0 0 1 1 ?", zone = "Asia/Shanghai")
    public void yearTaskScheduled() {
        long startTime = System.currentTimeMillis();
        log.info("年批开始加载....");
        Boolean switchFlag = getSwitchFlag("job_year_switch");

        if (switchFlag) {
            addScheduleJob("YEAR");
        }
        log.info("年批加载完成, 共耗时[{}]毫秒....", (System.currentTimeMillis() - startTime));
    }

    /**
     * 五分钟一次定时任务
     */
    @Scheduled(cron = "0 0/5 * * * ?")
    public void fiveMinuteTask() {
        long startTime = System.currentTimeMillis();
        log.debug("五分钟一次定时任务开始加载....");
        String batchDate = DateUtils.currentDateMinusDay(1, "DAY");
        String detectTaskLabelArray = redisService.getCacheObject(CacheConstants.SYS_CONFIG_KEY + "detecting_task_label");
        String[] split = detectTaskLabelArray.split("_");
        String detectTaskLabel = split[0];
        String detectTaskCount = split[1];
        int detectTaskCountInt = Integer.parseInt(detectTaskCount);
        List<SysJobMonitor> waitSysJobMonitors = jobMonitorService.selectByStatus(batchDate, detectTaskLabel, "0");
        if (CollectionUtils.isEmpty(waitSysJobMonitors)) {
            log.debug("五分钟一次定时任务检测需要刷新的任务为0,结束调用....");
            return;
        }

        List<SysJobMonitor> executeSysJobMonitors = jobMonitorService.selectByStatus(batchDate, detectTaskLabel, "2");
        if (detectTaskCountInt <= executeSysJobMonitors.size()) {
            log.debug("五分钟一次定时任务检测正在跑批数量[{}]大于配置数量[{}],结束调用....", executeSysJobMonitors.size(), detectTaskCountInt);
            return;
        }
        int aboutToBeAdjustCount = detectTaskCountInt - executeSysJobMonitors.size();
        List<SysJobMonitor> aboutToBeAdjustMonitors = jobMonitorService.aboutToBeAdjustMonitors(batchDate, detectTaskLabel, aboutToBeAdjustCount);
        for (SysJobMonitor aboutToBeAdjustMonitor : aboutToBeAdjustMonitors) {
            String jobId = aboutToBeAdjustMonitor.getJobId();
            CompletableFuture.runAsync(() -> {
                applicationEventPublisher.publishEvent(new TimedJobGroupEvent(this, jobId, null));
            }, asyncTaskExecutor);
        }
        log.debug("五分钟一次定时任务开始加载,待调用数量[{}], 共耗时[{}]毫秒....", aboutToBeAdjustCount, (System.currentTimeMillis() - startTime));
    }

    private void addScheduleJob(String batchType) {
        List<SysJobVo> sysJobVos = jobDependentMapper.selectJobRefreshByType(batchType);
        for (SysJobVo sysJobVo : sysJobVos) {
            SysJobDependent queryJobDependent = new SysJobDependent();
            // 当前第一批次子任务大于在依赖表中存在其他任务组大于第一批次时，当前任务组不添加进调度中，等待事件调起
            queryJobDependent.setDependentId(sysJobVo.getJobId());
            queryJobDependent.setBatchIndex(1);
            List<SysJobDependent> sysJobDependents1 = jobDependentMapper.checkJobId(queryJobDependent);
            if (!CollectionUtils.isEmpty(sysJobDependents1)) {
                continue;
            }

            List<SysJobDependent> sysJobDependents = jobDependentMapper.selectJobDependent(queryJobDependent);

            // 查询当前任务组的第一批次任务
            String jobId = sysJobVo.getJobId();
            String invokeTarget = sysJobVo.getInvokeTarget();
            TaskParam taskParam = ScheduleUtils.parseInvokeTarget(invokeTarget, sysJobVo.getBatchType());
            String jobGroup = ScheduleUtils.getJobGroup(sysJobVo, taskParam);
            try {
                // 判断是否存在
                if (!scheduler.checkExists(ScheduleUtils.getJobKey(jobId, jobGroup))) {
                    ScheduleUtils.createScheduleJob(scheduler, sysJobVo);
                    jobMonitorService.addJobMonitor(sysJobVo, sysJobDependents.get(0).getJobId(), taskParam);
                }
            } catch (SchedulerException | TaskException e) {
                // throw new RuntimeException(e);
            }
        }
    }

    private Boolean getSwitchFlag(String switchType) {
        boolean switxhFlag = false;
        try {
            List<SysDictData> sysDictDataList = redisService.getCacheObject(CacheConstants.SYS_DICT_KEY + "job_switch");
            if (sysDictDataList != null) {
                for (SysDictData sysDictData : sysDictDataList) {
                    if (switchType.equals(sysDictData.getDictLabel())) {
                        String daySwitchStr = sysDictData.getDictValue();
                        switxhFlag = Boolean.parseBoolean(daySwitchStr);
                        break;
                    }
                }
            }
        } catch (Exception e) {
            switxhFlag = true;
        }
        return switxhFlag;
    }
}
