package com.friedchicken.pojo.entity.Order;

import com.friedchicken.pojo.dto.Order.OrderItemDTO;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderEmail implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private String orderId;
    private String userId;
    private String pharmacyAddress;
    private double amount;
    private int status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String username;
    private String email;
    private String nickname;
}
