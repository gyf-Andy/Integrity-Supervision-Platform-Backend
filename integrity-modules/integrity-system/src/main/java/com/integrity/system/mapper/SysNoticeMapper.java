package com.integrity.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.integrity.system.domain.SysNotice;

/**
 * 通知公告表 数据层
 * 
 * @author Integrity-Supervision-Platform
 */
public interface SysNoticeMapper
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
     * 查询最新有效（status=0）公告，按创建时间倒序取前 limit 条，
     * 供顶栏铃铛下拉使用。不限权限——任何登录用户都可读。
     */
    public List<SysNotice> selectLatestNotices(@Param("notice") SysNotice notice, @Param("limit") int limit);

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
     * 批量删除公告
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
