package com.friedchicken.pojo.entity.Order;

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
public class OrderItem implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String itemId;
    private String orderId;
    private String productId;
    private int quantity;
    private double price;
}
