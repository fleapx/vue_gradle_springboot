package com.interest.model.request;

import lombok.Data;

@Data
public class NoticeAddRequest {

    private Integer form;

    private String image;

    private String content;

    private String url;

}
