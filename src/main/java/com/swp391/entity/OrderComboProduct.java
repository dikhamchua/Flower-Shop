package com.swp391.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderComboProduct {
    private Integer orderComboProductId;
    private Integer orderComboId;
    private Integer productId;
    private String productName;
    private BigDecimal productPrice;
    private Integer quantityInCombo;
    private Integer totalQuantity;
}