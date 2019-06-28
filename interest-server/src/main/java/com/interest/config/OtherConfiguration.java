package com.interest.config;

import com.interest.properties.OtherProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.servlet.MultipartConfigElement;
import java.io.File;

@Configuration
public class OtherConfiguration {

    @Autowired
    private OtherProperties otherProperties;

    /**
     * 文件上传临时路径
     */
    @Bean
    public MultipartConfigElement multipartConfigElement() {
        String path = otherProperties.getTemporaryPath();
        File tmpFile = new File(path);
        if (!tmpFile.exists()) {
            tmpFile.mkdirs();
        }

        MultipartConfigFactory factory = new MultipartConfigFactory();
        factory.setLocation(otherProperties.getTemporaryPath());
        return factory.createMultipartConfig();
    }

}
