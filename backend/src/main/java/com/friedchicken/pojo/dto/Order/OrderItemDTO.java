package com.friedchicken.pojo.dto.Order;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OrderItemDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String productId;
    private int quantity;
    private double price;
}
