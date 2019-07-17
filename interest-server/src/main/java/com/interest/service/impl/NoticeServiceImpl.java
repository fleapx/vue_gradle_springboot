package com.interest.service.impl;

import com.interest.dao.NoticeDao;
import com.interest.model.entity.NoticeEntity;
import com.interest.model.request.NoticeAddRequest;
import com.interest.model.request.NoticeRequest;
import com.interest.model.response.NoticeVO;
import com.interest.model.utils.PageResult;
import com.interest.model.utils.PageWrapper;
import com.interest.service.NoticeService;
import com.interest.utils.DateUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class NoticeServiceImpl implements NoticeService {

    @Autowired
    private NoticeDao noticeDao;

    @Override
    public void addNotice(NoticeAddRequest noticeAddRequest) {

        NoticeEntity noticeEntity = new NoticeEntity();
        BeanUtils.copyProperties(noticeAddRequest, noticeEntity);
        noticeEntity.setCreateTime(DateUtil.currentTimestamp());
        noticeEntity.setUpdateTime(noticeEntity.getCreateTime());

        log.info("insert | notice | data: {}", noticeEntity);
        noticeDao.addNotice(noticeEntity);

    }

    @Override
    public void updateNotice(NoticeRequest noticeRequest) {
        NoticeEntity noticeEntity = new NoticeEntity();
        BeanUtils.copyProperties(noticeRequest, noticeEntity);
        noticeEntity.setUpdateTime(DateUtil.currentTimestamp());

        log.info("update | notice | data: {}", noticeEntity);
        noticeDao.updateNotice(noticeEntity);
    }

    @Override
    public void delNotice(Integer id) {
        log.info("delete | notice | id: {}", id);
        noticeDao.delNotice(id);
    }

    @Override
    public PageResult<NoticeVO> getNoticeList(PageWrapper pageWrapper, Integer del, Integer form) {

        List<NoticeVO> noticeVOList = noticeDao.getNoticeList(pageWrapper, del, form);
        int totalCount = noticeDao.getNoticeSize(del, form);

        PageResult<NoticeVO> pageResult = new PageResult<>();
        pageResult.setData(noticeVOList);
        pageResult.setTotalCount(totalCount);
        return pageResult;
    }

    @Override
    public List<NoticeVO> getNotices(Integer form) {
        return noticeDao.getNotices(form);
    }
}
