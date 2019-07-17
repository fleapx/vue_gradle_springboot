package com.interest.model.request;

import lombok.Data;

@Data
public class NoticeRequest {

    private Integer id;

    private Integer form;

    private String image;

    private String content;

    private String url;

    private String createTime;

}
