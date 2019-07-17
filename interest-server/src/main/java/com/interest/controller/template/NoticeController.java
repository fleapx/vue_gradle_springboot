package com.interest.controller.template;

import com.interest.model.request.NoticeAddRequest;
import com.interest.model.request.NoticeRequest;
import com.interest.model.response.NoticeVO;
import com.interest.model.utils.PageResult;
import com.interest.model.utils.PageWrapper;
import com.interest.model.utils.ResponseWrapper;
import com.interest.service.NoticeService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Api("公告")
public class NoticeController {

    @Autowired
    private NoticeService noticeService;

    @PostMapping("/notices/notice")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN')")
    @ApiOperation("新建公告")
    public ResponseWrapper<String> addNotice(@RequestBody NoticeAddRequest noticeAddRequest) {

        noticeService.addNotice(noticeAddRequest);
        return new ResponseWrapper<>("success");
    }

    @PutMapping("/notices/notice")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN')")
    @ApiOperation("修改公告")
    public ResponseWrapper<String> updateNotice(@RequestBody NoticeRequest noticeRequest) {

        noticeService.updateNotice(noticeRequest);
        return new ResponseWrapper<>("success");
    }

    @DeleteMapping("/notices/notice/{id}")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN')")
    @ApiOperation("删除公告")
    public ResponseWrapper<String> delNotice(@PathVariable("id") Integer id) {

        noticeService.delNotice(id);
        return new ResponseWrapper<>("success");
    }

    @GetMapping("/notices")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN')")
    @ApiOperation("查询公告列表")
    public ResponseWrapper<PageResult<NoticeVO>> getNoticeList(@RequestParam("pageIndex") Integer pageIndex,
                                                               @RequestParam("pageSize") Integer pageSize,
                                                               @RequestParam("del") Integer del,
                                                               @RequestParam(value = "form",required = false) Integer form) {
        PageResult<NoticeVO> pageResult = noticeService.getNoticeList(new PageWrapper(pageSize, pageIndex), del, form);
        return new ResponseWrapper<>(pageResult);
    }

    @GetMapping("/public/notices")
    @ApiOperation("查询公告|public")
    public ResponseWrapper<List<NoticeVO>> getNotices(@RequestParam("form") Integer form) {
        return new ResponseWrapper<>(noticeService.getNotices(form));
    }

}
