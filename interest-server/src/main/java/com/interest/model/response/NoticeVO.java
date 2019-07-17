package com.interest.model.response;

import lombok.Data;

@Data
public class NoticeVO {

    private Integer id;

    private Integer form;

    private String image;

    private String content;

    private String url;

    private String createTime;

    private String updateTime;

}
