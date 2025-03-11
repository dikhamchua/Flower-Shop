package com.swp391.entity;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class Product {
    private int productId;
    private int categoryId;
    private String productName;
    private String description;
    private BigDecimal price;
    private int stock;
    private String image;
    private byte status;
    private int quantity;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}
