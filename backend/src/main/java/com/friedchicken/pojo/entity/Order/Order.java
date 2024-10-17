package com.friedchicken.pojo.entity.Order;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;


@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Order implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String orderId;
    private String userId;
    private int pharmacyId;
    private double amount;
    private int status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
