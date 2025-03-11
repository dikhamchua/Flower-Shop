package com.swp391.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.sql.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class Category {
    private Integer categoryId;
    private String name;
    private String description;
    private Byte status;
    private Date createdAt;
    private Date updatedAt;
}
