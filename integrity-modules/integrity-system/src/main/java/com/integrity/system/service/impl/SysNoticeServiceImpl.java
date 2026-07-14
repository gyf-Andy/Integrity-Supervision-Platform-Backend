package com.integrity.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.integrity.common.core.utils.StringUtils;
import com.integrity.common.redis.service.IdGeneratorService;
import com.integrity.system.domain.SysNotice;
import com.integrity.system.mapper.SysNoticeMapper;
import com.integrity.system.service.ISysNoticeService;

/**
 * 公告 服务层实现
 * 
 * @author Integrity-Supervision-Platform
 */
@Service
public class SysNoticeServiceImpl implements ISysNoticeService
{
    @Autowired
    private SysNoticeMapper noticeMapper;

    @Autowired
    private IdGeneratorService idGeneratorService;

    /**
     * 查询公告信息
     * 
     * @param noticeId 公告ID
     * @return 公告信息
     */
    @Override
    public SysNotice selectNoticeById(String noticeId)
    {
        return noticeMapper.selectNoticeById(noticeId);
    }

    /**
     * 查询公告列表
     * 
     * @param notice 公告信息
     * @return 公告集合
     */
    @Override
    public List<SysNotice> selectNoticeList(SysNotice notice)
    {
        return noticeMapper.selectNoticeList(notice);
    }

    /**
     * 顶栏铃铛用：取最新的若干条有效公告。limit 上限 50，避免被滥用。
     */
    @Override
    public List<SysNotice> selectLatestNotices(SysNotice notice, int limit)
    {
        int safeLimit = limit > 0 && limit <= 50 ? limit : 5;
        SysNotice query = notice == null ? new SysNotice() : notice;
        return noticeMapper.selectLatestNotices(query, safeLimit);
    }

    /**
     * 新增公告
     * 
     * @param notice 公告信息
     * @return 结果
     */
    @Override
    public int insertNotice(SysNotice notice)
    {
        if (StringUtils.isEmpty(notice.getNoticeId()))
        {
            notice.setNoticeId(idGeneratorService.generateId("SN"));
        }
        return noticeMapper.insertNotice(notice);
    }

    /**
     * 修改公告
     * 
     * @param notice 公告信息
     * @return 结果
     */
    @Override
    public int updateNotice(SysNotice notice)
    {
        return noticeMapper.updateNotice(notice);
    }

    /**
     * 删除公告对象
     * 
     * @param noticeId 公告ID
     * @return 结果
     */
    @Override
    public int deleteNoticeById(String noticeId)
    {
        return noticeMapper.deleteNoticeById(noticeId);
    }

    /**
     * 批量删除公告信息
     * 
     * @param noticeIds 需要删除的公告ID
     * @return 结果
     */
    @Override
    public int deleteNoticeByIds(String[] noticeIds)
    {
        return noticeMapper.deleteNoticeByIds(noticeIds);
    }
}

