/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import java.time.LocalDateTime;

/**
 * Entity class representing a product combo
 */
@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Combo {
    private Integer comboId;
    private String name;
    private String description;
    private Float originalPrice;
    private Float discountPrice;
    private String status; // ENUM('active', 'inactive')
    private String image; // New attribute for combo image
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}