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
public class OrderCombo {
    private Integer orderComboId;
    private Integer orderId;
    private Integer comboId;
    private String comboName;
    private BigDecimal comboDiscountPrice;
    private Integer quantity;
    private BigDecimal totalPrice;
}