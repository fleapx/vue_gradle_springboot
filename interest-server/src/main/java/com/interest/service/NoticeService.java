package com.interest.service;

import com.interest.model.request.NoticeAddRequest;
import com.interest.model.request.NoticeRequest;
import com.interest.model.response.NoticeVO;
import com.interest.model.utils.PageResult;
import com.interest.model.utils.PageWrapper;

import java.util.List;

public interface NoticeService {
    void addNotice(NoticeAddRequest noticeAddRequest);

    void updateNotice(NoticeRequest noticeRequest);

    void delNotice(Integer id);

    PageResult<NoticeVO> getNoticeList(PageWrapper pageWrapper, Integer del, Integer form);

    List<NoticeVO> getNotices(Integer form);
}
