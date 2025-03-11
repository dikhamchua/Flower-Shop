package com.swp391.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class Slider {
    private Integer sliderId;
    private String imageUrl;
    private String link;
    private String caption;
    private Byte status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
} 