package com.swp391.entity;

import java.sql.Timestamp;

import lombok.Data;
import lombok.ToString;
import lombok.Builder;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Blog {
    private int id;
    private String title;
    private String content;
    private int authorId;
    private String status; // 'published', 'hidden', 'draft'
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    
} 