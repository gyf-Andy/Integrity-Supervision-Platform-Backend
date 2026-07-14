package com.integrity.system.service;

import java.util.List;
import com.integrity.system.domain.SysNotice;

/**
 * 公告 服务层
 * 
 * @author Integrity-Supervision-Platform
 */
public interface ISysNoticeService
{
    /**
     * 查询公告信息
     * 
     * @param noticeId 公告ID
     * @return 公告信息
     */
    public SysNotice selectNoticeById(String noticeId);

    /**
     * 查询公告列表
     * 
     * @param notice 公告信息
     * @return 公告集合
     */
    public List<SysNotice> selectNoticeList(SysNotice notice);

    /**
     * 查询最新有效公告，用作顶栏铃铛下拉（不限权限，任何登录用户都能调用）。
     *
     * @param notice 过滤条件（仅会用到 noticeType，可传 null）
     * @param limit 取前 limit 条
     * @return 公告集合
     */
    public List<SysNotice> selectLatestNotices(SysNotice notice, int limit);

    /**
     * 新增公告
     * 
     * @param notice 公告信息
     * @return 结果
     */
    public int insertNotice(SysNotice notice);

    /**
     * 修改公告
     * 
     * @param notice 公告信息
     * @return 结果
     */
    public int updateNotice(SysNotice notice);

    /**
     * 删除公告信息
     * 
     * @param noticeId 公告ID
     * @return 结果
     */
    public int deleteNoticeById(String noticeId);
    
    /**
     * 批量删除公告信息
     * 
     * @param noticeIds 需要删除的公告ID
     * @return 结果
     */
    public int deleteNoticeByIds(String[] noticeIds);
}

