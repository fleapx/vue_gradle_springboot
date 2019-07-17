package com.interest.dao;

import com.interest.model.entity.NoticeEntity;
import com.interest.model.response.NoticeVO;
import com.interest.model.utils.PageWrapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface NoticeDao {
    void addNotice(NoticeEntity noticeEntity);

    void updateNotice(NoticeEntity noticeEntity);

    void delNotice(@Param("id") Integer id);

    List<NoticeVO> getNoticeList(@Param("page") PageWrapper pageWrapper, @Param("del") Integer del, @Param("form") Integer form);

    Integer getNoticeSize(@Param("del") Integer del, @Param("form") Integer form);

    List<NoticeVO> getNotices(@Param("form") Integer form);
}
