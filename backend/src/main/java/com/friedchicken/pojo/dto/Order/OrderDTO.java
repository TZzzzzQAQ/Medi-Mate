package com.friedchicken.pojo.dto.Order;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OrderDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private String userId;
    private int pharmacyId;
    private double amount;
    private int status;
    private List<OrderItemDTO> orderItem;
}
