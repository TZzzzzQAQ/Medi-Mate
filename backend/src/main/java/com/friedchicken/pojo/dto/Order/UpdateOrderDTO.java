package com.friedchicken.pojo.dto.Order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class UpdateOrderDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private String orderId;
    private int pharmacyId;
    private double amount;
    private int status;
    private LocalDateTime updatedAt;
    private String cancelReason;
}
