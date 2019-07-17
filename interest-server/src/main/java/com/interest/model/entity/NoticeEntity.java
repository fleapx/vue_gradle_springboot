package com.interest.model.entity;

import lombok.Data;

@Data
public class NoticeEntity {

    private Integer id;

    private Integer form;

    private String image;

    private String content;

    private String url;

    private Integer del;

    private String createTime;

    private String updateTime;
}
