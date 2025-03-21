package com.swp391.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class CategoryProduct {
    private int categoryProductId;
    private int categoryId;
    private int productId;
    
    // Có thể thêm các trường bổ sung nếu cần
} 